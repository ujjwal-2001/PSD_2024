//====================================================//
// File Name    :   CPU.v
// Module Name  :   CPU
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   3
// Topic        :   32-bit RISC-V 5-stage Pipelined Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This is the top-level module of the 32-bit RISC-V 5-stage pipelined processor. The module connects
// the five stages of the pipeline - IF, ID, EXE, MEM, and WB. The module also contains the data
// forwarding unit and the stall unit to handle data and control hazards.
//----------------------------------------------------------------------------------------------------//

module CPU(
    input wire clock,       // Clock
    input wire reset,       // Reset
    output wire [31:0] RF1, // Register 1
    output wire [31:0] RF2, // Register 2
    output wire [31:0] RF3, // Register 3
    output wire [31:0] RF4, // Register 4
    output wire [31:0] RF5, // Register 5
    output wire [31:0] RF6, // Register 6
    output wire [31:0] RF7, // Register 7
    output wire [31:0] RF8, // Register 8
    output wire [31:0] RF9, // Register 9
    output wire [31:0] RF10 // Register 10
);

    wire [31:0] PC, PC_ID, PC_EXE;
    wire [31:0] Instruction;
    wire [3:0] FuncCode;
    wire [31:0] PCBranch, WriteData;
    reg  [31:0] WriteData_WB;
    wire [31:0] MemWriteData;
    wire PCSrc;
    wire RegWrite_ID, RegWrite_EXE, RegWrite_MEM;
    reg  RegWrite_WB;
    wire [4:0] WriteReg_ID, WriteReg_EXE, WriteReg_MEM;
    reg  [4:0] WriteReg_WB;
    wire Branch_ID, Branch_EXE;
    wire Jump_ID, Jump_EXE;
    wire [1:0] ALUOp_ID;
    wire ALUSrc_ID;
    wire sw_ID, sw_EXE;
    wire sh_ID, sh_EXE;
    wire sb_ID, sb_EXE;
    wire lw_ID, lw_EXE;
    wire lh_ID, lh_EXE;
    wire lhu_ID, lhu_EXE;
    wire lb_ID, lb_EXE;
    wire lbu_ID, lbu_EXE;
    wire MemWrite_ID, MemWrite_EXE;
    wire [1:0] MemtoReg_ID, MemtoReg_EXE, MemtoReg_MEM;
    wire [31:0] ReadData1, ReadData2, ReadData;
    wire [31:0] Immediate, Immediate_EXE, Immediate_MEM;
    wire Zero;
    wire [31:0] ALUResult, ALUResult_MEM;

    // Data Forwarding unit - data hazards
    reg [1:0] ForwardA, ForwardB;
    reg [31:0] ForwardDataA, ForwardDataB;
    wire [4:0] ReadReg1_ID, ReadReg2_ID;

    always@(*) begin        // Forwarding unit combinational logic
        if(RegWrite_EXE && WriteReg_EXE!=0 && WriteReg_EXE==ReadReg1_ID)begin
            ForwardA = 2'b11;
        end
        else if(RegWrite_MEM && WriteReg_MEM!=0 && WriteReg_MEM==ReadReg1_ID)begin
            ForwardA = 2'b10;
        end
        else if(RegWrite_WB && WriteReg_WB!=0 && WriteReg_WB==ReadReg1_ID)begin
            ForwardA = 2'b01;
        end
        else begin
            ForwardA = 2'b00;
        end

        if(RegWrite_EXE && WriteReg_EXE!=0 && WriteReg_EXE==ReadReg2_ID)begin
            ForwardB = 2'b11;
        end
        else if(RegWrite_MEM && WriteReg_MEM!=0 && WriteReg_MEM==ReadReg2_ID)begin
            ForwardB = 2'b10;
        end
        else if(RegWrite_WB && WriteReg_WB!=0 && WriteReg_WB==ReadReg2_ID)begin
            ForwardB = 2'b01;
        end
        else begin
            ForwardB = 2'b00;
        end
    end

    always@(*)begin         // Forwarding unit data selection/mux
        case(ForwardA)
            2'b00: ForwardDataA = ReadData1;
            2'b01: ForwardDataA = WriteData_WB;
            2'b10: ForwardDataA = WriteData;
            2'b11: ForwardDataA = ALUResult;
            default: ForwardDataA = ReadData1;
        endcase

        case(ForwardB)
            2'b00: ForwardDataB = ReadData2;
            2'b01: ForwardDataB = WriteData_WB;
            2'b10: ForwardDataB = WriteData;
            2'b11: ForwardDataB = ALUResult;
            default: ForwardDataB = ReadData2;
        endcase
    end

    // Stall unit - data and control hazards
    reg PC_en, IF_en, Discard_ID;

    always@(*)begin        // Stall unit combinational logic
        if((lw_ID || lh_ID || lhu_ID || lb_ID || lbu_ID) && (WriteReg_ID == Instruction[19:15] || WriteReg_ID == Instruction[24:20]))begin
            PC_en = 0;
            IF_en = 0;
            Discard_ID = 1;  
        end else begin
            PC_en = 1;
            IF_en = 1;
            Discard_ID = 0;
        end
    end

    // Write Back stage
    assign WriteData = (MemtoReg_MEM[1])? Immediate_MEM : (MemtoReg_MEM[0])? ReadData : ALUResult_MEM;

    always@(posedge clock)begin
        if(reset)begin
            WriteData_WB <= 0;
            RegWrite_WB <= 0;
            WriteReg_WB <= 0;
        end
        else begin
            WriteData_WB <= WriteData;
            RegWrite_WB <= RegWrite_MEM;
            WriteReg_WB <= WriteReg_MEM;
        end
    end

    IF IF(                  // Instruction fetch
        .clock(clock),
        .reset(reset),
        .PCSrc(PCSrc),
        .PCBranch(PCBranch),
        .PC_en(PC_en),
        .IF_en(IF_en),
        .Instruction(Instruction),
        .PC(PC)
    );

    ID ID(                  // Instruction decode
        .clock(clock),
        .reset(reset),
        .Discard_ID(Discard_ID),
        .Instruction(Instruction),
        .PC_IF(PC),
        .RegWrite_MEM(RegWrite_MEM),
        .WriteReg_MEM(WriteReg_MEM),
        .WriteData(WriteData),
        .PC_ID(PC_ID),
        .Branch_ID(Branch_ID),
        .Jump_ID(Jump_ID),
        .MemWrite_ID(MemWrite_ID),
        .ALUOp_ID(ALUOp_ID),
        .MemtoReg_ID(MemtoReg_ID),
        .RegWrite_ID(RegWrite_ID),
        .ALUSrc_ID(ALUSrc_ID),
        .sw_ID(sw_ID),
        .sh_ID(sh_ID),
        .sb_ID(sb_ID),
        .lw_ID(lw_ID),
        .lh_ID(lh_ID),
        .lhu_ID(lhu_ID),
        .lb_ID(lb_ID),
        .lbu_ID(lbu_ID),
        .ReadReg1_ID(ReadReg1_ID),
        .ReadReg2_ID(ReadReg2_ID),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .WriteReg_ID(WriteReg_ID),
        .Immediate(Immediate),
        .FuncCode(FuncCode),
        .RF1(RF1),
        .RF2(RF2),
        .RF3(RF3),
        .RF4(RF4),
        .RF5(RF5),
        .RF6(RF6),
        .RF7(RF7),
        .RF8(RF8),
        .RF9(RF9),
        .RF10(RF10)
    );

    EXE EXE(                // Execute
        .clock(clock),
        .reset(reset),
        .PC_ID(PC_ID),
        .Branch_ID(Branch_ID),
        .Jump_ID(Jump_ID),
        .MemWrite_ID(MemWrite_ID),
        .ALUOp_ID(ALUOp_ID),
        .MemtoReg_ID(MemtoReg_ID),
        .RegWrite_ID(RegWrite_ID),
        .ALUSrc_ID(ALUSrc_ID),
        .sw_ID(sw_ID),
        .sh_ID(sh_ID),
        .sb_ID(sb_ID),
        .lw_ID(lw_ID),
        .lh_ID(lh_ID),
        .lhu_ID(lhu_ID),
        .lb_ID(lb_ID),
        .lbu_ID(lbu_ID),
        .ForwardDataA(ForwardDataA),
        .ForwardDataB(ForwardDataB),
        .WriteReg_ID(WriteReg_ID),
        .Immediate(Immediate),
        .FuncCode(FuncCode),
        .ALUResult(ALUResult),
        .Zero(Zero),
        .Branch_EXE(Branch_EXE),
        .Jump_EXE(Jump_EXE),
        .MemWrite_EXE(MemWrite_EXE),
        .MemtoReg_EXE(MemtoReg_EXE),
        .RegWrite_EXE(RegWrite_EXE),
        .sw_EXE(sw_EXE),
        .sh_EXE(sh_EXE),
        .sb_EXE(sb_EXE),
        .lw_EXE(lw_EXE),
        .lh_EXE(lh_EXE),
        .lhu_EXE(lhu_EXE),
        .lb_EXE(lb_EXE),
        .lbu_EXE(lbu_EXE),
        .PCBranch(PCBranch),
        .Immediate_EXE(Immediate_EXE),
        .MemWriteData(MemWriteData),
        .WriteReg_EXE(WriteReg_EXE)
    );

    MEM MEM(                // Memory
        .clock(clock),
        .reset(reset),
        .Branch_EXE(Branch_EXE),
        .Jump_EXE(Jump_EXE),
        .MemWrite_EXE(MemWrite_EXE),
        .MemtoReg_EXE(MemtoReg_EXE),
        .RegWrite_EXE(RegWrite_EXE),
        .sw_EXE(sw_EXE),
        .sh_EXE(sh_EXE),
        .sb_EXE(sb_EXE),
        .lw_EXE(lw_EXE),
        .lh_EXE(lh_EXE),
        .lhu_EXE(lhu_EXE),
        .lb_EXE(lb_EXE),
        .lbu_EXE(lbu_EXE),
        .WriteReg_EXE(WriteReg_EXE),
        .Zero(Zero),
        .ALUResult(ALUResult),
        .MemWriteData(MemWriteData),
        .Immediate_EXE(Immediate_EXE),
        .ReadData(ReadData),
        .ALUResult_MEM(ALUResult_MEM),
        .Immediate_MEM(Immediate_MEM),
        .MemtoReg_MEM(MemtoReg_MEM),
        .RegWrite_MEM(RegWrite_MEM),
        .PCSrc(PCSrc),
        .WriteReg_MEM(WriteReg_MEM)
    );

endmodule
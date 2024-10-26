//====================================================//
// File Name    :   ID.v
// Module Name  :   ID
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   3
// Topic        :   32-bit RISC-V 5-stage Pipelined Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// 
//----------------------------------------------------------------------------------------------------//

module ID(
    input wire clock, reset,
    input wire [31:0] Instruction,
    input wire [31:0] PC_IF,
    input wire RegWrite_MEM,
    input wire [4:0] WriteReg_MEM,
    input wire [31:0] WriteData,
    output reg [31:0] PC_ID,
    output reg Branch_ID, Jump_ID, MemWrite_ID, 
    output reg [1:0] ALUOp_ID, MemtoReg_ID,
    output reg RegWrite_ID, ALUSrc_ID,
    output reg sw_ID, sh_ID, sb_ID,
    output reg lw_ID, lh_ID, lhu_ID, lb_ID, lbu_ID,
    output wire [31:0] ReadData1, ReadData2,
    output reg [4:0] WriteReg_ID,
    output reg [31:0] RF1, RF2, RF3, RF4, RF5, RF6, RF7, RF8, RF9, RF10,
    output reg [31:0] Immediate,
    output reg [3:0] FuncCode
);
    wire Branch, Jump, MemWrite; 
    wire [1:0] ALUOp, MemtoReg;
    wire RegWrite, ALUSrc;
    wire sw, sh, sb;
    wire lw, lh, lhu, lb, lbu;
    wire [31:0] Immediate_d;

    always @(posedge clock) begin
        if (reset) begin
            PC_ID <= 32'd0;
            {Branch_ID, Jump_ID, MemWrite_ID} <= 3'b000;
            {ALUOp_ID, MemtoReg_ID, RegWrite_ID, ALUSrc_ID} <= 6'b0;
            {sw_ID, sh_ID, sb_ID} <= 3'b000;
            {lw_ID, lh_ID, lhu_ID, lb_ID, lbu_ID} <= 5'b00000;
            WriteReg_ID <= 5'b00000;
            Immediate <= 32'd0;
            FuncCode <= 4'd0;
        end
        else begin
            PC_ID <= PC_IF;
            Branch_ID <= Branch;
            Jump_ID <= Jump;
            MemWrite_ID <= MemWrite;
            ALUOp_ID <= ALUOp;
            MemtoReg_ID <= MemtoReg;
            RegWrite_ID <= RegWrite;
            ALUSrc_ID <= ALUSrc;
            {sw_ID, sh_ID, sb_ID} <= {sw, sh, sb};
            {lw_ID, lh_ID, lhu_ID, lb_ID, lbu_ID} <= {lw, lh, lhu, lb, lbu};
            WriteReg_ID <= Instruction[11:7];
            Immediate <= Immediate_d;
            FuncCode  <= {Instruction[30], Instruction[14:12]};
        end
    end

    Control ControlUnit (
        .funct3(Instruction[14:12]),
        .opcode(Instruction[6:0]),
        .Branch(Branch),
        .Jump(Jump),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .sw(sw),
        .sh(sh),
        .sb(sb),
        .lw(lw),
        .lh(lh),
        .lhu(lhu),
        .lb(lb),
        .lbu(lbu)
    );

    RegisterFile RegisterFile (
        .clock(clock),
        .reset(reset),
        .Read1(Instruction[19:15]),
        .Read2(Instruction[24:20]),
        .WriteReg(WriteReg_MEM),
        .WriteData(WriteData),
        .RegWrite(RegWrite_MEM),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
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

    ImmGen ImmGen(                      // Immediate generator
        .Instruction(Instruction),
        .Immediate(Immediate_d)
    );

endmodule
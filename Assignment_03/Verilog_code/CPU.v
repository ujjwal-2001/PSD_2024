//====================================================//
// File Name    :   CPU.v
// Module Name  :   CPU
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   3
// Topic        :   32-bit RISC-V 5-stage Pipelined Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This is a 32-bit RISC-V single-cycle processor module that implements a simple 32-bit RISC-V processor.
// The processor has a 32-bit instruction memory, a 32-bit data memory, a register file, an ALU, an ALU
// control unit, a control unit, and an immediate generator. The processor executes instructions in a
// single cycle. The processor has the following components:
// 1. Instruction memory: A 32-bit instruction memory that stores the instructions to be executed.
// 2. Data memory: A 32-bit data memory that stores the data to be read and written.
// 3. Register file: A register file that stores the register values.
// 4. ALU: An arithmetic logic unit that performs arithmetic and logical operations.
// 5. ALU control unit: An ALU control unit that generates a 4-bit control signal based on the 2-bit ALUOp
//    and 4-bit FuncCode inputs.
// 6. Control unit: A control unit that generates control signals based on the opcode of the instruction.
// 7. Immediate generator: An immediate generator that generates the immediate value for the instruction.
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
    wire PCSrc;
    wire RegWrite_ID, RegWrite_EXE, RegWrite_MEM;
    wire [4:0] WriteReg_ID, WriteReg_EXE, WriteReg_MEM;
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

    assign WriteData = (MemtoReg_MEM[1])? Immediate_MEM : (MemtoReg_MEM[0])? ReadData : ALUResult_MEM;

    IF IF(
        .clock(clock),
        .reset(reset),
        .PCSrc(PCSrc),
        .PCBranch(PCBranch),
        .Instruction(Instruction),
        .PC(PC)
    );

    ID ID(
        .clock(clock),
        .reset(reset),
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
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .WriteReg_ID(WriteReg_ID),
        .Immediate(Immediate),
        .FuncCode(FuncCode)
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

    EXE EXE(
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
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
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
        .WriteData(WriteData),
        .WriteReg_EXE(WriteReg_EXE)
    );

    MEM MEM(
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
        .ALUResult(ALUResult),
        .WriteData(WriteData),
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
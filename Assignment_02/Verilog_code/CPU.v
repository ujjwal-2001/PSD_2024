//====================================================//
// File Name    :   CPU.v
// Module Name  :   CPU
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//

//----------------------------------------------------------------------------------------------------//

module CPU(
    input wire clk,
    input wire reset,
);

    wire Branch, MemRead, MemtoReg;
    wire [1:0] ALUOp;
    wire [3:0] ALUCtl, FuncCode;
    wire MemWrite, ALUSrc, RegWrite;
    wire [31:0] PC, PC1, PCBranch, PCNext;
    wire [31:0] Instruction;
    wire [31:0] ReadData1, ReadData2, WriteData;
    wire [31:0] Immediate, B, ALUResult, ReadData;
    wire zero;

    assign B = (ALUSrc)? Immediate : ReadData2?
    assign FuncCode = {Instruction[30], Instruction[14:12]};
    assign WriteData = (MemtoReg)? ReadData : ALUResult;
    assign PCBranch = PC + (Immediate<<1);
    assign PCNext = (Branch & Zero)? PCBranch : (PC+1);

    always@(posedge clk)begin
        PC <= (reset)? 32'd0 : PCNext;   
    end

    dist_mem_gen_1 InstructionMem(
        .a(PC);
        .d(32'd0);
        .clk(clk);
        .we(1'b0);
        .spo(Instruction)
    );

    Control ControlUnit(
        .opcode(Instruction[6:0]);
        .Branch(Branch);
        .MemRead(MemRead);
        .MemtoReg(MemtoReg);
        .ALUOp(ALUOp);
        .MemWrite(MemWrite);
        .ALUSrc(ALUSrc);
        .RegWrite(RegWrite);
    );

    RegisterFile RegFile(
        .clk(clk);
        .reset(reset);
        .RegWrite(RegWrite);
        .ReadReg1(Instruction[19:15]);
        .ReadReg2(Instruction[24:20]);
        .WriteReg(Instruction[11:7]);
        .WriteData(WriteData);
        .ReadData1(ReadData1);
        .ReadData2(ReadData2);
    );

    ImmGen ImmGen(
        .Instruction(Instruction),
        .Immediate(Immediate)
    );

    ALUControl ALUControl(
        .ALUOp(ALUOp),
        .FuncCode(FuncCode),
        .ALUCtl(ALUCtl)
    );

    ALU ALU(
        .ALUCtl(ALUCtl),
        .A(ReadData1),
        .B(B),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    dist_mem_gen_1 DataMem(
        .a(ALUResult);
        .d(ReadData2);
        .clk(clk);
        .we(MemWrite);
        .spo(ReadData);
    );

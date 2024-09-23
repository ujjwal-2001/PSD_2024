//====================================================//
// File Name    :   CPU.v
// Module Name  :   CPU
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
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
    input wire clock,     // Clock
    input wire reset,   // Reset
);

    wire Branch, MemRead, MemtoReg;                     // Control signals
    wire [1:0] ALUOp;                                   // ALU operation code
    wire [3:0] ALUCtl, FuncCode;                        // ALU control signal
    wire MemWrite, ALUSrc, RegWrite;                    // Control signals
    wire [31:0] PC, PCBranch, PCNext;                   // Program counter
    wire [31:0] Instruction;                            // Instruction
    wire [31:0] ReadData1, ReadData2, WriteData;        // Data
    wire [31:0] Immediate, B, ALUResult, ReadData;      // Data
    wire zero;

    assign B = (ALUSrc)? Immediate : ReadData2?                 // Select B
    assign FuncCode  = {Instruction[30], Instruction[14:12]};   // Extract FuncCode
    assign WriteData = (MemtoReg)? ReadData : ALUResult;        // Select WriteData
    assign PCBranch  = PC + Immediate;                          // Calculate PCBranch
    assign PCNext    = (Branch & Zero)? PCBranch : (PC+1);      // Calculate PCNext

    always@(posedge clk)begin                             // Update PC
        PC <= (reset)? 32'd0 : PCNext;   
    end

    dist_mem_gen_1 InstructionMem(        // Instruction memory
        .a(PC);
        .d(32'd0);
        .clk(clk);
        .we(1'b0);
        .spo(Instruction)
    );

    Control ControlUnit(                // Control unit
        .opcode(Instruction[6:0]);
        .Branch(Branch);
        .MemRead(MemRead);
        .MemtoReg(MemtoReg);
        .ALUOp(ALUOp);
        .MemWrite(MemWrite);
        .ALUSrc(ALUSrc);
        .RegWrite(RegWrite);
    );

    RegisterFile RegFile(               // Register file
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

    ImmGen ImmGen(                      // Immediate generator
        .Instruction(Instruction),
        .Immediate(Immediate)
    );

    ALUControl ALUControl(              // ALU control
        .ALUOp(ALUOp),
        .FuncCode(FuncCode),
        .ALUCtl(ALUCtl)
    );

    ALU ALU(                            // ALU
        .ALUCtl(ALUCtl),
        .A(ReadData1),
        .B(B),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    dist_mem_gen_1 DataMem(             // Data memory
        .a(ALUResult);
        .d(ReadData2);
        .clk(clk);
        .we(MemWrite);
        .spo(ReadData);
    );

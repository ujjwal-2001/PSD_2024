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

    // Control signals
    wire Branch, Jump;                         
    wire MemWrite, ALUSrc, RegWrite;                    
    wire sw, sh, sb, lw, lh, lhu, lb, lbu;              
    wire [1:0] ALUOp, MemtoReg;    

    // ALU control signal
    wire [3:0] ALUCtl, FuncCode;     

    // Program counter                   
    reg  [31:0] PC;
    wire [31:0] PCBranch, PCNext;

    // Other wires
    wire [31:0] Instruction;                            // Instruction
    wire [4:0]  WriteReg, Read1, Read2;                 // Register
    wire [31:0] ReadData1, ReadData2, WriteData;        // Data
    wire [31:0] Immediate, B, ALUResult, ReadData;      // Data
    wire Zero;                                          // Zero flag
    
    // Assignments
    assign Read1     = Instruction[19:15];                              // Select Read1
    assign Read2     = Instruction[24:20];                              // Select Read2
    assign WriteReg  = Instruction[11:7];                               // Select WriteReg
    assign WriteData = (MemtoReg[1])? Immediate : (MemtoReg[0])? ReadData : ALUResult; // Select WriteData
    assign B         = (ALUSrc)? Immediate : ReadData2;                 // Select B
    assign FuncCode  = {Instruction[30], Instruction[14:12]};           // Extract FuncCode
    assign PCBranch  = PC + Immediate;                                  // Calculate PCBranch
    assign PCNext    = ((Branch & Zero) | Jump)? PCBranch : (PC+1);     // Calculate PCNext

    // Register for program counter
    always@(posedge clock)begin
        PC <= (reset)? 32'd0 : PCNext;   
    end

    // Module instances
    dist_mem_gen_0 InstructionMem(        // Instruction memory
        .a(PC[9:0]),
        .d(32'd0),
        .clk(clock),
        .we(1'b0),
        .spo(Instruction)
    );

    Control ControlUnit(                // Control unit
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

    RegisterFile RegFile(               // Register file
        .clock(clock),
        .reset(reset),
        .RegWrite(RegWrite),
        .Read1(Read1),
        .Read2(Read2),
        .WriteReg(WriteReg),
        .WriteData(WriteData),
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

    DataMem DataMem(                    // Data memory
        .clock(clock),
        .Address(ALUResult),
        .WriteData(ReadData2),
        .MemWrite(MemWrite),
        .sw(sw),
        .sh(sh),
        .sb(sb),
        .lw(lw),
        .lh(lh),
        .lhu(lhu),
        .lbu(lbu),
        .lb(lb),
        .ReadData(ReadData)
    );

endmodule
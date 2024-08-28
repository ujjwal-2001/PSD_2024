//====================================================//
// File Name:   DataPath.v
// Module Name: DataPath
// Author:      Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course:      E3 245 Processor System Design
// Assignment:  1
// Topic:       16-bit Multi-cycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION-----------------------------------------------//
// This is a datapath module that contains the main components of a MIPS processor. The module contains
// a program counter (PC), memory, memory data register (MDR), instruction register (IR), ALU, register
// file, and ALU control unit. The module performs the following operations:
// 1. Read data from the register file
// 2. Write data to the register file
// 3. Perform ALU operations based on the ALU control signal
// 4. Update the program counter based on the PC source control
// 5. Read and write data to memory based on memory control signals
// 6. Perform conditional PC writes based on the ALU zero flag
// 7. Sign-extend offsets and calculate jump addresses
// 8. Select ALU inputs based on ALU source control signals
// 9. Generate the opcode from the instruction register
// The module is synchronous and updates the components on the positive edge of the clock signal.
//--------------------------------------------------------------------------------------------------------//
// `include "ALU.v"
// `include "RegisterFile.v"
// `include "ALUControl.v"

module DataPath ( 
    input [1:0] ALUOp,      // ALU operation control
    input [1:0] ALUSrcB,    // ALU register B input control
    input [1:0] PCSource,   // PC source control
    input RegDst,           // Register destination control
    input MemtoReg,         // Memory to register control
    input MemRead,          // Memory read control
    input MemWrite,         // Memory write control
    input IorD,             // Memory address control
    input RegWrite,         // Register write control
    input IRWrite,          // Instruction Register write control
    input PCWrite,          // PC write control
    input PCWriteCond,      // Conditional PC write control
    input ALUSrcA,          // ALU register A input control
    input clock,            // Clock signal
    output [2:0] opcode     // Opcode output
    );

    reg [15:0] PC, Memory[0:1023];          // Program counter and memory
    reg [15:0] MDR, IR;                     // Memory data register and instruction register
    reg [15:0] ALUOut;                      // ALU output
    reg [15:0] PCValue, ALUBin;             // PC value and ALU B input
    wire [15:0] A, B;                       // Register file read data
    wire [15:0] SignExtendOffset;           // Sign-extended offset
    wire [15:0] PCOffset, ALUResultOut;     // PC offset and ALU result
    wire [15:0] JumpAddr, MemOut;           // Jump address and memory output
    wire [15:0] Writedata, ALUAin;          // Write data and ALU input A
    wire [3:0] ALUCtl;                      // ALU control bits
    wire Zero;                              // ALU zero flag output        
    wire[2:0] Writereg;                     // Write register address

    initial PC = 0; //start the PC at 0
                                                    
    assign MemOut = MemRead ? Memory[(IorD ? ALUOut : PC)>>2]:0;    // Read memory if MemRead ******** >>2
    assign opcode = IR[15:13];          //get the opcode from the IR
    assign Writereg = RegDst ? IR[6:4]: IR[9:7];        // Get the write register number
    assign Writedata = MemtoReg ? MDR : ALUOut;         // Get the data to write to the register
    assign SignExtendOffset = {{9{IR[15]}},IR[6:0]};    // Sign-extend the offset
    assign PCOffset = SignExtendOffset << 1;            // Shift the offset left by 1
    assign ALUAin = ALUSrcA ? A : PC;                   // Select the A input to the ALU
    assign JumpAddr = {PC[15], IR[12:0],2'b0};          // The jump address

    ALUControl alucontroller (      // ALU control unit
        .ALUOp(ALUOp),                      // ALU operation code
        .FuncCode(IR[3:0]),                 // Function code
        .ALUCtl(ALUCtl)                     // ALU control bits
    ); 
    
    always@(*) begin                 
        case(PCSource)              // Select the PC source
            2'b00: PCValue = ALUResultOut;      // Incremented PC
            2'b01: PCValue = ALUOut;            // Branch
            2'b10: PCValue = JumpAddr;          // Jump
            default: PCValue = ALUResultOut;    // Default
        endcase

        case(ALUSrcB)               // Select the B input to the ALU
            2'b00: ALUBin = B;                  // Register B
            2'b01: ALUBin = 16'd2;              // Constant 2
            2'b10: ALUBin = SignExtendOffset;   // Sign-extended offset
            2'b11: ALUBin = PCOffset;           // Sign-extended offset << 2
        endcase
    end

    ALU alu(
        .ALUCtl(ALUCtl),
        .A(ALUAin),
        .B(ALUBin),
        .ALUResultOut(ALUResultOut),
        .Zero(Zero)
    );

    RegisterFile regs (
        .Read1(IR[12:10]),
        .Read2(IR[9:7]),
        .WriteReg(Writereg),
        .WriteData(Writedata),
        .RegWrite(RegWrite),
        .clock(clock),
        .Data1(A),
        .Data2(B)
    ); 

    // The clock-triggered actions of the datapath
    always @(posedge clock) begin 
        if (MemWrite) Memory[ALUOut<<1] <= B;   // Write to memory if MemWrite
        ALUOut <= ALUResultOut;                 // Save the ALU result for use on a later clock cycle
        if (IRWrite) IR <= MemOut;              // Write the IR if an instruction fetch 
        MDR <= MemOut;                          // Always save the memory read value
        if (PCWrite || (PCWriteCond & Zero)) PC <= PCValue;     // Update the PC if a write is enabled
    end 

endmodule
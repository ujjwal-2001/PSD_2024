//====================================================//
// File Name    :   DataPath.v
// Module Name  :   DataPath
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   1
// Topic        :   16-bit Multi-cycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION-----------------------------------------------//
// This is a datapath module that contains the main components of a MIPS processor. The module contains
// a program counter (PC), memory, instruction register (IR), instruction prefetch register (IPR), ALU, register
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
//------------------------------------------------------------------------------------------------------//

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
    input IPRWrite,         // Instruction Prefetch Register write control
    input IRWrite,          // Instruction Register write control
    input IRSrc,            // Instruction Register source control
    input PCWrite,          // PC write control
    input PCWriteCond,      // Conditional PC write control
    input ALUSrcA,          // ALU register A input control
    input clock,            // Clock signal
    input reset,            // Reset signal
    output [2:0] opcode,    // Opcode output
    output [15:0] R1        // Register 1 output
    );

    reg [15:0] PC;                          // Program counter
    reg [15:0] IPR;                         // Instruction Prefetch register
    reg [15:0] IR;                          // Instruction register
    reg [15:0] ALUOut;                      // ALU output
    reg [15:0] PCValue, ALUBin;             // PC value and ALU B input
    reg [15:0] A, B;                        // Register A and B
    wire [15:0] MemoryAddress;              // Memory address
    wire [15:0] ReadData1, ReadData2;       // Register file read data
    wire [15:0] SignExtendOffset;           // Sign-extended offset
    wire [15:0] PCOffset, ALUResultOut;     // PC offset and ALU result
    wire [15:0] JumpAddr, MemOut;           // Jump address and memory output
    wire [15:0] Writedata, ALUAin;          // Write data and ALU input A
    wire [3:0] ALUCtl;                      // ALU control bits
    wire Zero;                              // ALU zero flag output 
    wire PCWriteEn;                         // PC write enable       
    wire[2:0] Writereg;                     // Write register address

    assign MemoryAddress    = IorD ? ALUOut : PC;       // Select the memory address
    assign SignExtendOffset = {{9{IR[6]}},IR[6:0]};     // Sign-extend the offset                                              
    assign opcode    = IR[15:13];                       // get the opcode from the IR
    assign Writereg  = RegDst ? IR[6:4]: IR[9:7];       // Get the write register number
    assign Writedata = MemtoReg ? MemOut : ALUOut;      // Get the data to write to the register
    assign PCOffset  = SignExtendOffset;                // The offset for a branch
    assign ALUAin    = ALUSrcA ? A : PC;                // Select the A input to the ALU
    assign JumpAddr  = {PC[15:13], IR[12:0]};           // The jump address
    assign PCWriteEn = PCWrite || (PCWriteCond & Zero); // Enable the PC write if either control signal is high

    blk_mem_gen_0 Memory (
        .clka(clock),
        .ena(1'b1),
        .wea(MemWrite),
        .addra(MemoryAddress),
        .dina(ALUOut),
        .clkb(clock),
        .enb(MemRead),
        .addrb(MemoryAddress),
        .doutb(MemOut)
    );
    
    ALUControl alucontroller (      // ALU control unit
        .ALUOp(ALUOp),                      // ALU operation code
        .FuncCode(IR[3:0]),                 // Function code
        .ALUCtl(ALUCtl)                     // ALU control bits
    ); 
    
    always@(*) begin                 
        case(PCSource)              // Select the PC source
            2'b00: PCValue   = ALUResultOut;      // Incremented PC
            2'b01: PCValue   = ALUOut;            // Branch
            2'b10: PCValue   = JumpAddr;          // Jump
            default: PCValue = ALUResultOut;      // Default
        endcase

        case(ALUSrcB)               // Select the B input to the ALU
            2'b00: ALUBin = B;                  // Register B
            2'b01: ALUBin = 16'd1;              // Constant 1
            2'b10: ALUBin = SignExtendOffset;   // Sign-extended offset
            2'b11: ALUBin = PCOffset;           // Sign-extended offset 
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
        .reset(reset),
        .Data1(ReadData1),
        .Data2(ReadData2),
        .R1(R1)
    ); 

    // The clock-triggered actions of the datapath
    always @(posedge clock) begin 

        if (reset) begin
            PC      <= 0;       // Reset the PC
            A       <= 0;       // Reset register A
            B       <= 0;       // Reset register B
            ALUOut  <= 0;       // Reset the ALU output
            IR      <= 0;       // Reset the instruction register
            IPR     <= 0;       // Reset instruction prefetch register
        end
        else begin
            A <= ReadData1;     // Read data from register 1
            B <= ReadData2;     // Read data from register 2

            ALUOut <= ALUResultOut;                 // Save the ALU result for use on a later clock cycle
            IPR    <= (IPRWrite)? MemOut : IPR;     // Write the IPR if an instruction fetch is enabled 
            PC     <= (PCWriteEn)? PCValue : PC;    // Update the PC if a write is enabled
            
            if (IRWrite) begin
                IR <= (IRSrc)? IPR : MemOut; // Write the IR if an instruction fetch is enabled according to the source
            end
            else begin
                IR <= IR; // Keep the IR the same
            end 
        end
    end 

endmodule
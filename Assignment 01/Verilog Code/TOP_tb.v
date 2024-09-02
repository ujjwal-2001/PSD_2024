//======================================================//
// File Name    :   TOP_tb.v
// Module Name  :   TOP_tb
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   1
// Topic        :   16-bit Multi-cycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION-----------------------------------------------//
// This is a testbench module for the 16-bit Multi-cycle Processor. The momory contains an array of 10 numbers
// and set of instructions that determines the maximum amoung them and displays it on the BCD7Segment display.
// The testbench module instantiates the TOP module and provides the clock and reset signals to the module.
// The module also provides the input data to the CPU module and the clock signal to the BCD7Segment module.
//--------------------------------------------------------------------------------------------------------//

`timescale 1ns / 1ps

module TOP_tb();

    reg clock100Mhz;  // 100 Mhz clock source on Basys 3 FPGA
    reg reset;        // reset
    reg clock;        // Clock signal

    TOP TOP (
        .clock100Mhz(clock100Mhz), 
        .reset(reset), 
        .clock(clock)
    );

    initial begin
        clock100Mhz = 0;
        reset = 1;
        clock = 0;
        #10 reset = 0;
    end

    always begin
        #5 clock = ~clock;
    end
    
    always begin
        #5 clock100Mhz = ~clock100Mhz; // 
    end
endmodule

//=================Instructions in instructions.coe file=================//
//   The 10 numbers are stored in the memory from the location 50 to 59
//   or 0x32 to 0x3B. The instructions are stored from the location
//   0 to 15 or 0x00 to 0x0F. The instructions are as follows:
//
//  |+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
//  | Address |    Instruction   |          Remark          |   16-bit  representation  |
//  |+++++++++|++++++++++++++++++|++++++++++++++++++++++++++|+++++++++++++++++++++++++++|
//  | 0x00    | LD R0,R1,50      | R1 <= M[R0 + 50]         | 001 000 001 0110010       |  keeping 1st number in R1
//  | 0x01    | ADDi R0,R2,1     | R2 <= R0 + 1             | 101 000 010 0000001       |  R2 is the increment counter
//  | 0X02    | ADDi R0,R5,10    | R5 <= R0 + 10            | 101 000 101 0001010       |  R5 is 10 - used to terminate the loop
//  | 0x03    | LD R2,R3,50      | R3 <= M[R2 + 50]         | 001 010 011 0110010       |  R3 is the number to be compared in R3
//  | 0x04    | SLT R1,R3,R4     | R4 <= R1 < R3            | 000 001 011 100 0111      |  
//  | 0x05    | BEQ R4,R0,0x02   | If R4 == R0; PC <= PC+1  | 011 100 000 0000001       |  if R1 < R3, then R1 = R3
//  | 0x06    | LD R2,R1,50      | R1 <= M[R2 + 50]         | 001 010 001 0110010       |  
//  | 0x07    | ADDi R2,R2,1     | R2 <= R2 + 1             | 101 010 010 0000001       |
//  | 0x08    | LD R2,R3,50      | R3 <= M[R2 + 50]         | 001 010 011 0110010       |
//  | 0x09    | BEQ R2,R5,0x02   | If R2 == R5; PC <= PC+1  | 011 010 101 0000001       |  if R2 == 10, then terminate the loop
//  | 0x0A    | J 0x04           | PC <= 0x04               | 100 0000000000100         |
//  | 0x0B    | END              | End of the program       | 111 0000000000000         |
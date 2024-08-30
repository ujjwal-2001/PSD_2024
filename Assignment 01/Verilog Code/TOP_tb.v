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
//   The 10 numbers are stored in the memory from the location 100 to 109
//   or 0x0064 to 0x006D. The instructions are stored from the location
//   0 to 15 or 0x0000 to 0x000F. The instructions are as follows:
//
//  |+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|
//  | Address |    Instruction   |          Remark          |   16-bit  representation  |
//  |+++++++++|++++++++++++++++++|++++++++++++++++++++++++++|+++++++++++++++++++++++++++|

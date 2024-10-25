//====================================================//
// File Name    :   TOP.v
// Module Name  :   TOP
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-cycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This module is the top module that instantiates the ClockDivider, CPU, and LedDisplay modules.
// The ClockDivider module generates a clock signal that is 1/4th the frequency of the input clock signal.
// The CPU module is the processor that executes the instructions loaded in the instruction memory.
// The LedDisplay module displays the contents of the register file on the LEDs based on the select signal.
// The select signal is used to select the register whose contents are displayed on the LEDs.
//----------------------------------------------------------------------------------------------------//

module TOP(
    input  wire clock,          // Clock
    input  wire reset1,         // Reset
    input  wire reset2,         // Reset
    input  wire [3:0] select,   // Select
    output wire [15:0] LED      // LED
);

    wire [31:0] RF1, RF2, RF3, RF4, RF5, RF6, RF7, RF8, RF9, RF10;
    wire clock_div;

    ClockDivider ClockDivider_inst(
        .clock(clock),
        .reset(reset1),
        .clock_div(clock_div)
    );

    CPU CPU_inst(
        .clock(clock_div),
        .reset(reset2),
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

    LedDisplay LedDisplay_inst(
        .clock(clock_div),
        .reset(reset2),
        .RF1(RF1),
        .RF2(RF2),
        .RF3(RF3),
        .RF4(RF4),
        .RF5(RF5),
        .RF6(RF6),
        .RF7(RF7),
        .RF8(RF8),
        .RF9(RF9),
        .RF10(RF10),
        .select(select),
        .LED(LED)
    );

endmodule
//====================================================//
// File Name    :   TOP.v
// Module Name  :   TOP
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//

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
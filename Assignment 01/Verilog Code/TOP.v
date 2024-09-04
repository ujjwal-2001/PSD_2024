//======================================================//
// File Name    :   TOP.v
// Module Name  :   TOP
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   1
// Topic        :   16-bit Multi-cycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION-----------------------------------------------//
// This is a top-level module that instantiates the CPU and BCD7Segment modules. The module connects the
// output of the CPU module to the input of the BCD7Segment module. The module contains the clock signal
// and reset signal that are connected to both the CPU and BCD7Segment modules. The module is synchronous
// and updates the state machine of the CPU module on the positive edge of the clock signal.
//--------------------------------------------------------------------------------------------------------//

module TOP(
    // input clock100Mhz,  // 100 Mhz clock source on Basys 3 FPGA
    input reset,        // reset
    input clock,        // Clock signal
    output [15:0] r1    // Register 1 value
    // output [3:0] anode, // anode signals of the 7-segment LED display
    // output [6:0] LEDOut // cathode patterns of the 7-segment LED display
    );

    // wire [15:0] displayedNum;  // input data to be displayed

    // assign r1 = displayedNum;

    CPU CPU (
        .clock(clock), 
        .reset(reset), 
        .reg1(r1)
    );

    // BCD7Segment BCD7Segment (
    //     .clock100Mhz(clock100Mhz), 
    //     .reset(reset), 
    //     .displayedNum(displayedNum),
    //     .anode(anode),
    //     .LEDOut(LEDOut)
    // );

endmodule
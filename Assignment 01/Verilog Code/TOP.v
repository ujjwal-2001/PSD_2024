
module Top(
    input clock100Mhz,  // 100 Mhz clock source on Basys 3 FPGA
    input reset,        // reset
    input clock,        // Clock signal
    );

    wire [15:0] displayedNum;  // input data to be displayed

    CPU CPU (
        .clock(clock), 
        .reset(reset), 
        .reg1(displayedNum)
    );

    BCD7Segment BCD7Segment (
        .clock100Mhz(clock100Mhz), 
        .reset(reset), 
        .displayedNum(displayedNum)
    );

endmodule
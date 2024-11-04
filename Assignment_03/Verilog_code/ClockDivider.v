//====================================================//
// File Name    :   ClockDivider.v
// Module Name  :   lockDivider
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   3
// Topic        :   32-bit RISC-V 5-stage Pipelined Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This module is a clock divider that divides the input clock signal by 2.
//----------------------------------------------------------------------------------------------------//

module ClockDivider(
    input  wire clock,          // Clock
    input  wire reset,          // Reset
    output wire clock_div       // Divided clock
);

    reg count;   // Counter

    always@(posedge clock or posedge reset)begin
        if(reset)begin
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end

    assign clock_div = count;    // Divided clock

endmodule
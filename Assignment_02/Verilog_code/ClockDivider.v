//====================================================//
// File Name    :   ClockDivider.v
// Module Name  :   lockDivider
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-cycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This module is a clock divider that divides the input clock signal by 4.
//----------------------------------------------------------------------------------------------------//

module ClockDivider(
    input  wire clock,          // Clock
    input  wire reset,          // Reset
    output wire clock_div       // Divided clock
);

    reg [1:0] count;   // Counter

    always@(posedge clock or posedge reset)begin
        if(reset)begin
            count <= 2'b00;
        end
        else begin
            count <= count + 1;
        end
    end

    assign clock_div = count[1];    // Divided clock

endmodule
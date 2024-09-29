//===========================================================================//
// File Name    :   LedDisplay.v
// Module Name  :   LedDisplay
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
//===========================================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This is a LED display module that displays the values of the registers on the LEDs of the FPGA board.
//----------------------------------------------------------------------------------------------------//

module LedDisplay(
    input  wire clock,           // Clock
    input  wire reset,           // Reset
    input  wire [15:0] RF1,      // Register 1
    input  wire [15:0] RF2,      // Register 2
    input  wire [15:0] RF3,      // Register 3
    input  wire [15:0] RF4,      // Register 4
    input  wire [15:0] RF5,      // Register 5
    input  wire [15:0] RF6,      // Register 6
    input  wire [15:0] RF7,      // Register 7
    input  wire [15:0] RF8,      // Register 8
    input  wire [15:0] RF9,      // Register 9
    input  wire [15:0] RF10,     // Register 10
    input  wire [3:0]  select,   // Select
    output reg  [15:0] LED       // LED
);

    reg [15:0] LED_temp;

    always@(*)begin
        case(select)
            4'd1: LED_temp = RF1;
            4'd2: LED_temp = RF2;
            4'd3: LED_temp = RF3;
            4'd4: LED_temp = RF4;
            4'd5: LED_temp = RF5;
            4'd6: LED_temp = RF6;
            4'd7: LED_temp = RF7;
            4'd8: LED_temp = RF8;
            4'd9: LED_temp = RF9;
            4'd10: LED_temp = RF10;
            default: LED_temp = 16'b0;
        endcase
    end

    always@(posedge clock)begin
        if(reset)begin
            LED <= 16'b0;
        end
        else begin
            LED <= LED_temp;
        end
    end

endmodule
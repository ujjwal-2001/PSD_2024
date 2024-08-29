//======================================================//
// File Name    :   BCD7Segment.v
// Module Name  :   BCD7Segment
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   1
// Topic        :   16-bit Multi-cycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION-----------------------------------------------//
// This is a 7-segment BCD display module that displays a 4-digit BCD number on a 7-segment LED display.
// The module takes a 16-bit input data and displays the 4-digit BCD number on the 7-segment display. The
// module uses a 100 MHz clock signal to refresh the display at a rate of 380 Hz. The module uses a 20-bit
// counter to create a 10.5 ms refresh period and a 2-bit counter to activate the 4 LEDs with a 2.6 ms digit
// period. The module uses a decoder to generate the anode signals for the 7-segment display and a case
// statement to generate the cathode patterns for the 7-segment display based on the BCD input.
//--------------------------------------------------------------------------------------------------------//

module BCD7Segment(
    input clock100Mhz,          // 100 Mhz clock source on Basys 3 FPGA
    input reset,                // reset
    input [15:0] displayedNum,  // input data to be displayed
    output reg [3:0] anode,     // anode signals of the 7-segment LED display
    output reg [6:0] LEDOut     // cathode patterns of the 7-segment LED display
    );

    wire [1:0] LEDActivatingCounter;    // 2-bit counter for activating 4 LEDs
    reg [3:0] LED_BCD;                  // 4-bit BCD for 4 LEDs
    reg [19:0] refreshCounter;          
    // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
    // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    
    always @(posedge clock100Mhz)begin 
        if(reset==1)
            refreshCounter <= 0;
        else
            refreshCounter <= refreshCounter + 1;
    end 

    assign LEDActivatingCounter = refreshCounter[19:18];

    // anode activating signals for 4 LEDs, digit period of 2.6ms and decoder to generate anode signals 
    always@(*) begin
        case(LEDActivatingCounter)  
            2'b00: begin            // 1st LED
                anode = 4'b0111;                        
                LED_BCD = displayedNum/1000;
                end
            2'b01: begin            // 2nd LED
                anode = 4'b1011; 
                LED_BCD = (displayedNum % 1000)/100;
                end
            2'b10: begin            // 3rd LED
                anode = 4'b1101; 
                LED_BCD = ((displayedNum % 1000)%100)/10;
                end
            2'b11: begin            // 4th LED
                anode = 4'b1110; 
                LED_BCD = ((displayedNum % 1000)%100)%10;
                end
        endcase
    
        case(LED_BCD)
            4'b0000: LEDOut = 7'b0000001; // "0"     
            4'b0001: LEDOut = 7'b1001111; // "1" 
            4'b0010: LEDOut = 7'b0010010; // "2" 
            4'b0011: LEDOut = 7'b0000110; // "3" 
            4'b0100: LEDOut = 7'b1001100; // "4" 
            4'b0101: LEDOut = 7'b0100100; // "5" 
            4'b0110: LEDOut = 7'b0100000; // "6" 
            4'b0111: LEDOut = 7'b0001111; // "7" 
            4'b1000: LEDOut = 7'b0000000; // "8"     
            4'b1001: LEDOut = 7'b0000100; // "9" 
            default: LEDOut = 7'b0000001; // "0"
        endcase

    end
 endmodule
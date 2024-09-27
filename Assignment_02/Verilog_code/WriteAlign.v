//====================================================//
// File Name    :   WriteAlign.v
// Module Name  :   WriteAlign
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This module aligns the data to be written to the memory. The data is aligned based on the address LSBs
// and the control signals. The data is aligned in such a way that the data is written to the memory in
// the correct order.
//----------------------------------------------------------------------------------------------------//

module WriteAlign(
    input  wire [31:0] WriteData,   // Data to be aligned
    input  wire [1:0] Address,      // Address LSBs
    input  wire sb,sh,sw,           // Store byte, Store halfword, Store word - Control signals
    output reg  we0,we1,we2,we3,    // Write enable signals
    output wire [31:0] DataIn       // Data aligned
);

    reg [8:0] D7_0, D15_8, D23_16, D31_24;
    reg [1:0] T;
    reg U, V;

    assign DataIn = {D31_24,D23_16,D15_8,D7_0};

    always@(*)begin

        case({Address,sb,sh,sw})
            5'b00001: begin
                T = 2'b00;
                U = 1'b0;
                V = 1'b0;
                we0 = 1'b1;
                we1 = 1'b1;
                we2 = 1'b1;
                we3 = 1'b1;
            end
            5'b00010: begin
                T = 2'b00;
                U = 1'b0;
                V = 1'b0;
                we0 = 1'b1;
                we1 = 1'b1;
                we2 = 1'b0;
                we3 = 1'b0;
            end
            5'b10010: begin
                T = 2'b01;
                U = 1'b1;
                V = 1'b0;
                we0 = 1'b0;
                we1 = 1'b0;
                we2 = 1'b1;
                we3 = 1'b1;
            end
            5'b00100: begin
                T = 2'b10;
                U = 1'b1;
                V = 1'b1;
                we0 = 1'b1;
                we1 = 1'b0;
                we2 = 1'b0;
                we3 = 1'b0;
            end
            5'b01100: begin
                T = 2'b10;
                U = 1'b1;
                V = 1'b1;
                we0 = 1'b0;
                we1 = 1'b1;
                we2 = 1'b0;
                we3 = 1'b0;
            end
            5'b10100: begin
                T = 2'b10;
                U = 1'b1;
                V = 1'b1;
                we0 = 1'b0;
                we1 = 1'b0;
                we2 = 1'b1;
                we3 = 1'b0;
            end
            5'b11100: begin
                T = 2'b10;
                U = 1'b1;
                V = 1'b1;
                we0 = 1'b0;
                we1 = 1'b0;
                we2 = 1'b0;
                we3 = 1'b1;
            end
            default: begin
                T = 2'b00;
                U = 1'b0;
                V = 1'b0;
                we0 = 1'b0;
                we1 = 1'b0;
                we2 = 1'b0;
                we3 = 1'b0;
            end
        endcase

        case(T)
            2'b00: D31_24 = WriteData[31:24];
            2'b01: D31_24 = WriteData[15:8];
            2'b10: D31_24 = WriteData[7:0];
            default: D31_24 = 8'b0;
        endcase

        case(U)
            1'b0: D23_16 = WriteData[23:16];
            1'b1: D23_16 = WriteData[7:0];
        endcase

        case(V)
            1'b0: D15_8 = WriteData[15:8];
            1'b1: D15_8 = WriteData[23:16];
        endcase

        D7_0 = WriteData[7:0];

    end


endmodule
//====================================================//
// File Name    :   ReadAlign.v
// Module Name  :   ReadAlign
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//

//----------------------------------------------------------------------------------------------------//

module ReadAlign(
    input wire [31:0] DataIn,   // Data to be aligned
    input wire [1:0] Address,   // Address LSBs
    input wire lb,lbu,          // Load byte, Load byte unsigned - Control signals
    input wire lh,lhu,          // Load halfword, Load halfword unsigned - Control signals
    input wire lw,              // Load word
    output wire [31:0] DataOut  // Data aligned
);

    reg [31:0] AlignDataOut;
    reg [7:0] Da7_0, Db7_0, Dc7_0;
    reg [7:0] Da15_8, Db15_8, Dc15_8;
    reg [7:0] Dc23_16;

    assign DataOut = AlignDataOut;

    always @(*)begin
        case(Address)
            2'b00: Da7_0 = DataIn[7:0];
            2'b01: Da7_0 = DataIn[15:8];
            2'b10: Da7_0 = DataIn[23:16];
            2'b11: Da7_0 = DataIn[31:24];
        endcase

        case({lb,lbu})
            2'b01: Da15_8 = 8'd0;
            2'b11: Da15_8 = {8{Da7_0[7]}};
            default: Da15_8 = 8'b0;
        endcase

        case(Address[1])
            1'b0: {Db15_8, Db7_0} = {DataIn[15:8], DataIn[7:0]};
            1'b1: {Db15_8, Db7_0} = {DataIn[31:24], DataIn[23:16]}; 
            default: {Db15_8, Db7_0} = 16'b0;
        endcase

        case(lh | lhu)
            1'b0: {Dc15_8, Dc7_0} = {Da15_8, Da7_0};
            1'b1: {Dc15_8, Dc7_0} = {Db15_8, Db7_0};
        endcase

        case({lh,lhu})
            2'b00: Dc23_16 = Da15_8;
            2'b01: Dc23_16 = 8'd0;
            2'b10: Dc23_16 = {8{Db15_8[7]}};
            default: Dc23_16 = 8'b0;
        endcase

        case(lw)
            1'b0: AlignDataOut = {Dc23_16, Dc23_16, Dc15_8, Dc7_0};
            1'b1: AlignDataOut = DataIn;
        endcase
        
    end


endmodule
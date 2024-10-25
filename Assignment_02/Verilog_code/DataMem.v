//====================================================//
// File Name    :   DataMem.v
// Module Name  :   DataMem
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-cycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This module is the data memory of the 32-bit RISC-V single-cycle processor. The data memory is a 32-bit
// memory that stores the data to be read and written. The data memory has four memory banks, each of which
// stores 8 bits of data. Data is written and read in aligned manner.
//----------------------------------------------------------------------------------------------------//

module DataMem(
    input  wire clock,           // Clock
    input  wire [11:0] Address,  // Address
    input  wire [31:0] WriteData,// Data to be written
    input  wire MemWrite,        // Write enable
    input  wire sw,sh,sb,        // Store word, Store halfword, Store byte - Control signals
    input  wire lw,lh,lbu,lb,lhu,// Load word, Load halfword, Load halfword unsigned, Load byte - Control signals
    output wire [31:0] ReadData  // Data to be read
);

    wire [31:0] DataIn;
    wire [7:0]  DataIn0, DataIn1, DataIn2, DataIn3;
    wire [31:0] DataOut;
    wire we0,we1,we2,we3;
    wire [9:0] LineAddress;
    wire [1:0] Offset;

    assign LineAddress = Address[11:2];
    assign Offset = Address[1:0];
    assign DataIn0 = DataIn[7:0];
    assign DataIn1 = DataIn[15:8];
    assign DataIn2 = DataIn[23:16];
    assign DataIn3 = DataIn[31:24];

    WriteAlign WriteAlign(          // Align the data to be written
        .WriteData(WriteData),
        .Address(Offset),
        .sb(sb),
        .sh(sh),
        .sw(sw),
        .we0(we0),
        .we1(we1),
        .we2(we2),
        .we3(we3),
        .DataIn(DataIn)
    );

    ReadAlign ReadAlign(            // Align the data to be read
        .DataOut(DataOut),
        .Address(Offset),
        .lb(lb),
        .lbu(lbu),
        .lh(lh),
        .lhu(lhu),
        .lw(lw),
        .ReadData(ReadData)
    );

    // Memory banks
    dist_mem_gen_1 Bank0(
        .a(LineAddress),
        .d(DataIn0),
        .clk(clock),
        .we(MemWrite & we0),
        .spo(DataOut[7:0])
    );

    dist_mem_gen_1 Bank1(
        .a(LineAddress),
        .d(DataIn1),
        .clk(clock),
        .we(MemWrite & we1),
        .spo(DataOut[15:8])
    );

    dist_mem_gen_1 Bank2(
        .a(LineAddress),
        .d(DataIn2),
        .clk(clock),
        .we(MemWrite & we2),
        .spo(DataOut[23:16])
    );

    dist_mem_gen_1 Bank3(
        .a(LineAddress),
        .d(DataIn3),
        .clk(clock),
        .we(MemWrite & we3),
        .spo(DataOut[31:24])
    );

endmodule
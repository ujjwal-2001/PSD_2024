//====================================================//
// File Name    :   DataMem.v
// Module Name  :   DataMem
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//

//----------------------------------------------------------------------------------------------------//

module DataMem(
    input wire clock,           // Clock
    input wire [11:0] Address,  // Address
    input wire [31:0] WriteData,// Data to be written
    input wire MemWrite,        // Write enable
    input wire sw,sh,sb,        // Store word, Store halfword, Store byte - Control signals
    input wire lw,lh,lbu,lb,lbu // Load word, Load halfword, Load halfword unsigned, Load byte - Control signals
    output wire [31:0] ReadData // Data to be read
);

    wire [31:0] DataIn;
    wire [31:0] DataOut;
    wire we0,we1,we2,we3;

    WriteAlign WriteAlign(          // Align the data to be written
        .WriteData(WriteData),
        .Address(Address[1:0]),
        .sb(sb),
        .sh(sh),
        .sw(sw),
        .we0(MemWrite & we0),
        .we1(MemWrite & we1),
        .we2(MemWrite & we2),
        .we3(MemWrite & we3),
        .DataIn(DataIn)
    );

    ReadAlign ReadAlign(            // Align the data to be read
        .DataOut(DataOut),
        .Address(Address[1:0]),
        .lb(lb),
        .lbu(lbu),
        .lh(lh),
        .lhu(lbu),
        .lw(lw),
        .ReadData(ReadData)
    );

    // Memory banks
    dist_mem_gen_1 Bank0(
        .a(Address[11:2]),
        .d(DataIn[7:0]),
        .clk(clock),
        .we(we0),
        .spo(DataOut[7:0])
    );

    dist_mem_gen_1 Bank1(
        .a(Address[11:2]),
        .d(DataIn[15:8]),
        .clk(clock),
        .we(we1),
        .spo(DataOut[15:6])
    );

    dist_mem_gen_1 Bank2(
        .a(Address[11:2]),
        .d(DataIn[23:16]),
        .clk(clock),
        .we(we2),
        .spo(DataOut[23:16])
    );

    dist_mem_gen_1 Bank3(
        .a(Address[11:2]),
        .d(DataIn[31:24]),
        .clk(clock),
        .we(we3),
        .spo(DataOut[31:24])
    );

endmodule
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
    input wire clock,     // Clock
    input wire [11:0] Address,  // Address
    input wire [31:0] WriteData,    // Data to be written
    input wire MemWrite,   // Write enable
    input wire MemRead,    // Read enable
    output wire [31:0] ReadData    // Data to be read
);

    wire [31:0] DataIn;
    wire [31:0] DataOut;

    dist_mem_gen_1 Bank0(
        .a(Address[11:2]),
        .d(DataIn[]),
        .clk(clock),
        .we(),
        .spo(DataOut[7:0])
    );

    dist_mem_gen_1 Bank1(
        .a(Address[11:2]),
        .d(DataIn[]),
        .clk(clock),
        .we(),
        .spo(DataOut[15:6])
    );

    dist_mem_gen_1 Bank2(
        .a(Address[11:2]),
        .d(DataIn[]),
        .clk(clock),
        .we(),
        .spo(DataOut[23:16])
    );

    dist_mem_gen_1 Bank3(
        .a(Address[11:2]),
        .d(DataIn[]),
        .clk(clock),
        .we(),
        .spo(DataOut[31:24])
    );
    
    



endmodule
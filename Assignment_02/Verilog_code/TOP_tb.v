//====================================================//
// File Name    :   TOP_tb.v
// Module Name  :   TOP_tb
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//-------------------------------DESCRIPTION------------------------------------//

//------------------------------------------------------------------------------//


TOP_tb();

    reg clock, reset;
    wire [31:0] RF [31:0];

    initial begin
        clock = 0;
        reset = 1;
        #10 reset = 0;
    end

    always begin
        #5 clock = ~clock;
    end

    TOP TOP_inst(
        .clock(clock),
        .reset(reset),
        .RF(RF)
    );

endmodule

// 0x00000000   addi x5, x0, 5	    000000000101 00000 000 01010 0010011
// 0x00000001   sw x5, 0(x0)	    0000000 01010 00000 010 00000 0100011
// 0x00000002   addi x5, x0, 4	    000000000100 00000 000 01010 0010011
// 0x00000003   sw x5, 4(x0)	    0000000 01010 00000 010 00100 0100011
// 0x00000004   addi x5, x0, 2	    000000000010 00000 000 01010 0010011
// 0x00000005   sw x5, 8(x0)	    0000000 01010 00000 010 01000 0100011
// 0x00000006   addi x5, x0, 8	    000000001000 00000 000 01010 0010011
// 0x00000007   sw x5, 12(x0)	    0000000 01010 00000 010 01100 0100011
// 0x00000008   addi x5, x0, 6	    000000000110 00000 000 01010 0010011
// 0x00000009   sw x5, 16(x0)	    0000000 01010 00000 010 10000 0100011
// 0x0000000A   addi x5, x0, 1	    000000000001 00000 000 01010 0010011
// 0x0000000B   sw x5, 20(x0)	    0000000 01010 00000 010 10100 0100011
// 0x0000000C   addi x5, x0, 3	    000000000011 00000 000 01010 0010011
// 0x0000000D   sw x5, 24(x0)	    0000000 01010 00000 010 11000 0100011
// 0x0000000E   addi x5, x0, 7	    000000000111 00000 000 01010 0010011
// 0x0000000F   sw x5, 28(x0)	    0000000 01010 00000 010 11100 0100011
// 0x00000010   addi x5, x0, 9	    00000001001 00000 000 01010 0010011
// 0x00000011   sw x5, 32(x0)	    0000000 01010 00000 011 00000 0100011
// 0x00000012   addi x5, x0, 10	    000000001010 00000 000 01010 0010011
// 0x00000013   sw x5, 36(x0)	    0000000 01010 00000 011 00100 0100011
// 0x00000014	addi x5, x0, 0	    000000000000 00000 000 00101 0010011	Add immediate (I-type), x5 = 0
// 0x00000015	addi x6, x0, 0	    000000000000 00000 000 00110 0010011	Add immediate (I-type), x6 = 0 (base address of arr)
// 0x00000016	addi x7, x0, 0	    000000000000 00000 000 00111 0010011	Add immediate (I-type), x7 = 0 (j)
// 0x00000017	addi x8, x0, 10	    000000001010 00000 000 01000 0010011	Add immediate (I-type), x8 = 10 (array size)
// 0x00000018	sub x8, x8, x5	    0100000 00101 01000 000 01000 0110011	Subtract (R-type), x8 = 10 - i (correct function7)
// 0x00000019	addi x9, x0, 1	    000000000001 00000 000 01001 0010011	Add immediate (I-type), x9 = 1 (for decrement)
// 0x0000001A	sub x8, x8, x9	    0100000 01001 01000 000 01000 0110011	Subtract (R-type), x8 = 10 - i - 1
// 0x0000001B	bge x7, x8, 11  	0000000 01000 00111 101 00001 1100111	Branch if greater or equal (B-type), j >= 10 - i - 1
// 0x0000001C	slli x11, x7, 2	    0000000 00010 00111 001 01011 0010011	Shift left logical immediate (I-type), x11 = j * 4
// 0x0000001D	add x12, x6, x11	0000000 01011 00110 000 01100 0110011	Add (R-type), x12 = base address + offset
// 0x0000001E	lw x10, 0(x12)	    000000000000 01100 010 01010 0000011	Load word (I-type), load arr[j] into x10
// 0x0000001F	addi x11, x11, 4	000000000100 01011 000 01011 0010011	Add immediate (I-type), x11 = (j+1) * 4
// 0x00000020	add x12, x6, x11	0000000 01011 00110 000 01100 0110011	Add (R-type), adjust address for arr[j+1]
// 0x00000021	lw x13, 0(x12)	    000000000000 01100 010 01101 0000011	Load word (I-type), load arr[j+1] into x13
// 0x00000022	blt x10, x13, 2 	0000000 01101 01010 100 00010 1100111	Branch if less than (B-type), if arr[j] < arr[j+1]
// 0x00000023	sw x10, 0(x12)	    0000000 01010 01100 010 00000 0100011	Store word (S-type), store x10 in arr[j+1] (rs1=x12, rs2=x10)
// 0x00000024	addi x7, x7, 1	    000000000001 00111 000 00111 0010011	Add immediate (I-type), increment j
// 0x00000025	jal x0, -14     	000000000000 00000 000 00000 1101111	Jump and link (J-type), repeat inner loop
// 0x00000026	addi x5, x5, 1	    000000000001 00101 000 00101 0010011	Add immediate (I-type), increment i
// 0x00000026	addi x8, x0, 10	    000000001010 00000 000 01000 0010011	Add immediate (I-type), x8 = 10
// 0x00000027	blt x5, x8, -18 	0000000 01000 00101 100 00000 1100111	Branch if less than (B-type), if i < 10, repeat loop

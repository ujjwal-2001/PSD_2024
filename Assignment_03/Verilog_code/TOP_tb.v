//====================================================//
// File Name    :   TOP_tb.v
// Module Name  :   TOP_tb
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//-------------------------------DESCRIPTION------------------------------------//
// This is the testbench file for the TOP module. It instantiates the TOP module
// and provides the inputs to the module.
//------------------------------------------------------------------------------//


module TOP_tb();

    reg clock, reset1,reset2;
    wire [15:0] LED;
    reg  [3:0] select;

    initial begin
        clock = 0;
        reset1 = 1;
        reset2 = 1;
        #10 reset1 = 0;
        #30 reset2 = 0;
        #10 select = 1;
    end

    always begin
        #5 clock = ~clock;
    end

    TOP TOP_inst(
        .clock(clock),
        .reset1(reset1),
        .reset2(reset2),
        .select(select),
        .LED(LED)
    );

endmodule

//===============PROGRAM LODED IN THE INSTRUCTION MEMORY========================//

// 0x00000000   addi x5, x0, 53	    000000110101 00000 000 00101 0010011
// 0x00000001   sw x5, 0(x0)	    0000000 00101 00000 010 00000 0100011
// 0x00000002   addi x5, x0, 4	    000000000100 00000 000 00101 0010011
// 0x00000003   sw x5, 4(x0)	    0000000 00101 00000 010 00100 0100011
// 0x00000004   addi x5, x0, 122    000001111010 00000 000 00101 0010011
// 0x00000005   sw x5, 8(x0)	    0000000 00101 00000 010 01000 0100011
// 0x00000006   addi x5, x0, 8	    000000001000 00000 000 00101 0010011
// 0x00000007   sw x5, 12(x0)	    0000000 00101 00000 010 01100 0100011
// 0x00000008   addi x5, x0, 6	    000000000110 00000 000 00101 0010011
// 0x00000009   sw x5, 16(x0)	    0000000 00101 00000 010 10000 0100011
// 0x0000000A   addi x5, x0, 15	    000000001111 00000 000 00101 0010011
// 0x0000000B   sw x5, 20(x0)	    0000000 00101 00000 010 10100 0100011
// 0x0000000C   addi x5, x0, 3	    000000000011 00000 000 00101 0010011
// 0x0000000D   sw x5, 24(x0)	    0000000 00101 00000 010 11000 0100011
// 0x0000000E   addi x5, x0, 7	    000000000111 00000 000 00101 0010011
// 0x0000000F   sw x5, 28(x0)	    0000000 00101 00000 010 11100 0100011
// 0x00000010   addi x5, x0, 127    000001111111 00000 000 00101 0010011
// 0x00000011   sw x5, 32(x0)	    0000001 00101 00000 010 00000 0100011
// 0x00000012   addi x5, x0, 10	    000000001010 00000 000 00101 0010011
// 0x00000013   sw x5, 36(x0)	    0000001 00101 00000 010 00100 0100011
// 0x00000014	addi x5, x0, 0	    000000000000 00000 000 00101 0010011	Add immediate (I-type), x5 = 0
// 0x00000015	addi x6, x0, 0	    000000000000 00000 000 00110 0010011	Add immediate (I-type), x6 = 0 (base address of arr)
// 0x00000016	addi x7, x0, 0	    000000000000 00000 000 00111 0010011	Add immediate (I-type), x7 = 0 (j)
// 0x00000017	addi x8, x0, 10	    000000001010 00000 000 01000 0010011	Add immediate (I-type), x8 = 10 (array size)
// 0x00000018	sub x8, x8, x5	    0100000 00101 01000 000 01000 0110011	Subtract (R-type), x8 = 10 - i (correct function7)
// 0x00000019	addi x9, x0, 1	    000000000001 00000 000 01001 0010011	Add immediate (I-type), x9 = 1 (for decrement)
// 0x0000001A	sub x8, x8, x9	    0100000 01001 01000 000 01000 0110011	Subtract (R-type), x8 = 10 - i - 1
// 0x0000001B	bge x7, x8, 12  	0000000 01000 00111 101 01100 1100111	Branch if greater or equal (B-type), j >= 10 - i - 1
// 0x0000001C	slli x11, x7, 2	    0000000 00010 00111 001 01011 0010011	Shift left logical immediate (I-type), x11 = j * 4
// 0x0000001D	add x12, x6, x11	0000000 01011 00110 000 01100 0110011	Add (R-type), x12 = base address + offset
// 0x0000001E	lw x10, 0(x12)	    000000000000 01100 010 01010 0000011	Load word (I-type), load arr[j] into x10
// 0x0000001F	addi x11, x11, 4	000000000100 01011 000 01011 0010011	Add immediate (I-type), x11 = (j+1) * 4
// 0x00000020	add x12, x6, x11	0000000 01011 00110 000 01100 0110011	Add (R-type), adjust address for arr[j+1]
// 0x00000021	lw x13, 0(x12)	    000000000000 01100 010 01101 0000011	Load word (I-type), load arr[j+1] into x13
// 0x00000022	blt x10, x13, 3 	0000000 01101 01010 100 00011 1100111	Branch if less than (B-type), if arr[j] < arr[j+1], skip swap
// 0x00000023   sw x10, 0(x12)      0000000 01010 01100 010 00000 0100011   Store word (S-type), store x10 in arr[j+1] (rs1=x12, rs2=x10)
// 0x00000024   sw x13, -4(x12)     1111111 01101 01100 010 11100 0100011   Store word (S-type), store x13 in arr[j] (rs1=x12, rs2=x13)
// 0x00000025	addi x7, x7, 1	    000000000001 00111 000 00111 0010011	Add immediate (I-type), increment j
// 0x00000026	jal x0, -15     	1 11111110001 1 1111111 00000 1101111	Jump and link (J-type), repeat inner loop
// 0x00000027	addi x5, x5, 1	    000000000001 00101 000 00101 0010011	Add immediate (I-type), increment i
// 0x00000028	addi x8, x0, 10	    000000001010 00000 000 01000 0010011	Add immediate (I-type), x8 = 10
// 0x00000029	blt x5, x8, -19 	1111111 01000 00101 100 01101 1100111	Branch if less than (B-type), if i < 10, repeat loop
// 0x0000002A   lw x1, 0(x0)        000000000000 00000 010 00001 0000011    Load word (I-type), load arr[0] into x1
// 0x0000002B   lw x2, 4(x0)        000000000100 00000 010 00010 0000011    Load word (I-type), load arr[1] into x2
// 0x0000002C   lw x3, 8(x0)        000000001000 00000 010 00011 0000011    Load word (I-type), load arr[2] into x3
// 0x0000002D   lw x4, 12(x0)       000000001100 00000 010 00100 0000011    Load word (I-type), load arr[3] into x4
// 0x0000002E   lw x5, 16(x0)       000000010000 00000 010 00101 0000011    Load word (I-type), load arr[4] into x5
// 0x0000002F   lw x6, 20(x0)       000000010100 00000 010 00110 0000011    Load word (I-type), load arr[5] into x6
// 0x00000030   lw x7, 24(x0)       000000011000 00000 010 00111 0000011    Load word (I-type), load arr[6] into x7
// 0x00000031   lw x8, 28(x0)       000000011100 00000 010 01000 0000011    Load word (I-type), load arr[7] into x8
// 0x00000032   lw x9, 32(x0)       000000100000 00000 010 01001 0000011    Load word (I-type), load arr[8] into x9
// 0x00000033   lw x10, 36(x0)      000000100100 00000 010 01010 0000011    Load word (I-type), load arr[9] into x10
// 0x00000034   addi x0, x0, 0      000000000000 00000 000 00000 0010011    Add immediate (I-type), x0 = 0 - NOP HINT (for simulation)
// 0x00000035   beq x0, x0, -1      1111111 00000 00000 000 11111 1100111   Branch if equal (B-type), infinite loop
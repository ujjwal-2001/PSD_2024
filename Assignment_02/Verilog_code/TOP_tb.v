





// 0x00000000	addi x5, x0, 0	    000000000000 00000 000 00101 0010011	Add immediate (I-type), x5 = 0
// 0x00000001	addi x6, x0, 0	    000000000000 00000 000 00110 0010011	Add immediate (I-type), x6 = 0 (base address of arr)
// 0x00000002	addi x7, x0, 0	    000000000000 00000 000 00111 0010011	Add immediate (I-type), x7 = 0 (j)
// 0x00000003	addi x8, x0, 10	    000000001010 00000 000 01000 0010011	Add immediate (I-type), x8 = 10 (array size)
// 0x00000004	sub x8, x8, x5	    0100000 00101 01000 000 01000 0110011	Subtract (R-type), x8 = 10 - i (correct function7)
// 0x00000005	addi x9, x0, 1	    000000000001 00000 000 01001 0010011	Add immediate (I-type), x9 = 1 (for decrement)
// 0x00000006	sub x8, x8, x9	    0100000 01001 01000 000 01000 0110011	Subtract (R-type), x8 = 10 - i - 1
// 0x00000007	bge x7, x8, 11  	0000000 01000 00111 101 00001 1100111	Branch if greater or equal (B-type), j >= 10 - i - 1
// 0x00000008	slli x11, x7, 2	    0000000 00010 00111 001 01011 0010011	Shift left logical immediate (I-type), x11 = j * 4
// 0x00000009	add x12, x6, x11	0000000 01011 00110 000 01100 0110011	Add (R-type), x12 = base address + offset
// 0x0000000A	lw x10, 0(x12)	    000000000000 01100 010 01010 0000011	Load word (I-type), load arr[j] into x10
// 0x0000000B	addi x11, x11, 4	000000000100 01011 000 01011 0010011	Add immediate (I-type), x11 = (j+1) * 4
// 0x0000000C	add x12, x6, x11	0000000 01011 00110 000 01100 0110011	Add (R-type), adjust address for arr[j+1]
// 0x0000000D	lw x13, 0(x12)	    000000000000 01100 010 01101 0000011	Load word (I-type), load arr[j+1] into x13
// 0x0000000E	blt x10, x13, 2 	0000000 01101 01010 100 00010 1100111	Branch if less than (B-type), if arr[j] < arr[j+1]
// 0x0000000F	sw x10, 0(x12)	    0000000 01010 01100 010 00000 0100011	Store word (S-type), store x10 in arr[j+1] (rs1=x12, rs2=x10)
// 0x00000010	addi x7, x7, 1	    000000000001 00111 000 00111 0010011	Add immediate (I-type), increment j
// 0x00000011	jal x0, -14     	000000000000 00000 000 00000 1101111	Jump and link (J-type), repeat inner loop
// 0x00000012	addi x5, x5, 1	    000000000001 00101 000 00101 0010011	Add immediate (I-type), increment i
// 0x00000013	addi x8, x0, 10	    000000001010 00000 000 01000 0010011	Add immediate (I-type), x8 = 10
// 0x00000014	blt x5, x8, -18 	0000000 01000 00101 100 00000 1100111	Branch if less than (B-type), if i < 10, repeat loop

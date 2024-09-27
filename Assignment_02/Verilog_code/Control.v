//====================================================//
// File Name    :   Control.v
// Module Name  :   Control
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//-------------------------------DESCRIPTION------------------------------------//

//------------------------------------------------------------------------------//

module Control
(
    input  wire [2:0] funct3,
    input  wire [6:0] opcode,
    output wire Branch,
    output wire Jump,
    output wire [1:0] MemtoReg,
    output wire [1:0] ALUOp,
    output wire MemWrite,
    output wire ALUSrc,
    output wire RegWrite,
    output wire RegDst,
    output wire sw, sh, sb, 
    output wire lw, lh, lhu, lb, lbu
);

//| Instruction | ALUSrc | Memto-Reg1| Memto-Reg0| Reg-Write | Mem-Read | Mem-Write | Branch | ALUOp1 | ALUOp0 | Jump  | RegDst |
//|-------------|--------|-----------|-----------|-----------|----------|-----------|--------|--------|--------|-------|--------|
//| R-format    |    0   |     0     |     0     |     1     |     0    |     0     |    0   |    1   |    0   |   0   |   0    |
//| ld (I-Type1)|    1   |     0     |     1     |     1     |     1    |     0     |    0   |    0   |    0   |   0   |   0    |
//| I-Type2     |    1   |     0     |     0     |     1     |     0    |     0     |    0   |    0   |    0   |   0   |   0    |
//| S-Type      |    1   |     X     |     X     |     0     |     0    |     1     |    0   |    0   |    0   |   0   |   1    |
//| SB-Type     |    0   |     X     |     X     |     0     |     0    |     0     |    1   |    0   |    1   |   0   |   1    |
//| U-Type      |    X   |     1     |     0     |     1     |     0    |     0     |    0   |    X   |    X   |   0   |   0    | 
//| UJ-Type     |    X   |     X     |     X     |     0     |     0    |     0     |    0   |    X   |    X   |   1   |   0    | 

    parameter R_TYPE  = 7'b0110011;
    parameter I_TYPE1 = 7'b0000011;
    parameter I_TYPE2 = 7'b0010011;
    parameter S_TYPE  = 7'b0100011;
    parameter SB_TYPE = 7'b1100111;
    parameter U_TYPE  = 7'b0110111;
    parameter UJ_TYPE = 7'b1101111;

    assign Branch   = (opcode == SB_TYPE);
    assign Jump     = (opcode == UJ_TYPE);
    assign MemtoReg[1] = (opcode == U_TYPE);
    assign MemtoReg[0] = (opcode == I_TYPE1);
    assign ALUOp[1] = (opcode == R_TYPE);
    assign ALUOp[0] = (opcode == SB_TYPE);
    assign MemWrite = (opcode == S_TYPE);
    assign ALUSrc   = (opcode == I_TYPE1 | opcode == I_TYPE2 | opcode == S_TYPE);
    assign RegWrite = ~(opcode == S_TYPE | opcode == SB_TYPE | opcode == UJ_TYPE);
    assign RegDst   = (opcode == S_TYPE | opcode == SB_TYPE);
    assign sw       = (opcode == S_TYPE) & ( funct3 == 3'b010 );
    assign sh       = (opcode == S_TYPE) & ( funct3 == 3'b001 );
    assign sb       = (opcode == S_TYPE) & ( funct3 == 3'b000 );
    assign lw       = (opcode == I_TYPE1) & ( funct3 == 3'b010 );
    assign lh       = (opcode == I_TYPE1) & ( funct3 == 3'b001 );
    assign lb       = (opcode == I_TYPE1) & ( funct3 == 3'b000 );
    assign lbu      = (opcode == I_TYPE1) & ( funct3 == 3'b100 );
    assign lhu      = (opcode == I_TYPE1) & ( funct3 == 3'b101 );

endmodule
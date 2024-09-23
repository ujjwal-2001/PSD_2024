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
    input  wire [6:0] opcode,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);

//| Instruction | ALUSrc | Memto-Reg | Reg-Write | Mem-Read | Mem-Write | Branch | ALUOp1 | ALUOp0 |
//|-------------|--------|-----------|-----------|----------|-----------|--------|--------|--------|
//| R-format    |    0   |     0     |     1     |     0    |     0     |    0   |    1   |    0   |
//| ld          |    1   |     1     |     1     |     1    |     0     |    0   |    0   |    0   |
//| sd          |    1   |     X     |     0     |     0    |     1     |    0   |    0   |    0   |
//| beq         |    0   |     X     |     0     |     0    |     0     |    1   |    0   |    1   |
//| jal         |    1   |     0     |     1     |     0    |     0     |    1   |    1   |    1   |

    parameter R_TYPE  = 7'b0110011;
    parameter I_TYPE1 = 7'b0000011;
    parameter I_TYPE2 = 7'b0010011;
    parameter S_TYPE  = 7'b0100011;
    parameter SB_TYPE = 7'b1100111;
    parameter U_TYPE  = 7'b0110111;
    parameter UJ_TYPE = 7'b1101111;

    always @* begin
        case(opcode)
            7'b0110011: begin // R-format
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b10;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;
            end
            7'b0000011: begin // ld
                Branch = 0;
                MemRead = 1;
                MemtoReg = 1;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            7'b0100011: begin // sd
                Branch = 0;
                MemRead = 0;
                MemtoReg = 1'bx;
                ALUOp = 2'b00;
                MemWrite = 1;
                ALUSrc = 1;
                RegWrite = 0;
            end
            7'b1100011: begin // beq
                Branch = 1;
                MemRead = 0;
                MemtoReg = 1'bx;
                ALUOp = 2'b01;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 0;
            end
            7'b1101111: begin // jal
                Branch = 1;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b11;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            default: begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 0;
            end
        endcase
    end
    
endmodule
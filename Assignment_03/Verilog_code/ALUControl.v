//====================================================//
// File Name    :   ALUControl.v
// Module Name  :   ALUControl
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//-------------------------------DESCRIPTION------------------------------------//
// This is a ALU control module that generates a 4-bit control signal ALUCtl 
// based on the 2-bit ALUOp and 4-bit FuncCode inputs. The ALUCtl signal is used
// to control the operation of the MIPSALU module. The ALUCtl signal is determined
// as follows:
// If ALUOp is 00, ALUCtl is ADD
// If ALUOp is 01, ALUCtl is determined by FuncCode
// If ALUOp is 10, ALUCtl is determined by FuncCode
// If ALUOp is 11, ALUCtl is determined by FuncCode
//------------------------------------------------------------------------------//


module ALUControl (
    input  wire [1:0] ALUOp,      // ALU operation code
    input  wire [3:0] FuncCode,   // funct7[5], funct3[2:0]
    output reg  [3:0] ALUCtl      // ALU control signal
    );

    parameter [3:0] ADD = 4'b0010;
    parameter [3:0] SUBTRACT = 4'b0110;
    parameter [3:0] AND = 4'b0000;
    parameter [3:0] OR  = 4'b0001;
    parameter [3:0] SLL = 4'b1000;
    parameter [3:0] GTE = 4'b0111;
    parameter [3:0] LTE = 4'b1001;

    always@(*) begin
        case (ALUOp)
            2'b00: ALUCtl = ADD;                // ALUOp is 00
            2'b01: begin
                case (FuncCode[2:0])                 // ALUOp is 01
                    3'b000: ALUCtl = SUBTRACT;
                    3'b101: ALUCtl = GTE;
                    3'b100: ALUCtl = LTE;
                    default: ALUCtl = SUBTRACT;
                endcase
            end
            2'b10: begin
                case (FuncCode)                 // ALUOp is 10
                    4'b0000: ALUCtl = ADD;
                    4'b1000: ALUCtl = SUBTRACT;
                    4'b0111: ALUCtl = AND;
                    4'b0110: ALUCtl = OR;
                    default: ALUCtl = ADD;
                endcase
            end
            2'b11: begin
                case (FuncCode[2:0])                 // ALUOp is 11
                    3'b000: ALUCtl = ADD;
                    3'b001: ALUCtl = SLL;
                    default: ALUCtl = ADD;
                endcase    
            end              
        endcase
    end

endmodule
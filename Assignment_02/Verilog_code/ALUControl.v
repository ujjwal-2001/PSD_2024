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
// If ALUOp is 01, ALUCtl is SUBTRACT
// If ALUOp is 10, ALUCtl is determined by FuncCode
// If ALUOp is 11, ALUCtl is ADD
//------------------------------------------------------------------------------//


module ALUControl (
    input  wire [1:0] ALUOp,     // ALU operation code
    input  wire [3:0] FuncCode,  // funct7[5], funct3[2:0]
    output reg [3:0] ALUCtl      // ALU control signal
    );

    parameter [3:0] ADD = 4'b0010;
    parameter [3:0] SUBTRACT = 4'b0110;
    parameter [3:0] AND = 4'b0000;
    parameter [3:0] OR  = 4'b0001;
    parameter [3:0] NOR = 4'b1100;
    parameter [3:0] SLT = 4'b0111;

    always@(*) begin
        case (ALUOp)
            2'b00: ALUCtl = ADD;                // ALUOp is 00
            2'b01: ALUCtl = SUBTRACT;           // ALUOp is 01
            2'b10: begin
                case (FuncCode)                 // ALUOp is 10
                    4'b0000: ALUCtl = AND;
                    4'b0001: ALUCtl = OR;
                    4'b0111: ALUCtl = SLT;
                    4'b1100: ALUCtl = NOR;
                    4'b0110: ALUCtl = SUBTRACT;
                    4'b0010: ALUCtl = ADD;
                    default: ALUCtl = ADD;
                endcase
            end
            default: ALUCtl = ADD;              
        endcase
    end

endmodule
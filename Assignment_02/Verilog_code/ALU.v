//====================================================//
// File Name    :   ALU.v
// Module Name  :   ALU
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This is a 32-bit ALU module that performs arithmetic and logical operations on two 32-bit inputs
// A and B. The operation to be performed is determined by the 4-bit control signal ALUCtl. The output
// of the ALU is ALUResult, which is also 32 bits. The Zero output is true if ALUResult is 0.
//----------------------------------------------------------------------------------------------------//

module ALU (
    input  wire [3:0] ALUCtl,        // Control signal
    input  wire [31:0] A,B,          // Inputs
    output reg [31:0] ALUResult,     // Output
    output wire Zero                 // Zero flag
    );

    parameter [3:0] SUBTRACT = 4'b0110;
    parameter [3:0] ADD = 4'b0010;
    parameter [3:0] AND = 4'b0000;
    parameter [3:0] OR  = 4'b0001;
    parameter [3:0] NOR = 4'b1100;
    parameter [3:0] SLT = 4'b0111;

    assign Zero = (ALUResult==0);   // Zero is true if ALUResult is 0

    always @(*) begin 
        case (ALUCtl)               // Perform operation based on ALUctl
            ADD: ALUResult = A + B;
            AND: ALUResult = A & B;
            OR: ALUResult  = A | B;
            NOR: ALUResult = ~(A | B);
            SLT: ALUResult = (A < B) ? 1 : 0;
            SUBTRACT: ALUResult = A - B;
            default: ALUResult  = A + B;
        endcase
    end

endmodule
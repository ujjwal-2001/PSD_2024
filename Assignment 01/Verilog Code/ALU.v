//====================================================//
// File Name:   ALU.v
// Module Name: ALU
// Author:      Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course:      E3 245 Processor System Design
// Assignment:  1
// Topic:       16-bit Multi-cycle Processor
// ===================================================//

//--------------DESCRIPTION----------------//
// This is a 16-bit ALU module that performs
// arithmetic and logical operations on two
// 16-bit inputs A and B. The operation to be
// performed is determined by the 4-bit control
// signal ALUctl. The output of the ALU is
// ALUResultOut, which is also 16 bits. The Zero output
// is true if ALUResultOut is 0.
//-----------------------------------------//

module ALU (
    input [3:0] ALUCtl,             // Control signal
    input [15:0] A,B,               // Inputs
    output reg [15:0] ALUResultOut, // Output
    output Zero                     // Zero flag
    );

    parameter [3:0] ADD = 4'b0010;
    parameter [3:0] SUBTRACT = 4'b0110;
    parameter [3:0] AND = 4'b0000;
    parameter [3:0] OR = 4'b0001;
    parameter [3:0] NOR = 4'b1100;
    parameter [3:0] SLT = 4'b0111;

    assign Zero = (ALUResultOut==0); // Zero is true if ALUResultOut is 0

    always @(ALUCtl, A, B) begin 
        case (ALUCtl)               // Perform operation based on ALUctl
            ADD: ALUResultOut = A + B;
            SUBTRACT: ALUResultOut = A - B;
            AND: ALUResultOut = A & B;
            OR: ALUResultOut = A | B;
            NOR: ALUResultOut = ~(A | B);
            SLT: ALUResultOut = (A < B) ? 1 : 0;
            default: ALUResultOut = A + B;
        endcase
    end

endmodule
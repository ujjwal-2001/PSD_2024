module MIPSALU (
    input [3:0] ALUctl,
    input [15:0] A,B,
    output reg [15:0] ALUOut,
    output Zero
    );

    parameter [3:0] ADD = 4'b0010;
    parameter [3:0] SUBTRACT = 4'b0110;
    parameter [3:0] AND = 4'b0000;
    parameter [3:0] OR = 4'b0001;
    parameter [3:0] NOR = 4'b1100;
    parameter [3:0] SLT = 4'b0111;

    assign Zero = (ALUOut==0); //Zero is true if ALUOut is 0

    always @(ALUctl, A, B) begin //reevaluate if these change
        case (ALUctl)
            ADD: ALUOut = A + B;
            SUBTRACT: ALUOut = A - B;
            AND: ALUOut = A & B;
            OR: ALUOut = A | B;
            NOR: ALUOut = ~(A | B);
            SLT: ALUOut = (A < B) ? 1 : 0;
            default: ALUOut = A + B;
        endcase
    end

endmodule
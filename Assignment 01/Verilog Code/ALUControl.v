module ALUControl (
    input [1:0] ALUOp,
    input [3:0] FuncCode,
    output reg [3:0] ALUCtl
    );

    parameter [3:0] ADD = 4'b0010;
    parameter [3:0] SUBTRACT = 4'b0110;
    parameter [3:0] AND = 4'b0000;
    parameter [3:0] OR = 4'b0001;
    parameter [3:0] NOR = 4'b1100;
    parameter [3:0] SLT = 4'b0111;

    always@(*) begin
        case (ALUOp)
            2'b00: ALUCtl = ADD;
            2'b01: ALUCtl = SUBTRACT;
            2'b10: begin
                case (FuncCode)
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
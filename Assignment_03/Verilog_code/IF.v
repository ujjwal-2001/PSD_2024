//====================================================//
// File Name    :   IF.v
// Module Name  :   IF
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   3
// Topic        :   32-bit RISC-V 5-stage Pipelined Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// 
//----------------------------------------------------------------------------------------------------//

module IF(
    input wire clock, reset, PCSrc,
    input wire [31:0] PCBranch,
    output wire [31:0] Instruction,
    output reg [31:0] PC
);

    reg [31:0] PC_reg;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            PC_reg <= 32'd0;
            PC <= 32'd0;
        end
        else begin
            PC_reg <= (PCSrc) ? PCBranch : PC_reg + 32'd1;
            PC <= PC_reg;
        end
    end

    blk_mem_gen_0 InstructionMem (
        .clka(clock),
        .ena(1'b1),
        .wea(1'b0),
        .addra(10'd0),
        .dina(32'd0),
        .clkb(clock),
        .enb(1'b1),
        .addrb(PC_reg[9:0]),
        .doutb(Instruction)
    );

endmodule
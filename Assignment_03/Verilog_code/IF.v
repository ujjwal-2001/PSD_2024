//====================================================//
// File Name    :   IF.v
// Module Name  :   IF
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   3
// Topic        :   32-bit RISC-V 5-stage Pipelined Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This is INstruction Fetch stage of the 32-bit RISC-V 5-stage pipelined processor. The instruction
// memory is a 32-bit memory that stores the instructions to be executed. Instruction memeory is a BRAM
// whuch takes one cycle to read the instruction. 
//----------------------------------------------------------------------------------------------------//

module IF(
    input  wire clock, reset, PCSrc,
    input  wire [31:0] PCBranch,
    output wire [31:0] Instruction,
    output reg  [31:0] PC
);

    reg [31:0] PC_reg;

    always @(posedge clock) begin
        if (reset) begin
            PC_reg  <= 32'd0;
            PC      <= 32'd0;
        end
        else begin
            PC_reg  <= (PCSrc) ? PCBranch : PC_reg + 32'd1;
            PC      <= PC_reg;
        end
    end

    blk_mem_gen_0 InstructionMem (      // Instruction memory - BRAM
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
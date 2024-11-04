//====================================================//
// File Name    :   IF.v
// Module Name  :   IF
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   3
// Topic        :   32-bit RISC-V 5-stage Pipelined Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This is Instruction Fetch stage of the 32-bit RISC-V 5-stage pipelined processor. The instruction
// memory is a 32-bit memory that stores the instructions to be executed. Instruction memeory is a BRAM
// whuch takes one cycle to read the instruction. 
//----------------------------------------------------------------------------------------------------//

module IF(
    input  wire clock, reset, PCSrc,
    input  wire [31:0] PCBranch,
    input  wire PC_en,
    input  wire IF_en,
    input  wire Insert_NOP,
    output reg  [31:0] Instruction,
    output reg  [31:0] PC,
    output wire hit
);
    parameter [31:0] NOP = 32'h00000033; // No operation instruction: add x0, x0, x0

    reg  [31:0] PC_reg, PC_reg_q;
    reg  hit_q;
    wire [31:0] InstructionFromMem, InstructionFromCache;
    wire [31:0] Instruction_d;
    wire [37:0] CacheData, CacheWriteData;
    wire [4:0]  Tag;
    wire Valid, CacheWe;
    
    assign InstructionFromCache = CacheData[31:0];
    assign Tag   = CacheData[36:32];
    assign Valid = CacheData[37];
    assign hit   = (Tag == PC_reg[9:5]) & Valid;
    assign CacheWe = ~hit_q & ~reset;
    assign CacheWriteData = {1'b1, PC_reg_q[9:5], InstructionFromMem};

    assign Instruction_d = (Insert_NOP)? NOP : InstructionFromCache; // Insert NOP if required

    always @(posedge clock) begin
        if (reset) begin
            PC_reg   <= 32'd0;
            PC_reg_q <= 32'd0;
            PC       <= 32'd0;
            hit_q    <= 1'b0;
            Instruction <= 32'd0;
        end
        else begin
            PC_reg   <= (PC_en)? (PCSrc) ? PCBranch : PC_reg + 32'd1 : PC_reg;
            PC_reg_q <= PC_reg;
            PC       <= (IF_en)? PC_reg : PC;
            hit_q    <= hit;
            Instruction <= (hit & IF_en)? Instruction_d : Instruction;
        end
    end
    
    dist_mem_gen_0 InstructionCache (
    .a(PC_reg_q[4:0]),      // Write address
    .d(CacheWriteData),     // Write data
    .dpra(PC_reg[4:0]),     // Read address
    .clk(clock),            // Clock
    .we(CacheWe),           // Write enable
    .dpo(CacheData)         // Read data
    );

    blk_mem_gen_0 InstructionMem (      // Instruction memory - BRAM
        .clka(clock),
        .ena(1'b1),
        .wea(1'b0),
        .addra(10'd0),
        .dina(32'd0),
        .clkb(clock),
        .enb(1'b1),
        .addrb(PC_reg[9:0]),
        .doutb(InstructionFromMem)
    );

endmodule
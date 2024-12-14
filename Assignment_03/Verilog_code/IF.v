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
    wire [127:0]InstructionFromMem;
    wire [31:0] InstructionFromCache;
    wire [31:0] Instruction_d;
    wire [31:0] CacheData0, CacheData1, CacheData2, CacheData3;
    reg  [36:0] ValidTagCacheData;
    wire [31:0] CacheWriteData0, CacheWriteData1, CacheWriteData2, CacheWriteData3;
    wire [4:0]  ValidTag;
    wire [4:0]  ValidTagWrite;
    wire CacheWe;
    
    assign InstructionFromCache = ValidTagCacheData[31:0];
    assign Tag   = ValidTagCacheData[35:32];
    assign Valid = ValidTagCacheData[36];
    assign hit   = (Tag == PC_reg[9:6]) & Valid;
    assign CacheWe = ~hit_q & ~reset;
    assign CacheWriteData0 = InstructionFromMem[31:0];
    assign CacheWriteData1 = InstructionFromMem[63:32];
    assign CacheWriteData2 = InstructionFromMem[95:64];
    assign CacheWriteData3 = InstructionFromMem[127:96];
    assign ValidTagWrite = {1'b1, PC_reg_q[9:6]};

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

    always@(*)begin
        case(PC_reg[1:0])
            2'b00: ValidTagCacheData = {ValidTag, CacheData0};
            2'b01: ValidTagCacheData = {ValidTag, CacheData1};
            2'b10: ValidTagCacheData = {ValidTag, CacheData2};
            2'b11: ValidTagCacheData = {ValidTag, CacheData3};
        endcase
    end
    
    dist_mem_gen_0 InstructionCache0 (
    .a(PC_reg_q[5:2]),      // Write address
    .d(CacheWriteData0),    // Write data
    .dpra(PC_reg[5:2]),     // Read address
    .clk(clock),            // Clock
    .we(CacheWe),           // Write enable
    .dpo(CacheData0)        // Read data
    );

    dist_mem_gen_0 InstructionCache1 (
    .a(PC_reg_q[5:2]),      // Write address
    .d(CacheWriteData1),    // Write data
    .dpra(PC_reg[5:2]),     // Read address
    .clk(clock),            // Clock
    .we(CacheWe),           // Write enable
    .dpo(CacheData1)        // Read data
    );

    dist_mem_gen_0 InstructionCache2 (
    .a(PC_reg_q[5:2]),      // Write address
    .d(CacheWriteData2),    // Write data
    .dpra(PC_reg[5:2]),     // Read address
    .clk(clock),            // Clock
    .we(CacheWe),           // Write enable
    .dpo(CacheData2)        // Read data
    );

    dist_mem_gen_0 InstructionCache3 (
    .a(PC_reg_q[5:2]),      // Write address
    .d(CacheWriteData3),    // Write data
    .dpra(PC_reg[5:2]),     // Read address
    .clk(clock),            // Clock
    .we(CacheWe),           // Write enable
    .dpo(CacheData3)        // Read data
    );

    dist_mem_gen_2 ValidTagMem (
    .a(PC_reg_q[5:2]),      // Write address
    .d(ValidTagWrite),      // Write data
    .dpra(PC_reg[5:2]),     // Read address
    .clk(clock),            // Clock
    .we(CacheWe),           // Write enable
    .dpo(ValidTag)          // Read data
    );


    blk_mem_gen_0 InstructionMem (      // Instruction memory - BRAM
        .clka(clock),
        .ena(1'b1),
        .wea(1'b0),
        .addra(10'd0),
        .dina(32'd0),
        .clkb(clock),
        .enb(1'b1),
        .addrb(PC_reg[9:2]),
        .doutb(InstructionFromMem)
    );

endmodule
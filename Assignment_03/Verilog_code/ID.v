//====================================================//
// File Name    :   ID.v
// Module Name  :   ID
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   3
// Topic        :   32-bit RISC-V 5-stage Pipelined Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This is Instruction Decode stage of the 32-bit RISC-V 5-stage pipelined processor. The control signals
// are generated based on the instruction opcode and funct3. The register file is read to get the values
// of the registers. The immediate value is generated based on the instruction.
//----------------------------------------------------------------------------------------------------//

module ID(
    input  wire clock, reset, Discard_ID,
    input  wire [31:0] Instruction,
    input  wire [31:0] PC_IF,
    input  wire RegWrite_MEM,
    input  wire [4:0]  WriteReg_MEM,
    input  wire [31:0] WriteData,
    input  wire hit,
    output reg  [31:0] PC_ID,
    output reg  Branch_ID, Jump_ID, MemWrite_ID, 
    output reg  [1:0]  ALUOp_ID, MemtoReg_ID,
    output reg  RegWrite_ID, ALUSrc_ID,
    output reg  sw_ID, sh_ID, sb_ID,
    output reg  lw_ID, lh_ID, lhu_ID, lb_ID, lbu_ID,
    output wire [31:0] ReadData1, ReadData2,
    output reg  [4:0]  WriteReg_ID,
    output reg  [4:0]  ReadReg1_ID, ReadReg2_ID,
    output wire [31:0] RF1, RF2, RF3, RF4, RF5, RF6, RF7, RF8, RF9, RF10,
    output reg  [31:0] Immediate,
    output reg  [3:0]  FuncCode
);
    wire Branch, Jump, MemWrite; 
    wire [1:0] ALUOp, MemtoReg;
    wire RegWrite, ALUSrc;
    wire sw, sh, sb;
    wire lw, lh, lhu, lb, lbu;
    wire [31:0] Immediate_d;
    wire [4:0] Read1,Read2;
    wire [6:0] opcode;
    wire [2:0] funct3;

    assign Read1  = Instruction[19:15];
    assign Read2  = Instruction[24:20];
    assign opcode = Instruction[6:0];
    assign funct3 = Instruction[14:12];

    always @(posedge clock) begin
        if (reset || Discard_ID) begin
            PC_ID       <= 32'd0;
            {Branch_ID, Jump_ID, MemWrite_ID}    <= 3'b000;
            {ALUOp_ID, MemtoReg_ID, RegWrite_ID, ALUSrc_ID} <= 6'b0;
            {lw_ID, lh_ID, lhu_ID, lb_ID, lbu_ID} <= 5'b00000;
            {sw_ID, sh_ID, sb_ID}       <= 3'b000;
            {ReadReg1_ID, ReadReg2_ID}  <= 10'b00000;
            WriteReg_ID <= 5'b00000;
            Immediate   <= 32'd0;
            FuncCode    <= 4'd0;
        end
        else if (hit) begin
            PC_ID       <= PC_IF;
            Branch_ID   <= Branch;
            Jump_ID     <= Jump;
            MemWrite_ID <= MemWrite;
            ALUOp_ID    <= ALUOp;
            MemtoReg_ID <= MemtoReg;
            RegWrite_ID <= RegWrite;
            ALUSrc_ID   <= ALUSrc;
            {sw_ID, sh_ID, sb_ID} <= {sw, sh, sb};
            {lw_ID, lh_ID, lhu_ID, lb_ID, lbu_ID} <= {lw, lh, lhu, lb, lbu};
            ReadReg1_ID <= Instruction[19:15];
            ReadReg2_ID <= Instruction[24:20];
            WriteReg_ID <= Instruction[11:7];
            Immediate   <= Immediate_d;
            FuncCode    <= {Instruction[30], Instruction[14:12]};
        end
    end

    Control ControlUnit (                   // Control unit
        .funct3(funct3),
        .opcode(opcode),
        .Branch(Branch),
        .Jump(Jump),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .sw(sw),
        .sh(sh),
        .sb(sb),
        .lw(lw),
        .lh(lh),
        .lhu(lhu),
        .lb(lb),
        .lbu(lbu)
    );

    RegisterFile RegisterFile (             // Register file
        .clock(clock),
        .reset(reset),
        .Read1(Read1),
        .Read2(Read2),
        .WriteReg(WriteReg_MEM),
        .WriteData(WriteData),
        .RegWrite(RegWrite_MEM & hit),
        .ReadEn(hit),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .RF1(RF1),
        .RF2(RF2),
        .RF3(RF3),
        .RF4(RF4),
        .RF5(RF5),
        .RF6(RF6),
        .RF7(RF7),
        .RF8(RF8),
        .RF9(RF9),
        .RF10(RF10)
    );

    ImmGen ImmGen(                          // Immediate generator
        .Instruction(Instruction),
        .Immediate(Immediate_d)
    );

endmodule
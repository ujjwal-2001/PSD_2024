//====================================================//
// File Name    :   EXE.v
// Module Name  :   EXE
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   3
// Topic        :   32-bit RISC-V 5-stage Pipelined Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This is the execuite stage of the 32-bit RISC-V 5-stage pipelined processor. The ALU module is used
// to perform arithmetic and logical operations on the inputs. The control signals are passed to the
// data memory module to read and write data. The output of the ALU is stored in the ALUResult register.
//----------------------------------------------------------------------------------------------------//

module EXE(
    input  wire clock, reset,
    input  wire [31:0] PC_ID,
    input  wire Branch_ID, Jump_ID, MemWrite_ID, 
    input  wire [1:0]  ALUOp_ID, MemtoReg_ID,
    input  wire RegWrite_ID, ALUSrc_ID,
    input  wire sw_ID, sh_ID, sb_ID,
    input  wire lw_ID, lh_ID, lhu_ID, lb_ID, lbu_ID,
    input  wire [31:0] ForwardDataA, ForwardDataB,
    input  wire [4:0]  WriteReg_ID,
    input  wire [31:0] Immediate,
    input  wire [3:0]  FuncCode,
    output wire PCSrc,
    output reg  [31:0] ALUResult,
    output reg  Branch_EXE, Jump_EXE, MemWrite_EXE, 
    output reg  [1:0]  MemtoReg_EXE,
    output reg  RegWrite_EXE,
    output reg  sw_EXE, sh_EXE, sb_EXE,
    output reg  lw_EXE, lh_EXE, lhu_EXE, lb_EXE, lbu_EXE,
    output wire [31:0] PCBranch,
    output reg  [31:0] Immediate_EXE,
    output reg  [31:0] MemWriteData,
    output reg  [4:0]  WriteReg_EXE
);

    wire [3:0] ALUCtl;
    wire [31:0] B;
    wire [31:0] ALUResult_d;
    wire Zero;

    assign B        = (ALUSrc_ID) ? Immediate : ForwardDataB;
    assign PCSrc    = (Branch_ID & Zero) | Jump_ID;
    assign PCBranch = PC_ID + Immediate;

    always@(posedge clock) begin
        if (reset) begin
            ALUResult     <= 32'd0;
            {Branch_EXE, Jump_EXE, MemWrite_EXE, MemtoReg_EXE, RegWrite_EXE}   <= 0;
            {sw_EXE, sh_EXE, sb_EXE, lw_EXE, lh_EXE, lhu_EXE, lb_EXE, lbu_EXE} <= 0;
            MemWriteData  <= 32'd0;
            WriteReg_EXE  <= 5'd0;
            Immediate_EXE <= 32'd0;
        end
        else begin
            ALUResult     <= ALUResult_d;
            MemWrite_EXE  <= MemWrite_ID;
            MemtoReg_EXE  <= MemtoReg_ID;
            RegWrite_EXE  <= RegWrite_ID;
            {sw_EXE, sh_EXE, sb_EXE} <= {sw_ID, sh_ID, sb_ID};
            {lw_EXE, lh_EXE, lhu_EXE, lb_EXE, lbu_EXE} <= {lw_ID, lh_ID, lhu_ID, lb_ID, lbu_ID};
            MemWriteData  <= ForwardDataB;
            WriteReg_EXE  <= WriteReg_ID;
            Immediate_EXE <= Immediate;
        end
    end

    ALUControl ALUControl(              // ALU control
        .ALUOp(ALUOp_ID),
        .FuncCode(FuncCode),
        .ALUCtl(ALUCtl)
    );

    ALU ALU(                            // ALU
        .ALUCtl(ALUCtl),
        .A(ForwardDataA),
        .B(B),
        .ALUResult(ALUResult_d),
        .Zero(Zero)
    );

endmodule
//====================================================//
// File Name    :   MEM.v
// Module Name  :   MEM
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   3
// Topic        :   32-bit RISC-V 5-stage Pipelined Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// This is the memory stage of the 32-bit RISC-V 5-stage pipelined processor. The data memory module is
// used to read and write data. The control signals are passed to the data memory module to read and write
// data. The output of the data memory is stored in the ReadData register. Data memory uses registered 
// distributed memory to store the data. Thus, takes one cycle to read and write the data.
//----------------------------------------------------------------------------------------------------//

module MEM(
    input  wire clock,       // Clock
    input  wire reset,       // Reset
    input  wire MemWrite_EXE,
    input  wire hit,
    input  wire [1:0] MemtoReg_EXE,
    input  wire RegWrite_EXE,
    input  wire sw_EXE, sh_EXE, sb_EXE,
    input  wire lw_EXE, lh_EXE, lhu_EXE, lb_EXE, lbu_EXE,
    input  wire [4:0] WriteReg_EXE,
    input  wire [31:0] ALUResult, MemWriteData, Immediate_EXE,
    output reg  [31:0] ALUResult_MEM, Immediate_MEM,
    output reg  [31:0] ReadData,
    output reg  [1:0] MemtoReg_MEM,
    output reg  RegWrite_MEM,
    output reg  [4:0] WriteReg_MEM
);

    wire [31:0] ReadData_d;

    always@(posedge clock)begin
        if(reset)begin
            ALUResult_MEM <= 32'd0;
            Immediate_MEM <= 32'd0;
            MemtoReg_MEM  <= 2'b00;
            RegWrite_MEM  <= 1'b0;
            WriteReg_MEM  <= 5'd0;
            ReadData      <= 32'd0;
        end
        else if (hit) begin
            ALUResult_MEM <= ALUResult;
            Immediate_MEM <= Immediate_EXE;
            MemtoReg_MEM  <= MemtoReg_EXE;
            RegWrite_MEM  <= RegWrite_EXE;
            WriteReg_MEM  <= WriteReg_EXE;
            ReadData      <= ReadData_d;
        end
    end

    DataMem DataMem(                    // Data memory
        .clock(clock),
        .Address(ALUResult),
        .WriteData(MemWriteData),
        .MemWrite(MemWrite_EXE),
        .sw(sw_EXE & hit),
        .sh(sh_EXE & hit),
        .sb(sb_EXE & hit),
        .lw(lw_EXE & hit),
        .lh(lh_EXE & hit),
        .lhu(lhu_EXE & hit),
        .lbu(lbu_EXE & hit),
        .lb(lb_EXE & hit),
        .ReadData(ReadData_d)
    );

endmodule
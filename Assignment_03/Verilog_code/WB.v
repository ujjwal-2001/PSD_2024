//====================================================//
// File Name    :   WB.v
// Module Name  :   WB
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   3
// Topic        :   32-bit RISC-V 5-stage Pipelined Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// 
//----------------------------------------------------------------------------------------------------//

module WB(
    input wire [1:0] MemtoReg_MEM,
    input wire [31:0] ALUResult_MEM,
    input wire [31:0] ReadData,
    input wire [31:0] Immediate_MEM,
    output wire [31:0] WriteData
    );

    assign WriteData = (MemtoReg_MEM[1])? Immediate_MEM : (MemtoReg_MEM[0])? ReadData : ALUResult_MEM;

endmodule
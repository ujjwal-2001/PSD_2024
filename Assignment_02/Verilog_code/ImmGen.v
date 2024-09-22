//====================================================//
// File Name    :   ImmGen.v
// Module Name  :   ImmGen
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//

//----------------------------------------------------------------------------------------------------//

module ImmGen(
    input wire [31:0] Instruction,
    output wire [31:0] Immediate
);
//====================================================//
// File Name    :   ImmGen.v
// Module Name  :   ImmGen
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// Construction immediate depending on the op code.
// Immediate for various instructions are constructed as follows:
// 1. I-type : 12-bit immediate = {.....Instruction[31], Instruction[30:20]}
// 2. S-type : 12-bit immediate = {.....Instruction[31], Instruction[30:25], Instruction[11:7]}
// 3. SB-type: 12-bit immediate = {....Instruction[31], Instruction[30:25], Instruction[11:7]}
// 4. U-type : 20-bit immediate = {Instruction[31], Instruction[30:12], 12'b0}
// 5. UJ-type: 19-bit immediate = {....Instruction[31], Instruction[18:12], Instruction[19], Instruction[30:20]}
//----------------------------------------------------------------------------------------------------//

module ImmGen(
    input  wire [31:0] Instruction,      // 32-bit instruction
    output wire [31:0] Immediate         // 32-bit immediate
);

    // Defining the opcodes
    parameter R_TYPE  = 7'b0110011;
    parameter I_TYPE1 = 7'b0000011;
    parameter I_TYPE2 = 7'b0010011;
    parameter S_TYPE  = 7'b0100011;
    parameter SB_TYPE = 7'b1100111;
    parameter U_TYPE  = 7'b0110111;
    parameter UJ_TYPE = 7'b1101111;

    wire [6:0] opcode;

    assign opcode = Instruction[6:0];

    // Immediate Generation
    assign Immediate[31]    = Instruction[31];
    assign Immediate[30:19] = (opcode == U_TYPE)? Instruction[30:19] : {12{Instruction[31]}};
    assign Immediate[18:12] = (opcode == U_TYPE || opcode == UJ_TYPE)? Instruction[18:12] : {7{Instruction[31]}};
    assign Immediate[11]    = (opcode == UJ_TYPE)? Instruction[19] : (opcode == U_TYPE)? 1'b0 : Instruction[31];
    assign Immediate[10:5]  = (opcode == U_TYPE)? 6'b0 : Instruction[30:25];
    assign Immediate[4:1]   = (opcode == U_TYPE)? 4'b0 : (opcode == S_TYPE || opcode == SB_TYPE)? Instruction[11:8] : Instruction[24:21];
    assign Immediate[0]     = (opcode == U_TYPE)? 1'b0 : (opcode == S_TYPE || opcode == SB_TYPE)? Instruction[7] : Instruction[20];

endmodule

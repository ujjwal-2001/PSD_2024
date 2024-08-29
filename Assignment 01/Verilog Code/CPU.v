//====================================================//
// File Name    :   CPU.v
// Module Name  :   CPU
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   1
// Topic        :   16-bit Multi-cycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION-----------------------------------------------//
// This is a CPU module that contains the main components of a MIPS processor. The module contains
// a state machine that sequences the operations of the processor based on the opcode of the instruction.
// The module interfaces with the DataPath module to control the operation of the processor. The module
// contains control signals for the DataPath module and updates the state machine based on the opcode
// of the instruction. The module is synchronous and updates the state machine on the positive edge of
// the clock signal.
//--------------------------------------------------------------------------------------------------------//

// `include "DataPath.v"

module CPU (
    input clock,    // Clock signal
    input reset     // Reset signal
    );

    // Opcode definitions
    parameter LW    = 3'b001;
    parameter SW    = 3'b010;
    parameter BEQ   = 3'b011;
    parameter J     = 3'b100;
    parameter R     = 3'b000; 
    parameter END   = 3'b111;  
    
    reg [3:0] state, nextstate;             // State and next state
    wire [1:0] ALUOp, ALUSrcB, PCSource;    // Control signals
    wire [2:0] opcode;                      // Opcode of the instruction
    wire RegDst, MemRead, MemWrite;         // Control signals
    wire  IorD, RegWrite, IRWrite;          // Control signals
    wire  PCWrite, PCWriteCond, ALUSrcA;    // Control signals
    wire  IRWwrite, MemtoReg;               // Control signals

    DataPath DP (                // DataPath module instance
        .ALUOp(ALUOp), 
        .ALUSrcB(ALUSrcB), 
        .PCSource(PCSource), 
        .RegDst(RegDst), 
        .MemtoReg(MemtoReg),
        .MemRead(MemRead), 
        .MemWrite(MemWrite), 
        .IorD(IorD), 
        .RegWrite(RegWrite), 
        .IRWrite(IRWrite),
        .PCWrite(PCWrite), 
        .PCWriteCond(PCWriteCond), 
        .ALUSrcA(ALUSrcA), 
        .clock(clock), 
        .reset(reset),
        .opcode(opcode)
    );
    
    // Control signals based on state and opcode
    assign PCWrite      = (state==0) | (state==9);
    assign PCWriteCond  = (state==8); 
    assign IorD         = (state==3) | (state==5); 
    assign MemRead      = (state==0) | (state==3);
    assign MemWrite     = (state==5);
    assign IRWrite      = (state==0);
    assign MemtoReg     = (state==4);
    assign PCSource     = {(state==9), (state==8)}; 
    assign ALUOp        = {(state==6), (state==8)}; 
    assign ALUSrcB      = {(state==1) | (state==2), (state==1) | (state==0)};
    assign ALUSrcA      = (state==2) | (state==6) | (state==8);
    assign RegWrite     = (state==4) | (state==7);
    assign RegDst       = (state==7);

    // Next state logic
    // The state machine sequences the operations based on the opcode
    // State 0: Fetch instruction
    // State 1: Decode instruction
    // State 2: Memory address calculation
    // State 3: Memory access for load
    // State 4: Write data to memory
    // State 5: Memory access for store
    // State 6: Execute R-type instruction
    // State 7: R-type instruction computation
    // State 8: Branch completion
    // State 9: Jump completion
    // state 10: End
    always@(*)begin
        case(state)
            4'd0: nextstate = 4'd1; 
            4'd1: begin
                case(opcode)
                    LW  : nextstate = 4'd2;
                    SW  : nextstate = 4'd2;
                    R   : nextstate = 4'd6;
                    BEQ : nextstate = 4'd8;
                    J   : nextstate = 4'd9;
                    END : nextstate = 4'd10;
                    default: nextstate = 4'd6;
                endcase
            end 
            4'd2 : nextstate = (opcode==LW) ? 4'd3 : 4'd5;
            4'd3 : nextstate = 4'd4;
            4'd4 : nextstate = 4'd0;
            4'd5 : nextstate = 4'd0;
            4'd6 : nextstate = 4'd7;
            4'd7 : nextstate = 4'd0;
            4'd8 : nextstate = 4'd0;
            4'd9 : nextstate = 4'd0;
            4'd10: nextstate = 4'd10;
            default: nextstate = 4'd1;            
        endcase
    end

    // Update the state on the positive edge of the clock
    always @(posedge clock) begin 
        if(reset) state <= 4'd0;
        else state <= nextstate;
    end

endmodule
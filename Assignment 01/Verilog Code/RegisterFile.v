//====================================================//
// File Name:   RegisterFile.v
// Module Name: RegisterFile
// Author:      Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course:      E3 245 Processor System Design
// Assignment:  1
// Topic:       16-bit Multi-cycle Processor
// ===================================================//

//------------------DESCRIPTION------------------//
// This is a register file module that contains
// 8 16-bit registers. Module reads data from two
// registers always and writes data to a register
// only when RegWrite is high. The module is
// synchronous and updates the registers on the
// positive edge of the clock signal.
//-------------------------------------------------//

module RegisterFile (
    input [2:0] Read1,             // Register 1 address
    input [2:0] Read2,             // Register 2 address
    input [2:0] WriteReg,          // Register to write to
    input [15:0] WriteData,        // Data to be written
    input RegWrite,                // Write enable
    input clock,                   // Clock signal
    output [15:0] Data1,           // Data read from Read1
    output [15:0] Data2            // Data read from Read2
    );
    
    reg [15:0] RF [7:0]; // 8 16-bit registers

    // Read data from registers
    assign Data1 = RF[Read1];   
    assign Data2 = RF[Read2];

    // Write data to a register if RegWrite is high
    always@(posedge clock)begin
        if (RegWrite) RF[WriteReg] <= WriteData;
    end

endmodule
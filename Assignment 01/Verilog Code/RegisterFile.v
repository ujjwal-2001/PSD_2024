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
    input reset,                   // Reset signal
    output [15:0] Data1,           // Data read from Read1
    output [15:0] Data2            // Data read from Read2
    );
    
    reg [15:0] RF [7:0]; // 8 16-bit registers

    // Read data from registers
    assign Data1 = RF[Read1];   
    assign Data2 = RF[Read2];

    // Write data to a register if RegWrite is high
    always@(posedge clock)begin

        if(reset)begin
            RF[1] <= 16'b0;
            RF[2] <= 16'b0;
            RF[3] <= 16'b0;
            RF[4] <= 16'b0;
            RF[5] <= 16'b0;
            RF[6] <= 16'b0;
            RF[7] <= 16'b0;
        end

        if (RegWrite) begin
            if(WriteReg != 3'b000)begin     // Ignore writes to register 0
                RF[WriteReg] <= WriteData;  // Write data to the specified register
            end
        end

    end

endmodule
//====================================================//
// File Name    :   RegisterFile.v
// Module Name  :   RegisterFile
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-cycle Processor
// ===================================================//

//-----------------------------------DESCRIPTION-----------------------------------------------//
// This is a register file module that contains 32 32-bit registers. Module reads data from two
// registers always and writes data to a register only when RegWrite is high. The module is
// synchronous and updates the registers on the positive edge of the clock signal.
//---------------------------------------------------------------------------------------------//

module RegisterFile (
    input  wire [4:0] Read1,             // Register 1 address
    input  wire [4:0] Read2,             // Register 2 address
    input  wire [4:0] WriteReg,          // Register to write to
    input  wire [31:0] WriteData,        // Data to be written
    input  wire RegWrite,                // Write enable
    input  wire clock,                   // Clock signal
    input  wire reset,                   // Reset signal
    output wire [31:0] ReadData1,        // Data read from Read1
    output wire [31:0] ReadData2,        // Data read from Read2
    output wire [31:0] RF1,              // Register 1 data
    output wire [31:0] RF2,              // Register 2 data
    output wire [31:0] RF3,              // Register 3 data
    output wire [31:0] RF4,              // Register 4 data
    output wire [31:0] RF5,              // Register 5 data
    output wire [31:0] RF6,              // Register 6 data
    output wire [31:0] RF7,              // Register 7 data
    output wire [31:0] RF8,              // Register 8 data
    output wire [31:0] RF9,              // Register 9 data
    output wire [31:0] RF10              // Register 10 data
    );
    
    reg [31:0] RF [31:0]; // 32, 32-bit registers
    integer i;
    // Read data from registers
    assign ReadData1 = RF[Read1];   
    assign ReadData2 = RF[Read2];

    // Assign data to the output registers
    assign RF1 = RF[1]; 
    assign RF2 = RF[2];
    assign RF3 = RF[3];
    assign RF4 = RF[4];
    assign RF5 = RF[5];
    assign RF6 = RF[6];
    assign RF7 = RF[7];
    assign RF8 = RF[8];
    assign RF9 = RF[9];
    assign RF10 = RF[10];
    
    // Write data to a register if RegWrite is high
    always@(posedge clock)begin

        if(reset)begin
            for(i=0; i<32; i=i+1)begin
                RF[i] <= 32'd0; 
            end
        end

        if (RegWrite) begin
            if(WriteReg != 5'd0)begin       // Ignore writes to register 0
                RF[WriteReg] <= WriteData;  // Write data to the specified register
            end
        end

    end

endmodule
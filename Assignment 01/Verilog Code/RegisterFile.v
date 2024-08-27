//------------------DESCRIPTION------------------//
// This is a register file module that contains
// 8 16-bit registers. Module reads data from two
// registers always and writes data to a register
// only when RegWrite is high. The module is
// synchronous and updates the registers on the
// positive edge of the clock signal.
//-------------------------------------------------//

module registerfile (
    input [2:0] Read1, Read2, WriteReg,     // Register addresses
    input [15:0] WriteData,                 // Data to be written
    input RegWrite,                         // Write enable
    input clock,                            // Clock signal
    output [15:0] Data1,                    // Data read from Read1
    output [15:0] Data2                     // Data read from Read2
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
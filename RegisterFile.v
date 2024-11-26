module RegisterFile(clk,rst,readReg1,readReg2,readData1,readData2,RegWrite,writeRegister,writeData);

input [4:0] readReg1,readReg2,writeRegister;
input [31:0] writeData;
input RegWrite,clk,rst;
output [31:0] readData1,readData2;

reg [31:0] registers [31:0];

always @(posedge clk, posedge rst) begin
    
end

endmodule
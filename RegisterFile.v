module RegisterFile(clk,rst,readReg1,readReg2,readData1,readData2,RegWriteEn,writeRegister,writeData);

input [4:0] readReg1,readReg2,writeRegister;
input [31:0] writeData;
input RegWriteEn,clk,rst;
output [31:0] readData1,readData2;

reg [31:0] GPReg [31:0];
integer i;

// Hardwire GPReg[0] to 0 outside of procedural blocks
// GPReg[0] = 32'd0;  // x0 is hardwired to 0
// unable to assign to 0 here. We need to reset to initialize 

//Write
always @(posedge clk, posedge rst) begin
    if (rst) begin
    // Reset all registers to 0, but GPReg[0] is already hardwired to 0
    for (i = 0; i < 32; i = i + 1) begin
        GPReg[i] <= 32'b0;
        end 
    end
    else if(RegWriteEn == 1'b1 && writeRegister != 5'd0) begin
        GPReg[writeRegister] <= writeData;
    end

end

assign readData1 = GPReg[readReg1];
assign readData2 = GPReg[readReg2];

endmodule
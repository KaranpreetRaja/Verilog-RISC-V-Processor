module RegisterFile(clk,readReg1,readReg2,readData1,readData2,RegWriteEn,writeRegister,writeData);

input [4:0] readReg1,readReg2,writeRegister;
input [31:0] writeData;
input RegWriteEn,clk;
output [31:0] readData1,readData2;

reg [31:0] GPReg [31:0];
GPReg[0] = 32'd0; //x0 is hardwired 0; 

//Write
always @(posedge clk) begin
    if(RegWriteEn == 1'b1 && writeRegister != 5'd0) begin
        GPReg[writeRegister] <= writeData;
    end

end

assign readData1 = GPReg[readReg1];
assign readData2 = GPReg[readReg2];

endmodule
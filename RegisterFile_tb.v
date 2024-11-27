`timescale 1ns/1ns
`include "RegisterFile.v"

module RegisterFile_tb;

wire [31:0] dataOut1, dataOut2;
reg [31:0] dataIn;
reg [4:0] readReg1,readReg2,writeRegister;
reg writeEnable,clk,rst;

RegisterFile dut(.clk(clk),.rst(rst), .readReg1(readReg1), .readReg2(readReg2),.readData1(dataOut1), 
.readData2(dataOut2), .RegWriteEn(writeEnable), .writeData(dataIn), .writeRegister(writeRegister));

initial begin
    $display("rs1: %d value: %h, rs2: %d value: %h, rd:%d valueIn: %h"
    ,readReg1,dataOut1,readReg2,dataOut2,writeRegister,dataIn);
    clk = 1'b0;
    rst = 1'b0;
    #1

    //Toggle Reset 
    rst = ~rst;
    #1 rst = ~rst;

    //Cycle Clock
    clk = ~clk;
    #1 clk = ~clk;

    readReg1 = 3;
    readReg2 = 4;
    writeRegister = 6;
    writeEnable =0;
    dataIn = 32'h000_FF00;
    #1
    $display("rs1: %d value: %h, rs2: %d value: %h, rd:%d valueIn: %h"
    ,readReg1,dataOut1,readReg2,dataOut2,writeRegister,dataIn);

    //Cycle Clock
    clk = ~clk;
    #1 clk = ~clk;
    $display("rs1: %d value: %h, rs2: %d value: %h, rd:%d valueIn: %h"
    ,readReg1,dataOut1,readReg2,dataOut2,writeRegister,dataIn);
    
    writeEnable=1;
    //Cycle Clock
    clk = ~clk;
    #1 clk = ~clk;
    
    #2
    readReg1 = 6;
    readReg2 = 4;
    $display("rs1: %d value: %h, rs2: %d value: %h, rd:%d valueIn: %h"
    ,readReg1,dataOut1,readReg2,dataOut2,writeRegister,dataIn);

end

endmodule
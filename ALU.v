`include "mux.v"
module ALU(operandA,operandB,ImEx,opcode,func3,func7,result);

input [31:0] operandA, operandB,ImEx;
input [6:0] opcode, func7;
input [2:0] func3;
output [31:0] result;
wire [31:0] sourceB;

mux #(32)SrcB(
        .muxOut(sourceB),
        .dataA(operandB),
        .dataB(ImEx),
        .select(opcode[5])
    );



endmodule
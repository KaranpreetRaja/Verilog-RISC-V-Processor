`include "mux.v"
module ALU(operandA,operandB,ImEx,opcode,func3,func7);

input [31:0] operandA, operandB,ImEx;
input [6:0] opcode

mux #(32)SrcB(
        .muxOut(operandB),
        .dataA(op),
        .dataB(dataB),
        .select(select)
    );


endmodule
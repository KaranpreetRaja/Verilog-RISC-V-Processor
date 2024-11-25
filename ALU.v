`include "adder.v"
`include "mux.v"
module ALU(operandA,operandB,ALUop,result);

input [31:0] operandA, operandB;
input [3:0] ALUop;
output [31:0] result;

wire [31:0] negatedB, muxOut, adderOut;
wire carryIn;
assign negatedB = ~operandB;    

case(ALUop):
    4'b0000: begin  //ADD
        carryIn = 0;
        result = adderOut;
    end
    4'b0001: begin  //SUB
        carryIn = 1;
        result = adderOut;
    end
    4'b0010: result = operandA ^ operandB; //XOR
    4'b0011: result = operandA | operandB; //OR
    4'b0100: result = operandA & operandB; //AND
    4'b0101: result = operandA << operandB; //sll Shift Logical Left
    4'b0110: result = operandA >> operandB; //srl Shift Right Logical
    4'b0111: result = operandA >>> operandB; //sra Shift Right Arithmetic
    4'b1000: result = ($signed(operandA) ? $signed(operandB)) 1:0; //slt Set Less Than
    4'b1001: result = (operandA ? operandB) 1:0; //slt Set Less Than Unsigned


endcase

// Control logic: add if control = 0, subtract if control = 1
assign carryIn = control;
assign negatedB = ~operandB;          // Bitwise negation of operandB

// Mux to select between operandB and negatedB based on control
mux #(SIZE) myMux (
    .muxOut(muxOut),
    .dataA(operandB), 
    .dataB(negatedB), 
    .select(carryIn)
);

// Adder to perform addition or subtraction
adder #(SIZE) myAdder (
    .sum(adderOut), 
    .carryOut(carryOut), 
    .operandA(operandA), 
    .operandB(muxOut), 
    .carryIn(carryIn)
);

endmodule
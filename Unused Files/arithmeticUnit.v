module arithmeticUnit #(parameter SIZE = 32) (
    output [SIZE-1:0] result, 
    output carryOut, 
    input [SIZE-1:0] operandA, operandB, 
    input control
);
    wire [SIZE-1:0] negatedB, muxOut;
    wire carryIn;

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
        .sum(result), 
        .carryOut(carryOut), 
        .operandA(operandA), 
        .operandB(muxOut), 
        .carryIn(carryIn)
    );
endmodule
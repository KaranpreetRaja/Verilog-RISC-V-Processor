module adder #(parameter SIZE = 1) (
    output [SIZE-1:0] sum, 
    output carryOut, 
    input [SIZE-1:0] operandA, operandB, 
    input carryIn
);
    wire [SIZE:0] carryChain;  // Extra bit for the carry chain to propagate

    // Connecting the initial carry-in
    assign carryChain[0] = carryIn;

    // Generate block for each bit of the adder
    genvar i;
    generate
        for (i = 0; i < SIZE; i = i + 1) begin : adder_bit
            // Sum calculation using bitwise operations
            assign sum[i] = operandA[i] ^ operandB[i] ^ carryChain[i];   // XOR for sum

            // Carry-out calculation using bitwise operations
            assign carryChain[i+1] = (operandA[i] & operandB[i]) | (operandA[i] & carryChain[i]) | (operandB[i] & carryChain[i]);
        end
    endgenerate

    // Assign the final carry-out
    assign carryOut = carryChain[SIZE];
endmodule

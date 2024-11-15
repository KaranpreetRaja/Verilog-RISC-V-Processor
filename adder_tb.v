module adder_tb;
    parameter SIZE = 4; // Example size for testing
    reg [SIZE-1:0] operandA, operandB;
    reg carryIn;
    wire [SIZE-1:0] sum;
    wire carryOut;

    // Instantiate the yAdder module
    adder #(SIZE) uut (
        .sum(sum),
        .carryOut(carryOut),
        .operandA(operandA),
        .operandB(operandB),
        .carryIn(carryIn)
    );

    initial begin
        // Test case 1: Basic addition without carry-in
        operandA = 4'b0011;  // 3 in decimal
        operandB = 4'b0101;  // 5 in decimal
        carryIn = 0;
        #10;
        $display("operandA = %b, operandB = %b, carryIn = %b, sum = %b, carryOut = %b", operandA, operandB, carryIn, sum, carryOut);

        // Test case 2: Addition with carry-in
        operandA = 4'b0011;  // 3 in decimal
        operandB = 4'b0101;  // 5 in decimal
        carryIn = 1;
        #10;
        $display("operandA = %b, operandB = %b, carryIn = %b, sum = %b, carryOut = %b", operandA, operandB, carryIn, sum, carryOut);

        // Test case 3: Addition that results in carry-out
        operandA = 4'b1111;  // 15 in decimal
        operandB = 4'b0001;  // 1 in decimal
        carryIn = 0;
        #10;
        $display("operandA = %b, operandB = %b, carryIn = %b, sum = %b, carryOut = %b", operandA, operandB, carryIn, sum, carryOut);

        // Test case 4: Large addition with carry-in
        operandA = 4'b1100;  // 12 in decimal
        operandB = 4'b1010;  // 10 in decimal
        carryIn = 1;
        #10;
        $display("operandA = %b, operandB = %b, carryIn = %b, sum = %b, carryOut = %b", operandA, operandB, carryIn, sum, carryOut);

        // Test case 5: Zero addition
        operandA = 4'b0000;
        operandB = 4'b0000;
        carryIn = 0;
        #10;
        $display("operandA = %b, operandB = %b, carryIn = %b, sum = %b, carryOut = %b", operandA, operandB, carryIn, sum, carryOut);

        // Test case 6: Maximum values for operands
        operandA = 4'b1111;
        operandB = 4'b1111;
        carryIn = 1;
        #10;
        $display("operandA = %b, operandB = %b, carryIn = %b, sum = %b, carryOut = %b", operandA, operandB, carryIn, sum, carryOut);

        $finish;
    end
endmodule
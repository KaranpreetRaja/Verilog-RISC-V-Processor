module arithmeticUnit_tb;
    parameter SIZE = 4; // Example size for testing
    reg [SIZE-1:0] operandA, operandB;
    reg control;  // 0 for addition, 1 for subtraction
    wire [SIZE-1:0] result;
    wire carryOut;

    // Instantiate the ArithmeticUnit module
    arithmeticUnit #(SIZE) uut (
        .result(result),
        .carryOut(carryOut),
        .operandA(operandA),
        .operandB(operandB),
        .control(control)
    );

    initial begin
        // Test case 1: Addition (control = 0)
        operandA = 4'b0101;  // 5 in decimal
        operandB = 4'b0011;  // 3 in decimal
        control = 0;
        #10;
        $display("Operation: Addition | operandA = %b, operandB = %b, result = %b, carryOut = %b", operandA, operandB, result, carryOut);

        // Test case 2: Subtraction (control = 1)
        operandA = 4'b0101;  // 5 in decimal
        operandB = 4'b0011;  // 3 in decimal
        control = 1;
        #10;
        $display("Operation: Subtraction | operandA = %b, operandB = %b, result = %b, carryOut = %b", operandA, operandB, result, carryOut);

        // Test case 3: Addition with carry-out
        operandA = 4'b1111;  // 15 in decimal
        operandB = 4'b0001;  // 1 in decimal
        control = 0;
        #10;
        $display("Operation: Addition | operandA = %b, operandB = %b, result = %b, carryOut = %b", operandA, operandB, result, carryOut);

        // Test case 4: Subtraction with carry-out
        operandA = 4'b1000;  // 8 in decimal
        operandB = 4'b0001;  // 1 in decimal
        control = 1;
        #10;
        $display("Operation: Subtraction | operandA = %b, operandB = %b, result = %b, carryOut = %b", operandA, operandB, result, carryOut);

        // Test case 5: Zero result for addition
        operandA = 4'b0000;
        operandB = 4'b0000;
        control = 0;
        #10;
        $display("Operation: Addition | operandA = %b, operandB = %b, result = %b, carryOut = %b", operandA, operandB, result, carryOut);

        // Test case 6: Zero result for subtraction
        operandA = 4'b0011;  // 3 in decimal
        operandB = 4'b0011;  // 3 in decimal
        control = 1;
        #10;
        $display("Operation: Subtraction | operandA = %b, operandB = %b, result = %b, carryOut = %b", operandA, operandB, result, carryOut);

        $finish;
    end
endmodule
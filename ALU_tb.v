`include "ALU.v"
module ALU_tb;

reg [31:0] A,B;
wire [31:0] ALUout;
reg [3:0] opcode;

ALU dut(.operandA(A), .operandB(B), .ALUop(opcode), .result(ALUout));

integer i;

initial begin 
    $dumpfile("ALU_tb.vcd");
    $dumpvars(0, ALU_tb);

    //basic test
    A = 32'd2048;
    B = 32'd4;
    opcode = 4'b0000;
    $display("operandA Decimal: %d, operandA Hex: %h, operandB Decimal: %d, operandB Hex: %h",A,A,B,B);
    for (i = 0; i<10; i=i+1) begin
        #1
        $display("opcode: %4b, Hex result: %h, Decimal result: %d",opcode,ALUout,ALUout);
        opcode = (i+1);
    end

    //negative B test
    A = 233;
    B = -13;
    opcode = 4'b0000;
    $display("operandA Decimal: %d, operandA Hex: %h, operandB Decimal: %d, operandB Hex: %h",A,A,B,B);
    for (i = 0; i<10; i=i+1) begin
        #1
        $display("opcode: %4b, Hex result: %h, Decimal result: %d",opcode,ALUout,ALUout);
        opcode = (i+1);
    end

    //negative A test
    A = -233;
    B = 256;
    opcode = 4'b0000;
    $display("operandA Decimal: %d, operandA Hex: %h, operandB Decimal: %d, operandB Hex: %h",A,A,B,B);
    for (i = 0; i<10; i=i+1) begin
        #1
        $display("opcode: %4b, Hex result: %h, Decimal result: %d",opcode,ALUout,ALUout);
        opcode = (i+1);
    end

    //Both negative test
    A = -128;
    B = -256;
    opcode = 4'b0000;
    $display("operandA Decimal: %d, operandA Hex: %h, operandB Decimal: %d, operandB Hex: %h",A,A,B,B);
    for (i = 0; i<10; i=i+1) begin
        #1
        $display("opcode: %4b, Hex result: %h, Decimal result: %d",opcode,ALUout,ALUout);
        opcode = (i+1);
    end


end

endmodule
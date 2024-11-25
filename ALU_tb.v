`include "ALU.v"
module ALU_tb.v;

reg [31:0] A,B,ALUout;
reg [3:0] opcode;

ALU dut(.operandA(A), .operandB(B).result(ALUout));

integer i;

initial begin 
    A = 32'h00FF_0000;
    B = 32'hF000_00F0;
    opcode = 4'b0000;
    for (i = 0; i ,10; i=i+1) begin
        #1
        $display("opcode: %4b, result: %32h",opcode,ALUout);
        opcode = (i+1);
    end

end

endmodule
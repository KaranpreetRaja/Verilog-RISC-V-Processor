module ImmediateExtender (
    input [31:0] instruction,  // Entire instruction word
    input [2:0] imm_type,      // Type of instruction (e.g., I, S, B, U, J)
    output reg [31:0] imm_out  // Extended immediate value
);

always @(*) begin
    case (imm_type)
        3'b000: imm_out = {{20{instruction[31]}}, instruction[31:20]}; // I-type
        3'b001: imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S-type
        3'b010: imm_out = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B-type
        3'b011: imm_out = {instruction[31:12], 12'b0}; // U-type
        3'b100: imm_out = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J-type
        default: imm_out = 32'b0; // Default case
    endcase
end

endmodule

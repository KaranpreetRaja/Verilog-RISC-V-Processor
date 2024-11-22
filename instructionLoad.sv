module instructionLoad ( 
    input logic clk,
    input logic rst,
    input logic i_data_received,
    input logic [31:0] i_instruction,
    output logic o_write_enable,
    output logic [3:0] o_address,
    output logic [31:0] o_instruction
);

logic [31:0] r_instruction = 32'b0;
logic r_write_enable = 1'b0;
logic [1:0] r_data_received = 2'b0;
logic [2:0] r_address = 3'b000;

enum {
    IDLE,
    RECEIVE,
    WRITE,
    ADDR_INCR
} curr_state, next_state;

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        r_data_received <= 2'b0;
    end
    else begin
        r_data_received <= {r_data_received[1], i_data_received};
    end
end

always_ff @(posedge clk or negedge rst) begin
    if (!rst) curr_state = IDLE;
    else curr_state = next_state;
end

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
    end
    else begin
        case (curr_state)
            IDLE: begin
                if (r_data_received == 2'b01 && r_address <= 3'b111) next_state = RECEIVE;
                else next_state = IDLE;
            end

            RECEIVE: begin
                next_state = WRITE;
            end

            WRITE: begin
                next_state = ADDR_INCR;
            end

            ADDR_INCR: begin
                next_state = IDLE;
            end
        endcase
    end
end

always_ff @(posedge clk) begin 
    if (!rst) begin
        r_instruction <= 32'b0;
        r_write_enable <= 1'b0;
        r_address <= 3'b0;
    end
    else begin
        case (curr_state)
            IDLE: begin
                r_instruction <= 32'b0;
                r_write_enable <= 1'b0;
            end

            RECEIVE: begin
                r_instruction <= i_instruction;
                r_write_enable <= 1'b1;
            end

            WRITE: begin
            end

            ADDR_INCR: begin
                r_address <= r_address + 1'b1;
            end
        endcase
    end
end

assign o_instruction = r_instruction;
assign o_write_enable = r_write_enable;
assign o_address = r_address;
endmodule
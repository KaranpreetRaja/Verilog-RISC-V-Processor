module i_instructionDecoder(
    input  logic [31:0] i_instruction, // 32-bit i_instruction input
    input logic i_if_ready,
);

// ID LOGIC //

parameter IDLE_ID = 2'b00, 
          STORE = 2'b01;

reg [1:0] curr_if_state, next_if_state;

always @(posedge clk or negedge rst) begin
    if (!rst) curr_if_state <= IDLE_IF;
    else curr_if_state <= next_if_state;
end

always @(*) begin
    next_if_state = curr_if_state;
    case (curr_if_state)
        IDLE_IF_ID: begin
            if (r_fetch_ready == 1'b1) next_if_state = STORE; //limit to 8 later
        end

        STORE: begin
            if (i_flush == 1'b1) next_if_state = IDLE_IF_ID; //if ID in decoder module raises high signal
            // hold onto r_if_reg value til then
        end
    endcase
end

always @(posedge clk or negedge rst) begin 
    if (!rst) begin
        r_if_reg_occupied <= 1'b0;
        r_if_reg <= 32'b0;
    end else begin
        case (curr_if_state)
            IDLE_IF_ID: begin
                r_if_reg_occupied <= 1'b0;
            end
            STORE: begin //make flush a handshake signal
                r_if_reg_occupied <= 1'b1;
                r_if_reg <= r_if_next_val;
            end
        endcase
    end
end


endmodule

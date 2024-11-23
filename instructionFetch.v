module instructionFetch (
    input clk,
    input rst,
    input i_write_enable,
    input [2:0] i_load_address,
    input [31:0] i_load_instruction
);
// start with program memory

reg [31:0] memory [0:7];
reg [2:0] r_write_enable;
reg [2:0] r_load_address;
reg [31:0] r_load_instruction;

// PROGRAM MEMORY LOGIC //
parameter IDLE = 2'b00, 
          RECEIVE = 2'b01;

reg [1:0] curr_load_state, next_load_state;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        r_write_enable <= 2'b0;
    end
    else begin
        r_write_enable <= {r_write_enable[0], i_write_enable};
    end
end

always @(posedge clk or negedge rst) begin
    if (!rst) curr_load_state <= IDLE;
    else curr_load_state <= next_load_state;
end

always @(*) begin
    next_load_state = curr_load_state;
    case (curr_load_state)
        IDLE: begin
            if (r_write_enable == 2'b01) next_load_state = RECEIVE; //limit to 8 later
            else next_load_state = IDLE;
        end
        RECEIVE: begin
            next_load_state = IDLE;
        end
    endcase
end

always @(posedge clk or negedge rst) begin 
    if (!rst) begin
        r_load_address <= 3'b0;
        r_load_instruction <= 32'b0;
    end
    else begin
        case (curr_load_state)
            IDLE: begin
                // No memory write happens in IDLE state
            end

            RECEIVE: begin
                // First, latch the input values
                memory[i_load_address] <= i_load_instruction;
            end
        endcase
    end
end

// Perform the memory write in a separate always block

// PROGRAM COUNTER LOGIC //

// INSTRUCTION FETCH LOGIC //

// IF/ID LOGIC //

endmodule
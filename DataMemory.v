module DataMemory #(parameter SIZE = 16) (
    input clk,
    input rst,
    input ex_mem_pipe_ready,
    input readEnable,
    input writeEnable,
    input [SIZE-1:0] address, // Default 64KB Bytes of memory
    input [31:0] writeData,
    output reg [31:0] readData,  
    output reg error,
    output reg mem_writeback_ready
);

reg [7:0] memory [SIZE-1:0];
reg [2:0] currentState, nextState;
reg [31:0] pipeBuffer_readData; // Pipelining output placeholder

// States
parameter IDLE = 3'b000,
            READ = 3'b001,
            WRITE = 3'b010,
            ERROR = 3'b100;

// State Updates
always @(posedge clk or posedge rst) begin
    if (rst) begin
        currentState <= IDLE;
    end else begin
        currentState <= nextState;
    end
end

// State Transition Logic
//Note Error state occurs when both read and write are enabled or address provided is not aligned to memory
always @(*) begin
    case (currentState)
    IDLE: begin
        if (readEnable && !writeEnable) nextState = READ;
        else if (!readEnable && writeEnable && (address[1:0] == 2'b00)) nextState = WRITE;
        else if ((readEnable && writeEnable) || (address[1:0] != 2'b00)) nextState = ERROR;
        else nextState = IDLE;
    end

    READ: begin
        if (readEnable && !writeEnable) nextState = READ;
        else if (!readEnable && writeEnable && (address[1:0] == 2'b00)) nextState = WRITE;
        else if ((readEnable && writeEnable) || (address[1:0] != 2'b00)) nextState = ERROR;
        else nextState = IDLE;
    end

    WRITE: begin
        if (readEnable && !writeEnable) nextState = READ;
        else if (!readEnable && writeEnable && (address[1:0] == 2'b00)) nextState = WRITE;
        else if ((readEnable && writeEnable) || (address[1:0] != 2'b00)) nextState = ERROR;
        else nextState = IDLE;
    end

    ERROR: begin
        if (readEnable && !writeEnable) nextState = READ;
        else if (!readEnable && writeEnable && (address[1:0] == 2'b00)) nextState = WRITE;
        else nextState = ERROR;
    end

    default: nextState = IDLE;
    endcase
end

// State Execution 
always @(*) begin
    case (currentState)
    READ: begin
        error = 0;
        readData = {memory[address+3], memory[address+2], memory[address+1], memory[address]};
    end

    WRITE: begin
        error = 0;
        memory[address]   = writeData[7:0];
        memory[address+1] = writeData[15:8];
        memory[address+2] = writeData[23:16];
        memory[address+3] = writeData[31:24];
    end

    IDLE: begin
        error = 0;
    end

    ERROR: begin
        error = 1;
    end
    endcase
end

// Mem writeback ready (pipelining support for future)
always @(*) begin
    mem_writeback_ready = (currentState == WRITE);
end
endmodule

module DataMemroy #(parameter SIZE = 16);(
    input clk,
    input rst,
    input ex_mem_pipe_ready;
    input readEnable,
    input writeEnable,
    input [SIZE-1:0] address, // Default 64KB Bytes of memory
    input [31:0] writeData,
    output reg [31:0] readData,
    output error;
    output mem_writeback_ready;);

reg [7:0] memory [SIZE-1:0];
reg [2:0] currentState, nextState;
reg [31:0] pipeBuffer_readData; //Pipelining output before it hits read data?
reg [7:0] alligned_address; //

// States
parameter IDLE = 3'b000,
          READ = 3'b001,
          WRITE = 3'b010,
          PASS =  3'b011,
          ERROR = 3'b100;



//State Updates
always @(posedge clk, posedge rst) begin
    if(rst) begin
        currentState <= IDLE;
    end
    else begin
        currentState <= nextState;
     end
end


//Case Transition Logic
//Note Error state occurs when both read and write are enabled or address provided is not aligned to memory
always @(*) begin 
    case(currentState)
    IDLE: begin 
        if(readEnable == 1 & writeEnable == 0) begin 
            nextState = READ;
        end
        else if(readEnable == 0 & writeEnable == 1 & address[1:0] == 2'b00) begin 
            nextState = WRITE;
        end
        else if((readEnable == 1 & writeEnable == 1) | address[1:0] != 2'b00) begin 
            nextState = ERROR;
        end
        else if(readEnable == 0 & writeEnable == 0) begin 
            nextState = IDLE;
        end
    end

    READ: begin 
        if(readEnable == 1 & writeEnable == 0) begin 
            nextState = READ;
        end
        else if(readEnable == 0 & writeEnable == 1 & address[1:0] == 2'b00) begin 
            nextState = WRITE;
        end
        else if((readEnable == 1 & writeEnable == 1) | address[1:0] != 2'b00) begin 
            nextState = ERROR;
        end
        else if(readEnable == 0 & writeEnable == 0) begin 
            nextState = IDLE;
        end
    end

    WRITE: begin 
        if(readEnable == 1 & writeEnable == 0) begin 
            nextState = READ;
        end
        else if(readEnable == 0 & writeEnable == 1  & address[1:0] == 2'b00) begin 
            nextState = WRITE;
        end
        else if((readEnable == 1 & writeEnable == 1) | address[1:0] != 2'b00) begin 
            nextState = ERROR;
        end
        else if(readEnable == 0 & writeEnable == 0) begin 
            nextState = IDLE;
        end
    end

    ERROR: begin 
        if(readEnable == 1 & writeEnable == 0) begin 
            nextState = READ;
        end
        else if(readEnable == 0 & writeEnable == 1  & address[1:0] == 2'b00) begin 
            nextState = WRITE;
        end
        else if((readEnable == 1 & writeEnable == 1) | address[1:0] != 2'b00) begin 
            nextState = ERROR;
        end
        else if(readEnable == 0 & writeEnable == 0) begin 
            nextState = IDLE;
        end
    end    

    //Mostly Dummy with room to add more logic to pass into the pipe.
    PASS: begin 
        if(readEnable == 1 & writeEnable == 0) begin 
            nextState = READ;
        end
        else if(readEnable == 0 & writeEnable == 1  & address[1:0] == 2'b00) begin 
            nextState = WRITE;
        end
        else if((readEnable == 1 & writeEnable == 1) | address[1:0] != 2'b00) begin 
            nextState = ERROR;
        end
        else if(readEnable == 0 & writeEnable == 0) begin 
            nextState = IDLE;
        end
    end
    default: nextState = IDLE;
    endcase
end

//State execution
always @(*) begin 
    case(currentState) 

    //LSB storage method
    READ: begin 
        error =0;
        pipeBuffer_readData = {memory[address+3],memory[address+2],memory[address+1],memory[address]};
    end

    //LSB Write Method
    WRITE: begin 
        error =0;
        memory[address] = writeData[7:0];
        memory[address+1] = writeData[15:8];
        memory[address+2] = writeData[23:15];
        memory[address+3] = writeData[31:24];
    end
    IDLE: begin 
        error =0;
    end

    ERROR: error = 1;

    PASS: begin
        readData = pipeBuffer_readData;
    end
    endcase
end

endmodule
`timescale 1ns/1ns
`include "DataMemory.v"

module DataMemory_tb;

    // Inputs
    reg clk, rst, ex_mem_pipe_ready, readEnable, writeEnable;
    reg [15:0] address;
    reg [31:0] writeData;
    
    // Outputs
    wire [31:0] readData;
    wire error, mem_writeback_ready;

    // Instantiate the DataMemory module
    DataMemory dut (
        .clk(clk),
        .rst(rst),
        .ex_mem_pipe_ready(ex_mem_pipe_ready),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .address(address),
        .writeData(writeData),
        .readData(readData),
        .error(error),
        .mem_writeback_ready(mem_writeback_ready)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5ns (100MHz clock)
    end

    // Initial block for setting up the test
    initial begin
        // Initialize all signals
        clk = 0;
        rst = 0;
        ex_mem_pipe_ready = 0;
        readEnable = 0;
        writeEnable = 0;
        address = 16'b0;
        writeData = 32'b0;
        
        // Apply reset
        rst = 1;
        #10;
        rst = 0;

        // Test Write Operation
        // Write value 32'hDEADBEEF to address 16'h0004
        #10;
        writeEnable = 1;
        address = 16'h0004;
        writeData = 32'hDEADBEEF;
        #10;
        writeEnable = 0;

        // Test Read Operation
        // Read from address 16'h0004
        #10;
        readEnable = 1;
        address = 16'h0004;
        #10;
        readEnable = 0;

        // Test Misaligned Write (should go to ERROR state)
        // Attempt to write to a non-aligned address (16'h0005)
        #10;
        writeEnable = 1;
        address = 16'h0005;
        writeData = 32'h12345678;
        #10;
        writeEnable = 0;

        // Test Read after misaligned write (expect error state)
        #10;
        readEnable = 1;
        address = 16'h0005;
        #10;
        readEnable = 0;

        // Test both Read and Write enabled at the same time (should go to ERROR state)
        #10;
        readEnable = 1;
        writeEnable = 1;
        address = 16'h0004;
        writeData = 32'h87654321;
        #10;
        readEnable = 0;
        writeEnable = 0;

        // Finish simulation
        #10;
        $finish;
    end

    // Monitor the output signals
    initial begin
        $monitor("At time %t: address=%h, writeData=%h, readData=%h, error=%b, mem_writeback_ready=%b",
                 $time, address, writeData, readData, error, mem_writeback_ready);
    end

endmodule

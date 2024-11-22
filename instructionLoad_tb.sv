`timescale 1ns / 1ns 

module instructionLoad_tb;

    // DUT Inputs
    logic clk;
    logic rst;
    logic [31:0] r_instruction;
    logic r_data_sent;

    // DUT Outputs
    logic o_write_enable;
    logic [3:0] o_address;
    logic [31:0] o_instruction;

    // Instantiate the DUT
    instructionLoad il1 (
        .clk(clk),
        .rst(rst),
        .i_data_received(r_data_sent),
        .i_instruction(r_instruction),
        .o_write_enable(o_write_enable),
        .o_address(o_address),
        .o_instruction(o_instruction)
    );

    // Generate clock signal
    always begin
        #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    // Testbench logic
    initial begin
        // Initialize signals

        // Assert reset for the first few cycles
        rst = 1'b0;  
        clk = 0;
        r_instruction = 32'b0;
        r_data_sent = 1'b0;
        
        #15;         // Hold reset high for 15ns
        rst = 1'b1;  // Deassert reset

        // Test sequence
        #10;
        r_instruction = 32'd5;
        r_data_sent = 1'b1;

        #20;
        r_data_sent = 1'b0;

        #50;
        $finish;  // End simulation
    end

endmodule
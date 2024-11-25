`timescale 1ns / 1ns

module instructionLoad_tb;

    // DUT Inputs
    reg clk;
    reg rst;
    reg [31:0] r_instruction;
    reg [2:0] r_load_address;
    reg r_data_sent;
    reg [31:0] r_load_instruction;

    // DUT Outputs
    wire o_write_enable;
    wire i_write_enable;
    wire [3:0] o_address;
    wire [31:0] o_instruction;
    wire o_flush;
    wire [31:0] fetch_instruction;
    wire o_data_ready;
    reg i_flush;

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

    instructionFetch if1(
        .clk(clk),
        .rst(rst),
        .i_write_enable(o_write_enable),
        .i_load_address(o_address),
        .i_load_instruction(o_instruction),
        .i_flush(o_flush),
        .o_instruction(fetch_instruction),
        .o_data_ready(o_data_ready)
    );

    instructionDecoder id1(
        .clk(clk),
        .rst(rst),
        .i_instruction(fetch_instruction), // 32-bit i_instruction input
        .i_if_ready(o_data_ready),
        .i_flush(i_flush),
        .o_flush(o_flush)
    );

    // Generate clock signal
    always begin
        #5 clk = ~clk;  // Toggle clock every 5 time units
    end

    // TEST INSTRUCTION LOAD
    initial begin
        // Initialize signals
        rst = 1'b0;  
        clk = 0;
        r_instruction = 32'b0;
        r_data_sent = 1'b0;
        
        #10;         // Hold reset high for 15ns
        rst = 1'b1;  // Deassert reset

        // Test sequence
        #10;
        r_instruction = 32'b0000000_00010_00001_000_00100_0110011; //yes

        r_data_sent = 1'b1;

        #10;
        r_data_sent = 1'b0;

        #100;
        r_instruction = 32'b000000000100_00001_010_00100_0000011;
        r_data_sent = 1'b1;

        #10;
        r_data_sent = 1'b0;


        #100;
        r_instruction = 32'd105;
        r_data_sent = 1'b1;

        #10;
        r_data_sent = 1'b0;

        #100;
        r_instruction = 32'd655;
        r_data_sent = 1'b1;


        #10;
        r_data_sent = 1'b0;


        #100;
        r_instruction = 32'd783;
        r_data_sent = 1'b1;

        #10;
        r_data_sent = 1'b0;

        #100;
        r_instruction = 32'd897;
        r_data_sent = 1'b1;
        id1.r_decode_fin = 1'b1;
        i_flush = 1'b1;

        #1;
        id1.r_decode_fin = 1'b0;

        #10;
        r_data_sent = 1'b0;
        i_flush = 1'b0;

        #1000;
        $finish;  // End simulation
    end

    initial begin
        // Initialize signals

    end


endmodule

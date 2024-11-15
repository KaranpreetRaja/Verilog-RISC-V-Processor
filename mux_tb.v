module mux_tb;
    parameter SIZE = 4; // Example size for testing
    reg [SIZE-1:0] dataA;
    reg [SIZE-1:0] dataB;
    reg select;
    wire [SIZE-1:0] muxOut;

    // Instantiate the mux module
    mux #(SIZE) uut (
        .muxOut(muxOut),
        .dataA(dataA),
        .dataB(dataB),
        .select(select)
    );

    initial begin
        // Test case 1: select = 0, dataA = 4'b1010, dataB = 4'b0101
        dataA = 4'b1010;
        dataB = 4'b0101;
        select = 0;
        #10;
        $display("Select = %b, dataA = %b, dataB = %b, muxOut = %b", select, dataA, dataB, muxOut);

        // Test case 2: select = 1, dataA = 4'b1010, dataB = 4'b0101
        select = 1;
        #10;
        $display("Select = %b, dataA = %b, dataB = %b, muxOut = %b", select, dataA, dataB, muxOut);

        // Test case 3: select = 0, dataA = 4'b1111, dataB = 4'b0000
        dataA = 4'b1111;
        dataB = 4'b0000;
        select = 0;
        #10;
        $display("Select = %b, dataA = %b, dataB = %b, muxOut = %b", select, dataA, dataB, muxOut);

        // Test case 4: select = 1, dataA = 4'b1111, dataB = 4'b0000
        select = 1;
        #10;
        $display("Select = %b, dataA = %b, dataB = %b, muxOut = %b", select, dataA, dataB, muxOut);

        // Test case 5: select = 0, dataA = 4'b0011, dataB = 4'b1100
        dataA = 4'b0011;
        dataB = 4'b1100;
        select = 0;
        #10;
        $display("Select = %b, dataA = %b, dataB = %b, muxOut = %b", select, dataA, dataB, muxOut);

        // Test case 6: select = 1, dataA = 4'b0011, dataB = 4'b1100
        select = 1;
        #10;
        $display("Select = %b, dataA = %b, dataB = %b, muxOut = %b", select, dataA, dataB, muxOut);

        $finish;
    end
endmodule
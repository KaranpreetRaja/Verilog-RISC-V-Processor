module mux #(parameter SIZE = 1) (
    output [SIZE-1:0] muxOut, 
    input [SIZE-1:0] dataA, 
    dataB, 
    input select
    );

    wire [SIZE-1:0] notSelect, upperPath, lowerPath;
    
    assign notSelect = ~{SIZE{select}};
    assign upperPath = dataA & notSelect;
    assign lowerPath = dataB & {SIZE{select}};
    assign muxOut = upperPath | lowerPath;
endmodule
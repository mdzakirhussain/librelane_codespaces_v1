// 8:1 multiplexer
//   I : 8 data inputs   (placed on the WEST edge)
//   S : 3 select lines  (placed on the SOUTH edge)
//   Y : 1 data output   (placed on the EAST edge)

module mux8x1 (
    input  wire [7:0] I,
    input  wire [2:0] S,
    output wire       Y
);

    assign Y = I[S];

endmodule

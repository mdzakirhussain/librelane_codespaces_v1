// 32-bit up/down counter with parallel load
//
// Spec:
//   * 32-bit, counts up or down
//   * parallel load capability
//   * positive edge triggered clock
//   * active-high SYNCHRONOUS reset
//
// Pin placement (see pin_order.cfg):
//   clk, rst                  -> WEST edge
//   up, down, load            -> SOUTH edge
//   count[31:0]               -> EAST edge
//   data_in[31:0]             -> NORTH edge
//
// Priority of operations, highest first:
//   rst  -> load -> up -> down -> hold

module counter32 (
    input  wire        clk,
    input  wire        rst,       // active high, synchronous
    input  wire        up,
    input  wire        down,
    input  wire        load,
    input  wire [31:0] data_in,   // parallel load value
    output reg  [31:0] count
);

    always @(posedge clk) begin
        if (rst)
            count <= 32'h0000_0000;
        else if (load)
            count <= data_in;
        else if (up)
            count <= count + 32'h0000_0001;
        else if (down)
            count <= count - 32'h0000_0001;
        else
            count <= count;
    end

endmodule

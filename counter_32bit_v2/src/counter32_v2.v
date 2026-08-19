// 32-bit up/down counter with parallel load - single direction control
//
// Spec:
//   * 32-bit, counts up or down
//   * ONE direction port: up_down = 1 -> count up, up_down = 0 -> count down
//   * count enable: en = 0 holds the current value
//   * parallel load capability
//   * positive edge triggered clock
//   * active-high SYNCHRONOUS reset
//
// Pin placement (see pin_order.cfg):
//   clk, rst                  -> WEST edge
//   up_down, load, en         -> SOUTH edge
//   count[31:0]               -> EAST edge
//   data_in[31:0]             -> NORTH edge
//
// Complete behaviour - every input combination is defined, and there are no
// illegal encodings:
//
//   rst  load  en  up_down | action
//   -----------------------+------------------
//    1    -    -     -     | count <= 0
//    0    1    -     -     | count <= data_in
//    0    0    0     -     | hold
//    0    0    1     1     | count <= count + 1
//    0    0    1     0     | count <= count - 1
//
// The single up_down port replaces the earlier {up, down} pair. That pair had
// four encodings for three states, one of which (up=1, down=1) was illegal and
// had to be resolved by an arbitrary priority. The separate `en` input carries
// the hold state that {up, down} used to encode as 0,0.

module counter32_v2 (
    input  wire        clk,
    input  wire        rst,       // active high, synchronous
    input  wire        up_down,   // 1 = up, 0 = down
    input  wire        en,        // 1 = count, 0 = hold
    input  wire        load,
    input  wire [31:0] data_in,   // parallel load value
    output reg  [31:0] count
);

    always @(posedge clk) begin
        if (rst)
            count <= 32'h0000_0000;
        else if (load)
            count <= data_in;
        else if (en)
            count <= up_down ? (count + 32'h0000_0001)
                             : (count - 32'h0000_0001);
        else
            count <= count;
    end

endmodule

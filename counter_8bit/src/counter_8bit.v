// 8-bit up/down counter with parallel load
//
// Spec:
//   * 8-bit, counts up or down under a single control: up_down
//         up_down = 1 -> count up
//         up_down = 0 -> count down
//   * parallel load under a single control: parallel_load
//   * 8-bit vectored load input, 8-bit vectored count output
//   * positive edge triggered clock
//   * active-high SYNCHRONOUS reset
//
// Pin placement (see pin_order.cfg):
//   clk, rst, load[7:0]       -> WEST edge
//   up_down, parallel_load    -> SOUTH edge
//   count[7:0]                -> EAST edge
//
// Behaviour - every input combination is defined:
//
//   rst  parallel_load  up_down | action
//   ---------------------------+---------------------
//    1        -            -    | count <= 0
//    0        1            -    | count <= load
//    0        0            1    | count <= count + 1
//    0        0            0    | count <= count - 1
//
// There is no hold state: with a single up_down control and no count enable,
// every clock edge that is not a reset or a load moves the count by one.

module counter_8bit (
    input  wire       clk,
    input  wire       rst,            // active high, synchronous
    input  wire       up_down,        // 1 = up, 0 = down
    input  wire       parallel_load,  // 1 = load
    input  wire [7:0] load,           // parallel load value
    output reg  [7:0] count
);

    always @(posedge clk) begin
        if (rst)
            count <= 8'h00;
        else if (parallel_load)
            count <= load;
        else if (up_down)
            count <= count + 8'h01;
        else
            count <= count - 8'h01;
    end

endmodule

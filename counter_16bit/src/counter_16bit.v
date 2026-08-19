// 16-bit up/down counter with parallel load
//
// Inputs:
//   up_down        1 = count up, 0 = count down
//   parallel_load  1 = load the value on `load`
//   load[15:0]     parallel load value
//   clk            positive edge triggered
//   rst            active high, SYNCHRONOUS reset
//
// Outputs:
//   count[15:0]    counter value
//
// Pin placement (see pin_order.cfg):
//   clk, rst, load[15:0]      -> WEST edge
//   up_down, parallel_load    -> SOUTH edge
//   count[15:0]               -> EAST edge
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

module counter_16bit (
    input  wire        clk,
    input  wire        rst,            // active high, synchronous
    input  wire        up_down,        // 1 = up, 0 = down
    input  wire        parallel_load,  // 1 = load
    input  wire [15:0] load,           // parallel load value
    output reg  [15:0] count
);

    always @(posedge clk) begin
        if (rst)
            count <= 16'h0000;
        else if (parallel_load)
            count <= load;
        else if (up_down)
            count <= count + 16'h0001;
        else
            count <= count - 16'h0001;
    end

endmodule

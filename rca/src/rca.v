// 4-bit ripple carry adder (structural)
//
// Pin placement (see pin_order.cfg):
//   A[3:0], B[3:0]      -> WEST edge
//   Sum[3:0], Cout      -> EAST edge
//
// There is no external carry-in port: the least significant full adder
// takes a hard 0, so the port list matches the requested pin plan exactly.

module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule


module rca (
    input  wire [3:0] A,
    input  wire [3:0] B,
    output wire [3:0] Sum,
    output wire       Cout
);

    wire [3:0] carry;

    full_adder fa0 (.a(A[0]), .b(B[0]), .cin(1'b0),     .sum(Sum[0]), .cout(carry[0]));
    full_adder fa1 (.a(A[1]), .b(B[1]), .cin(carry[0]), .sum(Sum[1]), .cout(carry[1]));
    full_adder fa2 (.a(A[2]), .b(B[2]), .cin(carry[1]), .sum(Sum[2]), .cout(carry[2]));
    full_adder fa3 (.a(A[3]), .b(B[3]), .cin(carry[2]), .sum(Sum[3]), .cout(carry[3]));

    assign Cout = carry[3];

endmodule

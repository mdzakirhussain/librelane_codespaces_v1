// 4-bit carry look-ahead adder
//
// Pin placement (see pin_order.cfg):
//   A[3:0], B[3:0]      -> WEST edge
//   Sum[3:0], Cout      -> EAST edge
//
// True carry look-ahead: the carry into every bit is formed directly from the
// generate/propagate terms of all lower bits, so no carry ripples through the
// adder chain. There is no external carry-in port, so the port list matches
// the requested pin plan exactly; C[0] is a hard 0.

module cla (
    input  wire [3:0] A,
    input  wire [3:0] B,
    output wire [3:0] Sum,
    output wire       Cout
);

    wire [3:0] G;   // generate  : G[i] = A[i] . B[i]
    wire [3:0] P;   // propagate : P[i] = A[i] ^ B[i]
    wire [4:0] C;   // carries   : C[0] is the carry-in, C[4] the carry-out

    assign G = A & B;
    assign P = A ^ B;

    assign C[0] = 1'b0;

    // Expanded look-ahead equations - each carry depends only on G, P and C[0]
    assign C[1] = G[0]
                | (P[0] & C[0]);

    assign C[2] = G[1]
                | (P[1] & G[0])
                | (P[1] & P[0] & C[0]);

    assign C[3] = G[2]
                | (P[2] & G[1])
                | (P[2] & P[1] & G[0])
                | (P[2] & P[1] & P[0] & C[0]);

    assign C[4] = G[3]
                | (P[3] & G[2])
                | (P[3] & P[2] & G[1])
                | (P[3] & P[2] & P[1] & G[0])
                | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign Sum  = P ^ C[3:0];
    assign Cout = C[4];

endmodule

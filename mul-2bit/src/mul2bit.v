// 2-bit array multiplier
//
//   op1[1:0], op2[1:0]  -> WEST edge
//   prodct[3:0]         -> EAST edge
//
// Four partial products are formed and summed with a half-adder chain:
//   prodct = op1 * op2   (max 3 * 3 = 9, hence 4 bits)

module mul2bit (
    input  wire [1:0] op1,
    input  wire [1:0] op2,
    output wire [3:0] prodct
);

    wire pp0;   // op1[0] . op2[0]   weight 1
    wire pp1;   // op1[1] . op2[0]   weight 2
    wire pp2;   // op1[0] . op2[1]   weight 2
    wire pp3;   // op1[1] . op2[1]   weight 4

    wire carry1;

    assign pp0 = op1[0] & op2[0];
    assign pp1 = op1[1] & op2[0];
    assign pp2 = op1[0] & op2[1];
    assign pp3 = op1[1] & op2[1];

    assign prodct[0] = pp0;

    // weight-2 column: half adder of the two partial products
    assign prodct[1] = pp1 ^ pp2;
    assign carry1    = pp1 & pp2;

    // weight-4 column: half adder of pp3 and the carry out of the column below
    assign prodct[2] = pp3 ^ carry1;
    assign prodct[3] = pp3 & carry1;

endmodule

module mux4x1 (
    input  wire I0,
    input  wire I1,
    input  wire I2,
    input  wire I3,
    input  wire S0,
    input  wire S1,
    output wire Y
);

    assign Y = S1 ? (S0 ? I3 : I2) :
                     (S0 ? I1 : I0);

endmodule

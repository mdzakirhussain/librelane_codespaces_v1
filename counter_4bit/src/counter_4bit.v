module counter_4bit (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       load,
    input  wire       up_down, // 1: up, 0: down
    input  wire [3:0] d,
    output reg  [3:0] q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 4'b0000;
        end else if (load) begin
            q <= d;
        end else if (up_down) begin
            q <= q + 1'b1;
        end else begin
            q <= q - 1'b1;
        end
    end

endmodule

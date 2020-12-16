module freq_div
(
	input wire[1:1] clk_in,
	output reg[1:1] clk_out
);

parameter DIV_BITS = 64;
parameter DIVIDER = 50000000;

reg [0:DIV_BITS-1] cnt = { DIV_BITS{1'b0} };

always @(posedge clk_in)
begin
	cnt = cnt + { {DIV_BITS - 1{1'b0}}, 1'b1 };
	if (cnt == DIVIDER / 2) begin
		clk_out <= !clk_out;
		cnt <= 0;
	end
end
endmodule

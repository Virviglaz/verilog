module freq_divider
(
	input clk_in,
	output reg clk_out
);

parameter DIV_BITS = 64;
parameter DIVIDER	= 50000000;

reg [0:DIV_BITS-1] cnt = 0;
reg clk_out_state = 0;


always @(posedge clk_in)
begin
	cnt = cnt + { {DIV_BITS-1{1'b0}}, 1'b1 };
	if (cnt == DIVIDER / 2) begin
		clk_out_state = !clk_out_state;
		clk_out = clk_out_state;
		cnt = 0;
	end
end
endmodule
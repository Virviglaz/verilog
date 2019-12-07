module pwm #(
	parameter DATA_W = 8,
	parameter PERIOD = 1000,
	parameter FREQ_DIV_BITS = 10,
	parameter FREQ_DIV = 500
)
(
	input wire clk,
	input wire en,
	input wire[DATA_W-1:0] duty,
	output reg pwm
);

	reg[1:0] sckr;
	reg[FREQ_DIV_BITS-1:0] freq_cnt = {FREQ_DIV_BITS{1'b0}};
	reg[DATA_W-1:0] cnt = {DATA_W{1'b0}};


	always @(posedge clk) begin
		freq_cnt <= freq_cnt + { {DATA_W-1{1'b0}}, 1'b1 };

		if (freq_cnt == {FREQ_DIV_BITS{1'b0}}) begin
			cnt <= cnt + { {DATA_W-1{1'b0}}, 1'b1 };

			if (cnt == PERIOD) begin
				cnt <= {DATA_W{1'b0}};
				pwm <= 1'b0;
			end

			if (cnt == duty)
				pwm <= 1'b1;
		end
	end
endmodule

module up_counter
(
	input clk, reset,
	output reg [BITS-1:0] counter,
	output reg dig
);

parameter BITS = 32;
parameter MAX = 10;

reg [BITS-1:0] maxvalue = MAX - 1;

always @(posedge clk or posedge reset)
begin
	if (reset)
		begin
			counter <= 0;
			dig <= 1'b0;
		end
	else
		begin
			counter <= counter +  { {BITS-1{1'b0}}, 1'b1 };
			dig <= (counter == maxvalue) ? 1'b1 : 1'b0;
		end
end
endmodule
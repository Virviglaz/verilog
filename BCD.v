module BCD(
	input [BITS-1:0] value,
	output reg [3:0] bcd_1000,
	output reg [3:0] bcd_100,
	output reg [3:0] bcd_10,
	output reg [3:0] bcd_1
	);

integer i;
parameter BITS = 12;

always @(value)
begin
	bcd_1000	= 4'd0;
	bcd_100	= 4'd0;
	bcd_10	= 4'd0;
	bcd_1		= 4'd0;

	for (i = BITS-1; i >= 0; i = i - 1)
	begin
		if (bcd_1000 >= 5)
			bcd_1000 = bcd_100 + 3;
		if (bcd_100 >= 5)
			bcd_100 = bcd_100 + 3;
		if (bcd_10 >= 5)
			bcd_10 = bcd_10 + 3;
		if (bcd_1 >= 5)
			bcd_1 = bcd_1 + 3;

		bcd_1000 = bcd_1000 << 1;
		bcd_1000[0] = bcd_100[3];

		bcd_100 = bcd_100 << 1;
		bcd_100[0] = bcd_10[3];

		bcd_10 = bcd_10 << 1;
		bcd_10[0] = bcd_1[3];

		bcd_1 = bcd_1 << 1;
		bcd_1[0] = value[i];
	end
end
endmodule
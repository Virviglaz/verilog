module bcd_decoder_4dig
(
	input clk,
	input [0:3] bcd0, bcd1, bcd2, bcd3,
	output reg [0:6] segments,
	output reg [0:3] ndig_en
);

parameter DIV_BITS = 8;

reg [0:DIV_BITS-1] dig_cnt = 0;
reg [0:4] dig_code;
reg [0:3] dig_num = 4'b0001;
reg [0:3] bcd;

always @(posedge clk)
begin
	dig_cnt = dig_cnt + { {DIV_BITS-1{1'b0}}, 1'b1 };
	if (dig_cnt == {DIV_BITS{1'b0}}) begin
		dig_num = dig_num << 1;
		if (dig_num == 4'b0000)
			dig_num = 4'b0001;
		ndig_en = ~dig_num;

		case(dig_num)
			4'b0001: bcd = bcd0;
			4'b0010: bcd = bcd1;
			4'b0100: bcd = bcd2;
			4'b1000: bcd = bcd3;
		endcase

		case(bcd)
			4'b0000: segments = 7'b0000001; // "0"
			4'b0001: segments = 7'b1001111; // "1"
			4'b0010: segments = 7'b0010010; // "2"
			4'b0011: segments = 7'b0000110; // "3"
			4'b0100: segments = 7'b1001100; // "4"
			4'b0101: segments = 7'b0100100; // "5"
			4'b0110: segments = 7'b0100000; // "6"
			4'b0111: segments = 7'b0001111; // "7"
			4'b1000: segments = 7'b0000000; // "8"
			4'b1001: segments = 7'b0000100; // "9"			
			4'b1010: segments = 7'b0001000; // "A"
			4'b1011: segments = 7'b1100000; // "b"
			4'b1100: segments = 7'b0110001; // "C"
			4'b1101: segments = 7'b1000010; // "d"
			4'b1110: segments = 7'b0110000; // "E"
			4'b1111: segments = 7'b0111000; // "F"
		endcase			
	end
end
endmodule
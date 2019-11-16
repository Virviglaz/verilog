module bcd_decoder
(
	input clk,
	input [0:3] bcd,
	output reg [0:6] segments
);

always @(posedge clk)
begin
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
		default: segments = 7'b0000000; // "0"
	endcase
end
endmodule
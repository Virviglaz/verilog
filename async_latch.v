`timescale 1ns / 1ps

module async_latch #(
	parameter BITS = 8
)
(
	input wire en,
	input wire oe,
	output wire[BITS-1:0] q,
	input wire[BITS-1:0] d
);

reg[BITS-1:0] latch;
assign q = oe ? latch : {BITS{1'bz}};

always @(posedge en) begin
	latch <= d;
end

endmodule

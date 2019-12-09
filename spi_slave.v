`timescale 1ns / 1ps

module SPI_slave #(
	parameter BITS = 8
)
(
	input wire clk,
	input wire sck,
	input wire mosi,
	output wire miso,
	input wire csn,
	output reg[BITS-1:0] data_from_master,
	input wire[BITS-1:0] data_from_slave,
	output reg ready
);

	reg[1:0] sck_change;
	reg[1:0] csn_change;

	reg[BITS-1:0] buffer;

	always @(posedge clk) begin
		sck_change <= csn ? 2'b00 : { sck_change[0], sck };
		csn_change <= { csn_change[0], csn };
	end

	/* MOSI valid at sck rising (SPI_MODE0) */
	wire sck_risingEdge = (sck_change == 2'b01);
	/* MISO set at sck falling (SPI_MODE0) */
	wire sck_fallingEdge = (sck_change == 2'b10);

	wire chip_enabled = (csn_change == 2'b10);
	wire chip_disabled = (csn_change == 2'b01);

	assign miso = csn ? 1'bz : buffer[BITS-1];

	always @(posedge clk) begin
		if (chip_enabled) begin
			buffer <= data_from_slave;
			ready <= 1'b0;
		end

		if (chip_disabled) begin
			data_from_master <= buffer;
			ready <= 1'b1;
		end

		if (~csn && sck_risingEdge)
			buffer <= { buffer[BITS-2:0], mosi };
	end
endmodule

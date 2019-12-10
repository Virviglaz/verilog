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
	output wire rx_fifo_ready,
	output wire tx_fifo_ready
);

	reg[1:0] sck_change;
	reg[1:0] csn_change;
	reg[1:0] rdy_change;

	reg[BITS-1:0] buffer;
	reg[2:0] bitcnt;
	wire byte_ready;

	always @(posedge clk) begin
		sck_change <= csn ? 2'b00 : { sck_change[0], sck };
		csn_change <= { csn_change[0], csn };
		rdy_change <= { rdy_change[0], byte_ready };
	end

	/* MOSI valid at sck rising (SPI_MODE0) */
	wire sck_risingEdge = (sck_change == 2'b01);
	/* MISO set at sck falling (SPI_MODE0) */
	wire sck_fallingEdge = (sck_change == 2'b10);

	wire chip_enabled = (csn_change == 2'b10);
	wire chip_disabled = (csn_change == 2'b01);
	assign rx_fifo_ready = (rdy_change == 2'b10);

	assign miso = csn ? 1'bz : buffer[BITS-1];
	assign byte_ready = (bitcnt == 3'b111 && sck_fallingEdge) ? 1'b1 : 1'b0;
	assign tx_fifo_ready = (bitcnt == 3'b111 && sck_risingEdge) ? 1'b1 : 1'b0;

	always @(posedge clk) begin
		if (chip_enabled) begin
			buffer <= data_from_slave;
			bitcnt <= 3'b000;
		end

		if (~csn && sck_risingEdge)
			buffer <= { buffer[BITS-2:0], mosi };

		if (~csn && sck_fallingEdge)
			bitcnt <= bitcnt + 1'b1;

		if (byte_ready)
			data_from_master <= buffer;
	end
endmodule

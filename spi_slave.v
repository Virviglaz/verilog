`timescale 1ns / 1ps

module SPI_slave
(
	input wire clk,
	input wire sck,
	input wire mosi,
	output wire miso,
	input wire ssel,
	output reg byteReceived = 1'b0,
	output reg[15:0] receivedData = {16{1'b0}},
	output wire dataNeeded,
	input wire[15:0] dataToSend
);

	reg[15:0] receivedDataLatch;
	reg[1:0] sckr;
	reg[1:0] mosir;
	reg[3:0] bitcnt;
	reg[15:0] dataToSendBuffer;
	wire ssel_active = ~ssel;

	always @(posedge clk) begin
	if(~ssel_active)
		sckr <= 2'b00;
	else
		sckr <= { sckr[0], sck };
	end
	wire sck_risingEdge = (sckr == 2'b01);
	wire sck_fallingEdge = (sckr == 2'b10);
		
	always @(posedge clk) begin
		if(~ssel_active)
			mosir <= 2'b00;
		else
			mosir <= { mosir[0], mosi };
	end
	wire mosi_data = mosir[1];
	
	always @(posedge clk) begin
		if(~ssel_active) begin
			bitcnt <= {4{1'b0}};
			receivedDataLatch <= {16{1'b0}};
		end
		else
			receivedData <= receivedDataLatch;
		if(sck_risingEdge && ssel_active) begin
			bitcnt <= bitcnt + { {15{1'b0}}, 1'b1 };
			receivedDataLatch <= { receivedDataLatch[14:0], mosi_data };
		end
	end
	
	always @(posedge clk)
		byteReceived <= ssel_active && sck_risingEdge && (bitcnt == {16{1'b1}});

	always @(posedge clk) begin
		if(~ssel_active)
			dataToSendBuffer <= {16{1'b0}};
		else if(bitcnt == {4{1'b0}})
			dataToSendBuffer <= dataToSend;
		else if(sck_fallingEdge)
			dataToSendBuffer <= { dataToSendBuffer[14:0], 1'b0};
	end
	
	assign dataNeeded = ssel_active && (bitcnt == {4{1'b0}});
	assign miso = dataToSendBuffer[15];
endmodule

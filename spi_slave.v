`timescale 1ns / 1ps

module SPI_slave(clk, sck, mosi, miso, ssel, byteReceived, receivedData, dataNeeded, dataToSend);
	parameter BITS = 8;
	parameter BIT_CNT = 3;

	input wire clk;
	input wire sck;
	input wire mosi;
	output wire miso;
	input wire ssel;
	output reg byteReceived = 1'b0;
	output reg[BITS-1:0] receivedData = {BITS{1'b0}};
	output wire dataNeeded;
	input wire[BITS-1:0] dataToSend;

	reg[BITS-1:0] receivedDataLatch;
	reg[1:0] sckr;
	reg[1:0] mosir;
	reg[BIT_CNT-1:0] bitcnt;
	reg[BITS-1:0] dataToSendBuffer;
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
		bitcnt <= {BIT_CNT{1'b0}};
		receivedDataLatch <= {BITS{1'b0}};
	end
	else if(sck_risingEdge) begin
		bitcnt <= bitcnt + { {BIT_CNT-1{1'b0}}, 1'b1 };
		receivedDataLatch <= { receivedDataLatch[BITS-2:0], mosi_data };
	end
	else
		receivedData <= receivedDataLatch;
	end
	
	always @(posedge clk)
	byteReceived <= ssel_active && sck_risingEdge && (bitcnt == {BITS{1'b1}});

	always @(posedge clk) begin
	if(~ssel_active)
		dataToSendBuffer <= {BITS{1'b0}};
	else if(bitcnt == {BIT_CNT{1'b0}})
		dataToSendBuffer <= dataToSend;
	else if(sck_fallingEdge)
		dataToSendBuffer <= { dataToSendBuffer[BITS-2:0], 1'b0};
	end
	
	assign dataNeeded = ssel_active && (bitcnt == {BIT_CNT{1'b0}});
	assign miso = dataToSendBuffer[BITS-1];
endmodule

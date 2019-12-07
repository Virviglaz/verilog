module cmd_mux #(
	parameter CMD_W = 4,
	parameter DATA_W = 12
)
(
	input wire clk,
	input wire[CMD_W+DATA_W-1:0] data_in,
	output reg[DATA_W-1:0] data_out,
	output reg[2**CMD_W-1:0] cmd
);

always @(posedge clk)
begin
	data_out <= data_in[DATA_W-1:0];
	cmd <= 1 << data_in[CMD_W+DATA_W-1:DATA_W];
end
endmodule
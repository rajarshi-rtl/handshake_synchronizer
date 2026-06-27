`timescale 1ns/1ps

module handshake_synchronizer_tb();

localparam DATA_WIDTH = 8;

reg src_clk, des_clk, rst, send;
reg [DATA_WIDTH-1:0] data_src;
wire [DATA_WIDTH-1:0] data_des;
wire busy;

handshake_synchronizer #(.DATA_WIDTH(DATA_WIDTH)) dut (
	.src_clk(src_clk), .des_clk(des_clk), .rst(rst), .send(send),
	.data_src(data_src), .data_des(data_des), .busy(busy)
);

initial {src_clk, des_clk, rst, send} = 4'b0000;

always #20 src_clk = ~src_clk;
always #10 des_clk = ~des_clk;

initial begin
	data_src = 8'b0;
	forever @(negedge src_clk) data_src++;
end

initial begin
	$dumpfile("wav_handshake_synchronizer.vcd");
	$dumpvars(0,handshake_synchronizer_tb);

	#20 rst = 1'b1;
	#20 send = 1;
	#1000 $finish;
end

endmodule

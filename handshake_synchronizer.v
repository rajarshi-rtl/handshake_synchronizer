`include "dual_flop_synchronizer.v"
`include "sender_fsm.v"
`include "reciever_fsm.v"

module handshake_synchronizer #(parameter DATA_WIDTH = 8) (
	input src_clk, des_clk, rst, send, 
	input [DATA_WIDTH-1:0] data_src,
	output reg [DATA_WIDTH-1:0] data_des,
	output busy
);

wire req_src, ack_src, src_ff_en;
wire req_des, ack_des, des_ff_en;

sender_fsm sender_domain(
	.src_clk(src_clk), .send(send), .ack(ack_src), .rst(rst),
	.req(req_src), .busy(busy), .load_src_reg_en(src_ff_en)
);

reciever_fsm destination_domain(
	.des_clk(des_clk), .req(req_des), .rst(rst),
	.des_ff_en(des_ff_en), .ack(ack_des)
);

dual_flop_synchronizer src_to_des (
	.clk(des_clk), .in(req_src), .rst(rst),
	.out(req_des)
);

dual_flop_synchronizer des_to_src(
	.clk(src_clk), .in(ack_des), .rst(rst),
	.out(ack_src)
);

reg [DATA_WIDTH-1:0] src_ff, des_ff_in;

// Capture Flip Flop
reg [DATA_WIDTH-1:0] capture_ff;

always @ (posedge src_clk or negedge rst) begin
	if (!rst) capture_ff <= 0;	
	else capture_ff <= (~busy && send) ? data_src : capture_ff;
end

// Source Flip Flop
always @ (posedge src_clk or negedge rst) begin
	if (!rst) des_ff_in <= 0;
	else des_ff_in <= (src_ff_en) ? capture_ff : des_ff_in;
end

// Destination Flip Flop
always @ (posedge des_clk or negedge rst) begin
	if (!rst) data_des <= 0;
	else data_des <= (des_ff_en) ? des_ff_in : data_des;
end

endmodule

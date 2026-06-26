`timescale 1ns/1ps

module tb_reciever_fsm();

reg des_clk, rst, req;
wire ack, des_ff_en;

reciever_fsm dut(
	.des_clk(des_clk), .rst(rst), .req(req),
	.ack(ack), .des_ff_en(des_ff_en)
);

initial {des_clk, rst, req} = 3'b000;

always #5 des_clk = ~des_clk;

initial begin
	$dumpfile("wav_reciever_fsm.v");
	$dumpvars(0,tb_reciever_fsm);
	$monitor("Time=%0t, PS=%b, REQ=%b, ACK=%b, EN=%b",$time,dut.present_state,req,ack,des_ff_en);
	#10 rst = 1'b1; req = 1'b1;
	#50 req = 1'b0;
	#20 $finish;
end

endmodule

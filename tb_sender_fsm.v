`timescale 1ns/1ps

module sender_fsm_tb();

reg clk, rst, send, ack;
wire req, busy, load_src_reg_en;

sender_fsm dut(.src_clk(clk), .send(send), .ack(ack), .rst(rst), 
	.req(req), .busy(busy), .load_src_reg_en(load_src_reg_en)	
);

initial {clk,rst,send,ack} = 4'b0000;

always #10 clk = ~clk;

initial begin
	$dumpfile("wav_sender_fsm.vcd");
	$dumpvars(0,sender_fsm_tb);
	$monitor("Time=%0t, PS=%b, REQ=%b, BUSY=%b, EN=%b",$time,dut.present_state,req,busy,load_src_reg_en);
	#30 rst = 1'b1; send = 1'b1;
	#50 ack = 1'b1;
	#50 ack = 1'b0;
	#150 $finish;
end

endmodule

module dual_flop_synchronizer(
	input clk, in, rst,
	output reg out
);

reg sync_ff;

always @ (posedge clk or negedge rst) begin
	if (!rst) begin
		{out,sync_ff} <= 2'b00;
	end
	else begin
		out <= sync_ff;
		sync_ff <= in;
	end
end

endmodule

// ------------------ SENDER STATE MACHINE ----------------- //

module sender_fsm(
	input src_clk, send, ack, rst,
	output reg req, busy, load_src_reg_en
);

// Encoding the states of the sender FSM
parameter idle = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;
reg [1:0] present_state, next_state;

// Present State Logic
always @ (posedge src_clk or negedge rst) begin
	if (!rst) begin
		next_state <= idle;
		{req,busy,load_src_reg_en} <= 3'b000;		
	end
	
	else begin
		present_state <= next_state;		
	end
end	

// Next State Logic
always @ (present_state or send or ack) begin
	case(present_state)
		idle: begin
			{req,busy,load_src_reg_en} <= 3'b000;
			next_state <= (send) ? s1 : idle;
		end

		s1: begin
			{req,busy,load_src_reg_en} <= 3'b111;
			next_state <= (ack) ? s1 : s2;
		end

		s2: begin
			{req,busy,load_src_reg_en} <= 3'b110;
			next_state <= (ack) ? s3 : s2;
		end

		s3: begin
			{req,busy,load_src_reg_en} <= 3'b010;
			next_state <= (ack) ? s3 : idle;
		end

		default: begin
			{req,busy,load_src_reg_en} <= 3'b000;
			next_state <= idle;
		end
	endcase
end

endmodule

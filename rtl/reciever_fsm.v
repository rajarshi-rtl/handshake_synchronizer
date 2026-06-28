// --------------- RECIEVER FSM ---------------- //

module reciever_fsm(
	input des_clk, req, rst,
	output reg des_ff_en, ack	
);

// Encoding the states of Reciever FSM
parameter idle = 2'b00, s1 = 2'b01, s2 = 2'b10;
reg [1:0] present_state, next_state;

// Present state logic
always @ (posedge des_clk or negedge rst) begin
	if (!rst) begin
		present_state <= idle;
		{des_ff_en,ack} = 2'b00;
	end
	else present_state <= next_state;
end

// Next State Logic
always @ (*) begin
	case(present_state) 
		idle: begin
			next_state <= (req) ? s1 : idle;
			{des_ff_en,ack} <= 2'b00;
		end

		s1: begin
			next_state <= (req) ? s2 : idle;
			{des_ff_en,ack} <= 2'b11;
		end

		s2: begin
			next_state <= (req) ? s2 : idle;
			{des_ff_en,ack} <= 2'b01;
		end

		default: begin
			next_state <= idle;
			{des_ff_en,ack} <= 2'b00;
		end
	endcase
end

endmodule

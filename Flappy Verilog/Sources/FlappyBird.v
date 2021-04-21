module FlappyBird(Clk, Reset, Start, Flap_Button, YBird, XBird);

	/*  INPUTS */
	input	Clk, Reset, Start, Ack, Flap_Button;
	
	output reg [9:0] YBird, XBird;		
	//output q_I, q_Grav, q_Flap, q_UnPress, q_Lost;


	reg [3:0] state;
	reg [49:0] gravityTimer;
	reg [9:0] gravity;


//	assign {q_I, q_Grav, q_Flap, q_UnPress} = state;
		
	localparam 	
	I = 4'b0001, GRAV = 4'b0010, FLAP = 4'b0100, UNPRESS = 4'b1000, UNK = 4'bXXXX;
	
	// NSL AND SM
	always @ (posedge Clk, posedge Reset)
	begin 
		if(Reset) 
		  begin
			state <= I;
			YBird <= 10'bX;
			XBird <= 10'bX;
			gravityTimer <= 50'bX;
			gravity <= 10'bX;
		  end
		else				// ****** TODO ****** complete several parts
				case(state)	
					I:
					begin
						YBird <= 500;
						XBird <= 100;
						gravity <= 1;
						gravityTimer <= 0;
						if (Start)
						begin
							state <= GRAV:
						end
					end		
					GRAV:
					begin
						gravityTimer <= gravityTimer + 50'd1;
						if (gravityTimer >= 50'd500000) 
						begin
							gravityTimer <= 50'd0;
							BirdX <= BirdX - gravity;
							gravity <= gravity + 1;
						end
						if(Flap_Button)
						begin
							state <= FLAP;
							gravity <= 40;
							gravityTimer <= 0;
						end
					end
					FLAP:
					begin
						if(gravity < 10)
						begin
							state <= UNPRESS;
							gravity <= 1;
							gravityTimer <= 0;
						end
						gravityTimer <= gravityTimer + 50'd1;
						if (gravityTimer >= 50'd500000) 
						begin
							gravityTimer <= 50'd0;
							BirdX <= BirdX + gravity;
							gravity <= gravity - 2;
						end
					end
					UNPRESS:
					begin
						if(!Flap_Button)
						begin
							state <= GRAV;
						end
						gravityTimer <= gravityTimer + 50'd1;
						if (gravityTimer >= 50'd500000) 
						begin
							gravityTimer <= 50'd0;
							BirdX <= BirdX - gravity;
							gravity <= gravity + 1;
						end
					end
					
				endcase
	end
		
	// OFL
	// no combinational output signals
	
endmodule

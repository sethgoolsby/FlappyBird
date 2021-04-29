
module FlappyBird(Clk, Reset, Start, Flap_Button, YBird, XBird);

	/*  INPUTS */
	input	Clk, Reset, Start, Flap_Button;
	
	output reg [9:0] YBird, XBird;		
	

	reg [3:0] state;
	reg [49:0] gravityTimer;
	reg [5:0] gravity;

		
	localparam 	
	I = 4'b0001, GRAV = 4'b0010, FLAP = 4'b0100, UNPRESS = 4'b1000, UNK = 4'bXXXX;
	initial begin
		state <= I;
		YBird <= 100;
		XBird <= 500;
	end
	
	// NSL AND SM
	always @ (posedge Clk, posedge Reset)
	begin 
		if(!Reset) 
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
						YBird <= 100;
						XBird <= 500;
						gravity <= 1;
						gravityTimer <= 0;
						if (Start)
						begin
							state <= GRAV;
						end
					end		
					GRAV:
					begin
						gravityTimer <= gravityTimer + 50'd1;
						if (gravityTimer >= 50'd2000000) 
						begin
							gravityTimer <= 50'd0;
							YBird <= YBird + gravity;
							gravity <= gravity + 1;
						end
						if(Flap_Button)
						begin
							state <= FLAP;
							gravity <= 6'b001111;
							gravityTimer <= 0;
						end
					end
					FLAP:
					begin
						if(gravity <= 2)
						begin
							state <= UNPRESS;
							gravity <= 1;
							gravityTimer <= 0;
						end
						gravityTimer <= gravityTimer + 50'd1;
						if (gravityTimer >= 50'd2000000) 
						begin
							gravityTimer <= 50'd0;
							YBird <= YBird - (gravity + 2) ;
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
						if (gravityTimer >= 50'd1000000) 
						begin
							gravityTimer <= 50'd0;
							YBird <= YBird + gravity;
							gravity <= gravity + 1;
						end
					end
					default:
					begin
						state <= GRAV;
					end
				endcase
	end
		
	// OFL
	// no combinational output signals
	
endmodule

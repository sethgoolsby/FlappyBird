module ee354_GCD(Clk, Reset, Start, Ack, Flap_Button, q_I, q_Grav, q_Flap, q_UnPress, q_Lost);

	/*  INPUTS */
	input	Clk, Reset, Start, Ack, Flap_Button;
	
	output reg [9:0] YBird, XBird;		

	output q_I, q_Grav, q_Flap, q_UnPress, q_Lost;
	reg [3:0] state;	
	assign {q_I, q_Grav, q_Flap, q_UnPress} = state;
		
	localparam 	
	I = 4'b0001, GRAV = 4'b0010, FLAP = 4'b0100, UNPRESS = 4'b1000, UNK = 4'bXXXXX;
	
	// NSL AND SM
	always @ (posedge Clk, posedge Reset)
	begin 
		if(Reset) 
		  begin
			state <= I;
			YBird <= 10'bX;
			XBird <= 10'bX;
		  end
		else				// ****** TODO ****** complete several parts
				case(state)	
					I:
					begin
						YBird <= 500;
						XBird <= 100;
						if (Start)
						{
							state <= GRAV:
						}
					end		
					GRAV:
					begin
						
					end
					FLAP:
					begin
						
					end
					UNPRESS:
					begin
						
					end
					
				endcase
	end
		
	// OFL
	// no combinational output signals
	
endmodule

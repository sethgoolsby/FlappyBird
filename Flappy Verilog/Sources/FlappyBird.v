module ee354_GCD(Clk, SCEN, Reset, Start, Ack, q_I, q_Grav, q_Flap, q_UnPress, q_Lost);


	/*  INPUTS */
	input	Clk, SCEN, Reset, Start, Ack, Flap_Button;
	
	output reg [9:0] YBird, XBird;		

	output q_I, q_Grav, q_Flap, q_UnPress, q_Lost;
	reg [4:0] state;	
	assign {q_I, q_Grav, q_Flap, q_UnPress, q_Lost} = state;
		
	localparam 	
	I = 5'b00001, GRAV = 5'b00010, FLAP = 5'b00100, UNPRESS = 5'b01000, LOST = 5'b10000, UNK = 5'bXXXXX;
	
	// NSL AND SM
	always @ (posedge Clk, posedge Reset)
	begin 
		if(Reset) 
		  begin
			state <= I;
			i_count <= 8'bx;  	// ****** TODO ******
			A <= 8'bx;		  	// complete the 3 lines
			B <= 8'bx;
			AB_GCD <= 8'bx;			
		  end
		else				// ****** TODO ****** complete several parts
				case(state)	
					I:
					begin
						// state transfers
						if (Start) state <= SUB;
						// data transfers
						i_count <= 0;
						A <= Ain;
						B <= Bin;
						AB_GCD <= 0;
					end		
					SUB: 
		               if (SCEN) //  This causes single-stepping the SUB state
						begin		
							// state transfers
							if (A == B) state <= (i_count == 0) ? DONE : MULT;
							// data transfers
							if (A == B) AB_GCD <= A;		
							if (A < B)
							  begin
								// swap A and B
                A <= B;
                B <= A;
							  end
							else						// if (A > B)
							  begin	
                  if (A[0] && B[0]) 
                    begin
                      A <= A-B;
                    end
                  if (~A[0] && ~B[0])
                    begin
                      i_count <= i_count+1;
                      A <=A/2;
                      B <=B/2;
                    end
                  else 
                    begin
                      if (~A[0]) 
                        A <= A/2;
                      if (~B[0])
                        B <= B/2;
                    end
							  end
						end
					MULT:
					  if (SCEN) // This causes single-stepping the MULT state
						begin
							// state transfers
                if (i_count == 1) state <= DONE;
							// data transfers
                AB_GCD <= AB_GCD*2;
                i_count <= i_count-1;
						end
					
					DONE:
						if (Ack)	state <= I;
						
					default:		
						state <= UNK;
				endcase
	end
		
	// OFL
	// no combinational output signals
	
endmodule

module ee354_Flappy(Clk, SCEN, Reset, Start, Ack, q_I, q_Grav, q_Flap, q_UnPress, q_Lost, Flap_Button, YBird, XBird);

	/*  INPUTS */
	input	Clk, SCEN, Reset, Start, Ack, Flap_Button;
	
	output reg [9:0] YBird, XBird;		

	output q_I, q_Grav, q_Flap, q_UnPress, q_Lost;
	reg [4:0] state;	
	assign {q_I, q_Grav, q_Flap, q_UnPress, q_Lost} = state;
		
	localparam 	
	I = 5'b00001, GRAV = 5'b00010, FLAP = 5'b00100, UNPRESS = 5'b01000, LOST = 5'b10000, UNK = 5'bXXXXX;
	
	reg[3:0] buffer;
	// NSL AND SM
	always @ (posedge Clk, posedge Reset)
	begin 
		if(Reset) 
		  begin
			state <= I;
			XBird <= 10'd144;
			YBird <= 10'd320;
			buffer <= 4'bXXXX;
		  end
		else				
				case(state)	
					I:
					begin
						// state transfers
						XBird <= 10'd144;
						YBird <= 10'd320;
						buffer <= 4'b0000;
						if(Start)
						state <= FLAP; //Maybe loading a flap to start out would be good for gameplay?
						
					end		
					FLAP: 
		            begin
						if(buffer == 1111)
							state <= UNPRESS;
						else
						begin
							buffer <= buffer + 1;
							YBird <= YBird + 2;
						end
					end
						
					UNPRESS:
					  begin
						if(!Flap_Button)  
							state <= GRAV;
					  end
					GRAV:
						begin
							if(Flap_Button)
							begin
							state <= FLAP;
							YBird <= YBird - 1;
						end
						end
					default:
					begin		
						state <= UNK;
						end
				endcase
	end
		
	// OFL
	// no combinational output signals
	
endmodule

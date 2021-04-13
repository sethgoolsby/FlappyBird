module ee354_Pipe(Clk, Reset, Start, PipePosY, PipePosX, Lost);

    // 800px x 525px
    output reg [9:0] PipePosY;
    output reg [9:0] PipePosX;
	/*  INPUTS */
	input	Clk, Reset, Start, Lost;
	reg [4:0] state;	
    reg [9:0] waitReg;
    reg Time;

	localparam 	
	I = 5'b00001, PREP = 5'b00010, MOVE = 5'b00100, LOST = 5'b10000, UNK = 5'bXXXXX;
	
    always @ (posedge Clk, posedge Reset)
    begin
        if (Reset) waitReg <= 0;       
        else if (waitReg == 10b'1111111111) 
        begin
            waitReg <= 0;
            Time <= 1;
        end
        else 
        begin
            waitReg <= waitReg + 1;
            Time <= 0;
        end
    end
	// NSL AND SM
	always @ (posedge Clk, posedge Reset)
	begin 
        if (Reset)
        begin
            PipePosX <= 10'bXXXXXXXXXX;
            PipePosY <= 10'bXXXXXXXXXX;
            state <= I;
        end
        else if (Lost) 
        begin
            state <= LOST;
        end
        else
        begin
            case (state)
            begin
                I:
                begin
                    PipePosX <= 1000;
                    PipePosY <= $random%475 + 25;
                    if (Start) state <= MOVE;
                end
                MOVE:
                begin
                    PipePosX <= PipePosX - 1;
                    if (PipePosX == 0) state <= PREP;
                end
                PREP:
                begin
                    PipePosX <= 1000;
                    PipePosY <= $random%475 + 25;
                    if (Time) state <= MOVE;
                end
                LOST:
                begin
                    if (Start) state <= I;
                end
            end
        end
        
	end
		
endmodule

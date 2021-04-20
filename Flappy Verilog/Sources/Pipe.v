module pipe(Clk, Reset, Start, PipePosY, PipePosX, Lost);

    // 800px x 525px
    output reg [9:0] PipePosY;
    output reg [9:0] PipePosX;
	/*  INPUTS */
	input	Clk, Reset, Start, Lost;
	reg [4:0] state;	
    reg [9:0] waitReg;
    reg Time;

    reg [49:0] PipeSpeed;

	localparam 	
	I = 5'b00001, PREP = 5'b00010, MOVE = 5'b00100, LOST = 5'b10000, UNK = 5'bXXXXX;
	
    initial begin
        PipeSpeed <= 0;
        PipePosX <= 1000;
        PipePosY <= 250;
        state <= I;
    end

    always @ (posedge Clk) 
    begin
        PipeSpeed <= PipeSpeed + 1;
        if (PipeSpeed >= 50'd500000)
        begin
            PipePosX <= PipePosX - 1;
            PipeSpeed <= 0;
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
                    if (PipePosX <= 0) state <= PREP;
                end
                PREP:
                begin
                    PipePosX <= 900;
                    PipePosY <= $random%475 + 25;
                    state <= MOVE;
                end
                LOST:
                begin
                    if (Start) state <= I;
                end
            end
        end
        
	end
		
endmodule

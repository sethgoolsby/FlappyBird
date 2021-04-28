module pipe(Clk, Reset, Start, PipePosY1, PipePosX1, PipePosX2, PipePosY2, Lost);

    // 800px x 525px
    output reg [9:0] PipePosY1;
    output reg [9:0] PipePosX1;

    output reg [9:0] PipePosY2;
    output reg [9:0] PipePosX2;
	/*  INPUTS */
	input	Clk, Reset, Start, Lost;
	reg [4:0] state;	
    reg [9:0] waitReg;
    reg Time;

    reg [49:0] PipeSpeed;

    reg[1:0][9:0] Pipe1Height;
    reg[2:0][9:0] Pipe2Height;
    
    reg Start2, i, j;
	localparam 	
	I = 5'b00001, PREP = 5'b00010, MOVE = 5'b00100, LOST = 5'b10000, UNK = 5'bXXXXX;
	
    initial begin
        Pipe1Height[0] = 50;
        Pipe1Height[1] = 100;
        Pipe1Height[0] = 250;
        Pipe1Height[0] = 175;
        Pipe2Height[7] = 50;
        Pipe2Height[0] = 90;
        Pipe2Height[6] = 130;
        Pipe2Height[4] = 170;
        Pipe2Height[2] = 210;
        Pipe2Height[3] = 250;
        Pipe2Height[5] = 290;
        Pipe2Height[1] = 400;
        PipeSpeed <= 0;
        PipePosX1 <= 800;
        PipePosX2 <= 800;
        PipePosY1 <= 250;
        PipePosY2 <= 75;
        i <= 0;
        j <= 0;
        Start2 = 0;
        state <= I;
    end

    always @ (posedge Clk) 
    begin
        PipeSpeed <= PipeSpeed + 50'd1;
        if (PipePosX1 == 288)
            Start2 <= 1;
        if (PipePosX1 == 1000) 
        begin
            PipePosY1 <= Pipe1Height[i];
            i <= i+1;
        end
        if (PipePosX2 == 1000)
        begin
            PipePosY2 <= Pipe2Height[j];
            j <= j+1;
        end
        if (PipeSpeed >= 50'd500000) 
         begin
         PipeSpeed <= 50'd0;
         PipePosX1 <= PipePosX1 - 1;
         if (Start2)
         PipePosX2 <= PipePosX2 - 1;
         end
    end
/*
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
                I:
                begin
                    PipePosX <= 500;
                    PipePosY <= $random%350 + 50;
                    if (Start) state <= MOVE;
                end
                MOVE:
                begin
                    if (PipePosX <= 0) state <= PREP;
                    if (PipeSpeed >= 50'd500000)
                        begin
                        
                    end
                end
                PREP:
                begin
                    PipePosX <= 500;
                    PipePosY <= $random%350 + 50;
                    state <= MOVE;
                end
                LOST:
                begin
                    if (Start) state <= I;
                end
            endcase
        end
        
	end*/
		
endmodule

module pipeB(Clk, Reset, Start, PipePosXB, PipePosYB);

    output reg [9:0] PipePosYB;
    output reg [9:0] PipePosXB = 10'd1023;
	/*  INPUTS */
	input	Clk, Reset, Start;
	reg [4:0] state;	
    reg [9:0] waitReg;
    reg Time;

    reg [49:0] PipeSpeed;

    reg[9:0]PipeBHeight[2:0];
    
    reg [2:0] j;
	localparam 	
	I = 5'b00001, PREP = 5'b00010, MOVE = 5'b00100, LOST = 5'b10000, UNK = 5'bXXXXX;
	
    initial begin
        PipeBHeight[7] = 200;
        PipeBHeight[0] = 300;
        PipeBHeight[6] = 230;
        PipeBHeight[4] = 170;
        PipeBHeight[2] = 210;
        PipeBHeight[3] = 250;
        PipeBHeight[5] = 190;
        PipeBHeight[1] = 100;
        PipeSpeed <= 0;
        PipePosYB <= 10'd75;
        j <= 0;
        state <= I;
    end

    always @ (posedge Clk) 
    begin
        if(Start)
        begin
        PipeSpeed <= PipeSpeed + 50'd1;
        if (PipeSpeed >= 50'd500000) 
         begin
          if (PipePosXB == 0)
        begin
            PipePosYB <= PipeBHeight[j];
            j <= j+1;
            PipePosXB <= 10'd1000;
        end
         PipeSpeed <= 50'd0;
         PipePosXB <= PipePosXB - 1;
         end
        end
        else
        begin
            PipePosXB = 10'd1023
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

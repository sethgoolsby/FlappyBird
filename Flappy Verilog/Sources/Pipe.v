module pipe(Clk, Reset, Start, PipePosYA, PipePosXA);

    // 800px x 525px
    output reg [9:0] PipePosYA;
    output reg [9:0] PipePosXA = 10'd1000;

	/*  INPUTS */
	input	Clk, Reset, Start;
	reg [4:0] state;	
    reg [9:0] waitReg;
    reg Time;

    reg [49:0] PipeSpeed;
    
    reg startFlag;

    reg[9:0] PipeAHeight[1:0];
    
    reg [1:0] i;
	localparam 	
	I = 5'b00001, PREP = 5'b00010, MOVE = 5'b00100, LOST = 5'b10000, UNK = 5'bXXXXX;
	
    initial begin
        PipeAHeight[0] = 190;
        PipeAHeight[1] = 270;
        PipeAHeight[2] = 20;
        PipeAHeight[3] = 135;
        waitReg = 10'd0;
        PipeSpeed <= 0;
        PipePosYA <= 200;
        i <= 0;
        startFlag = 0;
        state <= I;
    end

    always @ (posedge Clk) 
    begin
        if(Start)
        begin
        PipeSpeed <= PipeSpeed + 50'd1;
        if (waitReg == 10'd512)
            startFlag = 1;
       
        if (PipeSpeed >= 50'd500000) 
         begin
          if (PipePosXA == 0) 
        begin
             PipePosXA <= 10'd1000;
            PipePosYA <= PipeAHeight[i];
            i <= i+1;
        end
        waitReg <= waitReg + 1;
         PipeSpeed <= 50'd0;
         if (startFlag)
         PipePosXA <= PipePosXA - 1;
         end
    end
    else
    begin
        PipePosXA <= 10'd1000;
        PipePosYA <= 200;
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

module Game(Clk, Reset, Start, Ack, YBird, XBird, XPipe1, YPipe1, XPipe2, q_I, q_EN, q_End);

input Clk, Reset, Start;
input reg [9:0] YBird, XBird, YPipe1, XPipe1, YPipe2, XPipe2;


output reg [15:0] points;
output q_I, q_EN, q_End;



localparam 	
	I = 3'b001, GAME = 3'b010, END = 3'b100, UNK = 3'bXXX;
reg [2:0] state;
reg pointFlag;
reg pointFlag2;

assign {q_End, q_EN, q_I} = state;

initial begin
    state <= I;
end

always @(posedge Clk posedge Reset)
begin
    if(!Reset)
    {
        state <= I;
        points <= X;
    }
    case (state)
        I:
        begin
            points <= 0;
            pointFlag <= 1;
            if(Start)
            begin
                state <= GAME;
                pointFlag <= 0;
            end
        end
        GAME:
        begin
            if(Collide || Fall)
            begin
                state <= END;
            end
            if(XBird < XPipe1)
                begin
                    pointFlag <= 0;
                end
            else
                begin
                    pointFlag <= 1;
                    if(!pointFlag)
                    begin
                        points <= points + 1;
                    end
                end
            if(XBird < XPipe2)
                begin
                    pointFlag2 <= 0;
                end
            else
                begin
                    pointFlag2 <= 1;
                    if(!pointFlag2)
                    begin
                        points <= points + 1;
                    end
                end
        end
        END:
        begin
            if(ACK)
            begin
                state <= I;
            end
        end

    endcase
    
end
assign Collide = (!((XBird + 10) < (XPipe1 - 50)) || ((XBird - 10) > (XPipe1 + 50)) || (((YBird + 10) > (YPipe1 + 100)) && ((YBird - 10) < YPipe1))) || (!((XBird + 10) < (XPipe2 - 50)) || ((XBird - 10) > (XPipe2 + 50)) || (((YBird + 10) > (YPipe2 + 100)) && ((YBird - 10) < YPipe2)))
assign Fall =  YBird < 1000;

endmodule


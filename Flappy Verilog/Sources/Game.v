module Game(Clk, Reset, Start, Ack, YBird, XBird, XPipe1, YPipe1, XPipe2, YPipe2, q_I, q_EN, q_End, points);

input Clk, Reset, Start, Ack;
input [9:0] YBird, XBird, YPipe1, XPipe1, YPipe2, XPipe2;

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

always @ (posedge Clk, posedge Reset)
begin
    if(!Reset)
    begin
        state <= I;
        points <= 16'bX;
    end
    else
    begin
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
                if(Collide1 || Collide2 || Fall)
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
                if(Ack)
                begin
                    state <= I;
                end
            end

        endcase
    end
end
assign Collide1 = (((XBird + 10) > (XPipe1 - 50)) && ((XBird - 10) < (XPipe1 + 50)))&&(((YBird - 10)<(YPipe1))||((YBird + 10) > (YPipe1 + 150)));//((((YBird - 10) < YPipe1) || (YBird + 10) > (YPipe1 + 150)) && (((XBird + 10) > (XPipe1 - 50))&&((XBird - 10) < (YPipe1 + 50)) )) ? 1 : 0;//(!((XBird + 10) < (XPipe1 - 50)) || ((XBird - 10) > (XPipe1 + 50)) || (((YBird + 10) < (YPipe1 + 150)) && ((YBird - 10) > YPipe1))) || (!((XBird + 10) < (XPipe2 - 50)) || ((XBird - 10) > (XPipe2 + 50)) || (((YBird + 10) < (YPipe2 + 150)) && ((YBird - 10) > YPipe2)));
assign Collide2 = (((XBird + 10) > (XPipe2 - 50)) && ((XBird - 10) < (XPipe2 + 50)))&&(((YBird - 10)<(YPipe2))||((YBird + 10) > (YPipe2 + 150)));
assign Fall =  YBird > 1000;

endmodule


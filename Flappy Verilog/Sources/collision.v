module Collision(Clk, Reset, Start, YBird, XBird, XPipe, YPipe, Collide);

input Clk, Reset, Start;
input reg [9:0] YBird, XBird, YPipe, XPipe;

output Collide;

initial begin
    Collide = 0;
end
always @(posedge Clk posedge Reset)
begin
    
    



end


endmodule

assign Collide = (((YBird + 10) < (YPipe + 100)) && ((YBird - 10) < (YPipe))) && (((XBird + 10) > (PipeX - 50)) && (XBird - 10) < () )
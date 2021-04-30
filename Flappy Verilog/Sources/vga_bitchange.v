`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:38 12/14/2017 
// Design Name: 
// Module Name:    vgaBitChange 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Date: 04/04/2020 
// Author: Yue (Julien) Niu
// Description: Port from NEXYS3 to NEXYS4
//////////////////////////////////////////////////////////////////////////////////
module vga_bitchange(
	input clk,
	input bright,
	input [9:0] hCount, vCount,
	input [9:0] BirdX, BirdY,
	input [9:0] PipeY1, PipeX1, PipeY2, PipeX2,
	output reg [11:0] rgb
   );
	
	parameter BLACK = 12'b0000_0000_0000;
	parameter WHITE = 12'b1111_1111_1111;
	parameter RED   = 12'b1111_0000_0000;
	parameter GREEN = 12'b0000_1111_0000;
	//parameter BLUE = 12'b0000_0000_1111;

	reg reset;
	
	
	
	always@ (*) // paint a white box on a red background
    	if (~bright)
		rgb = BLACK; // force black if not bright
	 else if ((pipeZone == 1)|| (pipeZone2 == 1))
		rgb = GREEN;
	 else if (birbs == 1)
		rgb = WHITE; // white box
	 else
		rgb = RED; // background color

	assign whiteZone = ((hCount >= 10'd144) && (hCount <= 10'd784)) && ((vCount >= 10'd400) && (vCount <= 10'd475)) ? 1 : 0;
	assign pipeZone = ((hCount >= (PipeX1 - 50)) && (hCount <= (PipeX1 + 50)) && ((vCount <= PipeY1) || (vCount >= (PipeY1 + 150)))) ? 1 : 0;
	assign pipeZone2 = ((hCount >= (PipeX2 - 50)) && (hCount <= (PipeX2 + 50)) && ((vCount <= PipeY2) || (vCount >= (PipeY2 + 150)))) ? 1 : 0;
	assign birbs = ((hCount >= BirdX - 10) && (hCount <= BirdX + 10 )) && ((vCount >= BirdY-10) && (vCount <= BirdY + 10)) ? 1 : 0;

	
endmodule

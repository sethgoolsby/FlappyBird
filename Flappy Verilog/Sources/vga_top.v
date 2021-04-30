`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:18:00 12/14/2017 
// Design Name: 
// Module Name:    vga_top 
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
module vga_top(
	input ClkPort,
	input BtnC,
	input BtnU,
	input BtnD,
	input btnCpuReset,
	
	//VGA signal
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	
	//SSG signal 
	output An0, An1, An2, An3, An4, An5, An6, An7,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	output Ld0, Ld1, Ld2, Ld3,
	
	output MemOE, MemWR, RamCS, QuadSpiFlashCS
	);
	
	wire bright;
	wire[9:0] hc, vc;
	wire[15:0] score;
	wire [6:0] ssdOut;
	wire [3:0] anode;
	wire [11:0] rgb;
	wire [9:0] PipeX1;
	wire [9:0] PipeY1;
	wire [9:0] PipeX2;
	wire [9:0] PipeY2;
	wire [9:0] BirdX;
	wire [9:0] BirdY;
	wire gameStateI, gameStateEnable, gameStateEnd;

	pipe p(.Clk(ClkPort), .Reset(btnCpuReset), .Start(gameStateEnable), .PipePosYA(PipeY1), .PipePosXA(PipeX1));
	pipeB pb(.Clk(ClkPort), .Reset(btnCpuReset), .Start(gameStateEnable), .PipePosXB(PipeX2), .PipePosYB(PipeY2));
	display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
	vga_bitchange vbc(.clk(ClkPort), .bright(bright), .hCount(hc), .vCount(vc), .rgb(rgb), .PipeX1(PipeX1), .PipeY1(PipeY1), .PipeX2(PipeX2), .PipeY2(PipeY2), .BirdX(BirdX), .BirdY(BirdY));
	FlappyBird fb(.Clk(ClkPort), .Reset(btnCpuReset), .Start(gameStateEnable), .Flap_Button(BtnC), .YBird(BirdY), .XBird(BirdX));
	Game g(.Clk(ClkPort), .Reset(btnCpuReset), .Start(BtnU), .Ack(BtnD), .YBird(BirdY), .XBird(BirdX), .XPipe1(PipeX1), .YPipe1(PipeY1), .XPipe2(PipeX2),.YPipe2(PipeY2), .q_I(gameStateI), .q_EN(gameStateEnable), .q_End(gameStateEnd), .points(score));
	counter c(.clk(ClkPort), .displayNumber(score), .anode(anode), .ssdOut(ssdOut));
	

	assign Dp = 1;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg} = ssdOut[6 : 0];
    assign {An7, An6, An5, An4, An3, An2, An1, An0} = {4'b1111, anode};

	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	assign Ld0 = gameStateI;
	assign Ld1 = gameStateEnable;
	assign Ld2 = gameStateEnd;
	/*assign Ld3 = birdQU;*/

	// disable mamory ports
	assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;

endmodule

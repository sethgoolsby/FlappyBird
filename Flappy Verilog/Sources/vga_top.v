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
	wire [9:0] PipeXA;
	wire [9:0] PipeYA;
	wire [9:0] PipeXB;
	wire [9:0] PipeYB;
	wire [9:0] BirdX;
	wire [9:0] BirdY;
	wire lost;
	wire birdQI, birdQG, birdQF, birdQU;

	pipe p(.Clk(ClkPort), .Reset(btnCpuReset), .Start(BtnU), .PipePosYA(PipeYA), .PipePosXA(PipeXA), .Lost(lost));
	pipeB pb(.Clk(ClkPort), .Reset(btnCpuReset), .Start(BtnU), .PipePosYB(PipeYB), .PipePosXB(PipeXB), .Lost(lost));
	display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
	vga_bitchange vbc(.clk(ClkPort), .bright(bright), .button(BtnU), .hCount(hc), .vCount(vc), .rgb(rgb), .score(score), .PipeXA(PipeXA), .PipeYA(PipeYA), .PipeXB(PipeXB), .PipeYB(PipeYB), .BirdX(BirdX), .BirdY(BirdY));
	FlappyBird fb(.Clk(ClkPort), .Reset(btnCpuReset), .Start(BtnU), .Flap_Button(BtnC), .YBird(BirdY), .XBird(BirdX), .q_I(birdQI), .q_Grav(birdQG), .q_Flap(birdQF), .q_UnPress(birdQU));
	
	assign Dp = 1;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg} = ssdOut[6 : 0];
    assign {An7, An6, An5, An4, An3, An2, An1, An0} = {4'b1111, anode};

	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	assign Ld0 = birdQI;
	assign Ld1 = birdQG;
	assign Ld2 = birdQF;
	assign Ld3 = birdQU;

	// disable mamory ports
	assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;

endmodule

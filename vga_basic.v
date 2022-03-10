`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:40:16 02/24/2022 
// Design Name: 
// Module Name:    vga_basic 
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
//////////////////////////////////////////////////////////////////////////////////
module vga_basic(
    input Clk12,
    output HSync,
    output VSync,
    output [2:0] Red,
    output [2:0] Green,
    output [1:0] Blue,
	 input [7:0] IO_P1,
	 output [7:0] LED
    );
assign LED = IO_P1;
wire CLK;
clocksyn clock_synth ( .CLKIN_IN (Clk12), 
                   .CLKFX_OUT (CLK));
wire [9:0] x, y;
localparam MEM_SIZE = 128;
reg [7:0] memory [0:MEM_SIZE-1];
initial begin
  $readmemh("ball32.txt", memory);
end
vga_sync vs(.CLK (CLK), .HS (HSync), .VS (VSync), .x (x), .y (y));
assign Red = ((x > 0) & (x < 32) & (y > 0) & (y < 32) & (memory[x[4:3]+y*4]>>~x[2:0]))?7:0;
assign Green = ((x > 200) & (x < 400) & (y > 150) & (y < 350))?7:0;
assign Blue = ((x > 300) & (x < 600) & (y > 180) & (y < 480))?3:0;

endmodule

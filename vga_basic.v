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
localparam MEM_SIZE = 128;
reg [7:0] memory [0:MEM_SIZE-1];
initial begin
  $readmemh("ghost32.txt", memory);
end
reg [7:0] memory2 [0:MEM_SIZE-1];
initial begin
  $readmemh("ball32.txt", memory2);
end
wire [9:0] x;
wire [9:0] y;
wire blank;
vga_sync vs(.CLK (CLK), .HS (HSync), .VS (VSync), .x (x), .y (y), .blank(blank));
reg VSync2;
always @(posedge CLK)
begin
  VSync2 <= VSync;
end
wire Upd;
assign Upd = VSync & ~VSync2;
reg [9:0] xp,yp,xp2,yp2;
reg xd,yd,xd2,yd2;
initial begin
  xp=50;
  yp=60;
  xp2=100;
  yp2=80;
  xd=1;
  yd=2;
  xd2=0;
  yd2=1;
end
always @(posedge CLK)
begin
  if (Upd)
  begin
    if (xd)
	 begin
      xp <= xp+1;
      if (xp>=(640-1-32))
		begin
		  xd<=0;
		end  
    end
	 else
	 begin
      xp <= xp-1;
      if (xp<=1)
		begin
		  xd<=1;
		end  
    end
    if (yd)
	 begin
      yp <= yp+1;
      if (yp>=(480-1-32))
		begin
		  yd<=0;
		end  
    end
	 else
	 begin
      yp <= yp-1;
      if (yp<=1)
		begin
		  yd<=1;
		end  
    end
    if (xd2)
	 begin
      xp2 <= xp2+1;
      if (xp2>=(640-1-32))
		begin
		  xd2<=0;
		end  
    end
	 else
	 begin
      xp2 <= xp2-1;
      if (xp2<=1)
		begin
		  xd2<=1;
		end  
    end
    if (yd2)
	 begin
      yp2 <= yp2+1;
      if (yp2>=(480-1-32))
		begin
		  yd2<=0;
		end  
    end
	 else
	 begin
      yp2 <= yp2-1;
      if (yp2<=1)
		begin
		  yd2<=1;
		end  
    end
  end
end
wire [9:0] xs,ys,xs2,ys2;
wire shape1,shape2;  //& (memory[x[4:3]+y*4]>>~x[2:0])
assign xs = x-xp;
assign ys = y-yp;
assign xs2 = x-xp2;
assign ys2 = y-yp2;
assign shape1 = (xs < 32) & (ys < 32) & (memory[xs[4:3]+ys*4]>>~xs[2:0]);
assign shape2 = (xs2 < 32) & (ys2 < 32) & (memory2[xs2[4:3]+ys2*4]>>~xs2[2:0]);

reg [2:0] Red2,Green2;
reg [1:0] Blue2;

always @(posedge CLK)
begin
  Red2 <= (~blank &(x >= 0) & (x < 200) & (y > 0) & (y < 300))?7:0;
  Green2 <= (shape1^((x > 200) & (x < 400) & (y > 150) & (y < 350)))?7:0;
  Blue2 <= (shape2^((x > 300) & (x < 640) & (y > 180) & (y < 480)))?3:0;
end
assign Red = Red2;
assign Green = Green2;
assign Blue = Blue2;

endmodule

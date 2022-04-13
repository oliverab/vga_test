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
reg [9:0] xp [0:2],yp [0:2];
reg xd [0:2],yd [0:2];
initial begin
  xp[0]=50;
  yp[0]=60;
  xp[1]=100;
  yp[1]=80;
  xp[2]=200;
  yp[2]=120;
  xd[0]=1;
  yd[0]=0;
  xd[1]=0;
  yd[1]=1;
  xd[2]=0;
  yd[2]=1;
end
integer i;

always @(posedge CLK)
begin
  if (Upd)
  begin
	 for(i=0; i<3; i=i+1)
	 begin
    if (xd[i])
	 begin
      xp[i] <= xp[i]+1;
      if (xp[i]>=(640-1-32))
		begin
		  xd[i]<=0;
		end  
    end
	 else
	 begin
      xp[i] <= xp[i]-1;
      if (xp[i]<=1)
		begin
		  xd[i]<=1;
		end  
    end
    if (yd[i])
	 begin
      yp[i] <= yp[i]+1;
      if (yp[i]>=(480-1-32))
		begin
		  yd[i]<=0;
		end  
    end
	 else
	 begin
      yp[i] <= yp[i]-1;
      if (yp[i]<=1)
		begin
		  yd[i]<=1;
		end  
    end
    end
  end
end
wire [9:0] xs[2:0],ys[2:0];
wire shape [2:0];  //& (memory[x[4:3]+y*4]>>~x[2:0])

genvar j;
generate
  for(j=0; j<3; j=j+1) 
  begin:genblk
    assign xs[j] = x-xp[j];
    assign ys[j] = y-yp[j];
  end
endgenerate
assign shape[0] = (xs[0] < 32) & (ys[0] < 32) & (memory [xs[0][4:3]+ys[0]*4]>>~xs[0][2:0]);
assign shape[1] = (xs[1] < 32) & (ys[1] < 32) & (memory2[xs[1][4:3]+ys[1]*4]>>~xs[1][2:0]);
assign shape[2] = (xs[2] < 32) & (ys[2] < 32) & (memory2[xs[2][4:3]+ys[2]*4]>>~xs[2][2:0]);

reg [2:0] Red2,Green2;
reg [1:0] Blue2;

always @(posedge CLK)
begin
  Red2 <= (shape[2]^(~blank &(x >= 0) & (x < 200) & (y > 0) & (y < 300)))?7:0;
  Green2 <= (shape[1]^((x > 200) & (x < 400) & (y > 150) & (y < 350)))?7:0;
  Blue2 <= (shape[0]^((x > 300) & (x < 640) & (y > 180) & (y < 480)))?3:0;
end
assign Red = Red2;
assign Green = Green2;
assign Blue = Blue2;

endmodule

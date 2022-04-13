`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:25:15 02/24/2022 
// Design Name: 
// Module Name:    vga_sync 
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
module vga_sync(
    input CLK,
    output HS,
    output VS,
    output [9:0] x,
    output [9:0] y,
    output blank
    );
reg [9:0] xc;
reg [9:0] yc;
//reg pha;
// Horizontal 640 + HFP 24 + HS 40 + HBP = 832 pixel ticks
// Vertical, 480 + VFP 9 lines + VS 3 lines + VBP 28 lines
assign blank = ((xc < 192) | (xc > 832) | (yc > 479));
assign HS = ~ ((xc > 23) & (xc < 65));
assign VS = ~ ((yc > 489) & (yc < 493));
//assign x = ((xc < 192)?10'b1111111111:(xc - 192));
assign x = xc-192;
assign y = yc;

always @(posedge CLK)
begin
//   pha <= ~pha;
//   if (pha)
	begin
	  if (xc == 832)
	  begin
		 xc <= 0;
		 yc <= yc + 1;
	  end
	  else
	  begin
		 xc <= xc + 1;
	  end
	  if (yc == 520)
	  begin
		 yc <= 0;
	  end
	end
end


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2023 09:43:47 PM
// Design Name: 
// Module Name: VGAController
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module VGAController(
    input clk,
    
    output Hsync,
    output Vsync,
    output [14:0] Hpixel,
    output [14:0] Vpixel,
    output activeRegion
    );
    
    wire Hactive;
    wire Vactive;
    
    assign Hsync = (Hpixel < 15'd655) | (Hpixel > 15'd750);
    assign Vsync = (Vpixel < 15'd489) | (Vpixel > 15'd490);   
    assign activeRegion = ((Hpixel <= 15'd640) & (Vpixel <= 15'd480));
    
    CountUD15L HpixelCount(
        .Up(1'b1), 
        .Dw(1'b0), 
        .LD(Hpixel==15'd799), //Reset value
        .clk(clk), 
        .Din({15{1'b0}}), 
        .Q(Hpixel)
    );
    CountUD15L VpixelCount(
        .Up(Hpixel==15'd799), //Reset value
        .Dw(1'b0), 
        .LD((Hpixel == 15'd799) & (Vpixel == 15'd524)), //Reset values
        .clk(clk), 
        .Din({15{1'b0}}), 
        .Q(Vpixel)
   );
    
endmodule
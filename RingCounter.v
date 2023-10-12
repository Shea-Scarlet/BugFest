`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2023 05:39:07 PM
// Design Name: 
// Module Name: RingCounter
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


module RingCounter(

input Advance,
input clk,
output [3:0] sel
    );
    
    // lab2_digsel mydigsel (.clkin(clk), .greset(), .digsel(Advance));
    FDRE #(.INIT(1'b1)) Q0_FF (.C(clk), .R(1'b0), .CE(Advance), .D(sel[3]), .Q(sel[0]));
    FDRE #(.INIT(1'b0)) Q1_FF (.C(clk), .R(1'b0), .CE(Advance), .D(sel[0]), .Q(sel[1]));
    FDRE #(.INIT(1'b0)) Q2_FF (.C(clk), .R(1'b0), .CE(Advance), .D(sel[1]), .Q(sel[2]));
    FDRE #(.INIT(1'b0)) Q3_FF (.C(clk), .R(1'b0), .CE(Advance), .D(sel[2]), .Q(sel[3]));
    
endmodule
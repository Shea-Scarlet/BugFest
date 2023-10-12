`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2023 06:11:28 PM
// Design Name: 
// Module Name: counterUD15L
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


module CountUD15L(
    input clk,
    input LD,
    input [14:0] Din,
    input Up,
    input Dw,
    output UTC,
    output DTC,
    output [14:0] Q
    );

    wire [2:0] UTCout;
    wire [2:0] DTCout;
    wire x, y, w, z;
    assign x = Up&UTCout[0];
    assign y = Up&UTCout[0]&UTCout[1];
    assign w = Dw&DTCout[0];
    assign z = Dw&DTCout[0]&DTCout[1];
    
    countUD5L Count40 (.clk(clk), .Up(Up), .Dw(Dw), .LD(LD), .Din(Din[4:0]), .UTC(UTCout[0]), .DTC(DTCout[0]), .Q(Q[4:0]));
    countUD5L Count95 (.clk(clk), .Up(x), .Dw(w), .LD(LD), .Din(Din[9:5]), .UTC(UTCout[1]), .DTC(DTCout[1]), .Q(Q[9:5]));
    countUD5L Count1410 (.clk(clk), .Up(y), .Dw(z), .LD(LD), .Din(Din[14:10]), .UTC(UTCout[2]), .DTC(DTCout[2]), .Q(Q[14:10]));
    
    assign UTC = UTCout[0]&UTCout[1]&UTCout[2];
    assign DTC = DTCout[0]&DTCout[1]&DTCout[2];
    
endmodule

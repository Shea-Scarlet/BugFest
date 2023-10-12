`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2023 04:36:33 PM
// Design Name: 
// Module Name: Selector
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


module Selector(

input [3:0] sel,
input [15:0] N,
output [3:0] H


    );
    
    assign H = ({4{sel[0]}}&N[3:0])|({4{sel[1]}}&N[7:4])|({4{sel[2]}}&N[11:8])|({4{sel[3]}}&N[15:12]);
 
endmodule

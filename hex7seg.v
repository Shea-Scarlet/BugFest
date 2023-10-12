`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2023 04:35:54 PM
// Design Name: 
// Module Name: hex7seg
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


module hex7seg(

    input [3:0] d,
    output [6:0] seg
    
    );
    
    //Selector mySelector (.H(d));
    
    assign seg[0] = (~d[3]&~d[2]&~d[1]&d[0])|(~d[3]&d[2]&~d[1]&~d[0])|(d[3]&~d[2]&d[1]&d[0])|(d[3]&d[2]&~d[1]&d[0]);
    assign seg[1] = (~d[3]&d[2]&~d[1]&d[0])|(~d[3]&d[2]&d[1]&~d[0])|(d[3]&~d[2]&d[1]&d[0])|(d[3]&d[2]&~d[1]&~d[0])|(d[3]&d[2]&d[1]&~d[0])|(d[3]&d[2]&d[1]&d[0]);
    assign seg[2] = (~d[3]&~d[2]&d[1]&~d[0])|(d[3]&d[2]&~d[1]&~d[0])|(d[3]&d[2]&d[1]&~d[0])|(d[3]&d[2]&d[1]&d[0]);
    assign seg[3] = (~d[3]&~d[2]&~d[1]&d[0])|(~d[3]&d[2]&~d[1]&~d[0])|(~d[3]&d[2]&d[1]&d[0])|(d[3]&~d[2]&~d[1]&d[0])|(d[3]&~d[2]&d[1]&~d[0])|(d[3]&d[2]&d[1]&d[0]);
    assign seg[4] = (~d[3]&~d[2]&~d[1]&d[0])|(~d[3]&~d[2]&d[1]&d[0])|(~d[3]&d[2]&~d[1]&~d[0])|(~d[3]&d[2]&~d[1]&d[0])|(~d[3]&d[2]&d[1]&d[0])|(d[3]&~d[2]&~d[1]&d[0]);
    assign seg[5] = (~d[3]&~d[2]&~d[1]&d[0])|(~d[3]&~d[2]&d[1]&~d[0])|(~d[3]&~d[2]&d[1]&d[0])|(~d[3]&d[2]&d[1]&d[0])|(d[3]&d[2]&~d[1]&d[0]);
    assign seg[6] = (~d[3]&~d[2]&~d[1]&~d[0])|(~d[3]&~d[2]&~d[1]&d[0])|(~d[3]&d[2]&d[1]&d[0])|(d[3]&d[2]&~d[1]&~d[0]);

    
endmodule
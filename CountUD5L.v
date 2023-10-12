`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2023 02:12:07 PM
// Design Name: 
// Module Name: countUD5L
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


module countUD5L(
    input Up,
    input Dw,
    input LD,
    input [4:0] Din,
    input clk,
    output UTC,
    output DTC,
    output [4:0] Q
    );
    
    wire [4:0] D;
    wire [4:0] Qwire;
    wire [4:0] Qwireup;
    wire [4:0] Qwiredw;
    wire x1;
    wire x2;
    wire x3;
    wire x4;
    wire x5;
    
    //MUX call
    
    assign Qwireup[0] = Up;
    assign Qwiredw[0] = Dw;
    assign Qwireup[1] = (Up&Qwire[0]);
    assign Qwiredw[1] = (Dw&~Qwire[0]);
    assign Qwireup[2] = (Up&Qwire[1]&Qwire[0]);
    assign Qwiredw[2] = (Dw&~Qwire[1]&~Qwire[0]);
    assign Qwireup[3] = (Up&Qwire[2]&Qwire[1]&Qwire[0]);
    assign Qwiredw[3] = (Dw&~Qwire[2]&~Qwire[1]&~Qwire[0]);
    assign Qwireup[4] = (Up&Qwire[3]&Qwire[2]&Qwire[1]&Qwire[0]);
    assign Qwiredw[4] = (Dw&~Qwire[3]&~Qwire[2]&~Qwire[1]&~Qwire[0]);
    
    wire [4:0] y;
    
    assign y = (Qwire ^ (Qwireup | Qwiredw))  & ~{5{LD}} | ({5{LD}} & Din);
    
    FDRE #(.INIT(1'b0)) Q0_FF (.C(clk), .CE(1'b1), .R(1'b0), .D(y[0]), .Q(Qwire[0]));
    FDRE #(.INIT(1'b0)) Q1_FF (.C(clk), .CE(1'b1), .R(1'b0), .D(y[1]), .Q(Qwire[1]));
    FDRE #(.INIT(1'b0)) Q2_FF (.C(clk), .CE(1'b1), .R(1'b0), .D(y[2]), .Q(Qwire[2]));
    FDRE #(.INIT(1'b0)) Q3_FF (.C(clk), .CE(1'b1), .R(1'b0), .D(y[3]), .Q(Qwire[3]));
    FDRE #(.INIT(1'b0)) Q4_FF (.C(clk), .CE(1'b1), .R(1'b0), .D(y[4]), .Q(Qwire[4]));
    
    assign UTC = Qwire[0] & Qwire[1] & Qwire[2] & Qwire[3] & Qwire[4];
    assign DTC = ~Qwire[0] & ~Qwire[1] & ~Qwire[2] & ~Qwire[3] & ~Qwire[4];
    assign Q = Qwire;
    
endmodule

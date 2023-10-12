`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2023 02:15:15 PM
// Design Name: 
// Module Name: TopMod
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

module TopMod(

    input btnU,
    input btnC,
    input btnR,
    input clkin,
    
    output dp,
    output [3:0] an,
    output [6:0] seg,
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output Hsync,
    output Vsync

    );
    
    wire clk;
    wire digsel;
    wire Water;
    wire Frame;
    wire Platform;
    wire Slug;
    wire Bug;
    wire [14:0] Hpixel;
    wire [14:0] Vpixel;
    wire activeRegion;
    wire Plat1, Plat2, Plat3;
    wire Caught;
    wire [3:0] ringO, selOut;
    wire [4:0] Score;

    assign an[0] =  ~selOut[0];
    assign an[1] =  ~selOut[1];
    assign an[2] =  1'b1;
    assign an[3] =  1'b1;
    assign dp = 1'b1;
    
    labVGA_clks not_so_slow (.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel));
    
    VGAController MyVGA (
        .clk(clk),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .Hpixel(Hpixel),
        .Vpixel(Vpixel),
        .activeRegion(activeRegion)
        );
    
    Background myBG (
        .clk(clk),
        .btnU(btnU),
        .btnC (btnC),
        .Hpixel(Hpixel),
        .Vpixel(Vpixel),
        .Water(Water),
        .Frame(Frame),
        .Plat1(Plat1),
        .Plat2(Plat2),
        .Plat3(Plat3),
        .Slug(Slug),
        .Bug(Bug),
        .Caught(Caught)
        );
        

     
     countUD5L scoreCounter(
        .clk(clk),
        .Up(Caught),
        .Din(Score),
        .Q(Score)
    );
     
    //Ring Counter logic
    RingCounter myRing (.Advance(digsel), .clk(clk), .sel(ringO));
    Selector myMainSelector(.sel(ringO), .N({10'b0,Score}), .H(selOut));
    hex7seg myhex (.d(Score[3:0]), .seg(seg));
    
    assign vgaBlue = (({4{activeRegion}} & ({4{Water}} & 4'hF)) | ({4{activeRegion}} & ({4{Frame}} & 4'hF)) | ({4{activeRegion}} & ({4{Plat1|Plat2|Plat3}} & 4'h8)) | ({4{activeRegion}} & ({4{Slug}} & 4'h0)) | ({4{activeRegion}} & ({4{Bug}} & 4'h0)));
    assign vgaRed = (({4{activeRegion}} & ({4{Water}} & 4'h0)) | ({4{activeRegion}} & ({4{Frame}} & 4'h0)) | ({4{activeRegion}} & ({4{Plat1|Plat2|Plat3}} & 4'hB)) | ({4{activeRegion}} & ({4{Slug}} & 4'hF)) | ({4{activeRegion}} & ({4{Bug}} & 4'h0)));
    assign vgaGreen = (({4{activeRegion}} & ({4{Water}}&4'h9)) | ({4{activeRegion}} & ({4{Frame}} & 4'h5)) | ({4{activeRegion}} & ({4{Plat1|Plat2|Plat3}} & 4'h0)) | ({4{activeRegion}} & ({4{Slug}} & 4'hF)) | ({4{activeRegion}} & ({4{Bug}} & 4'hF)));

    
endmodule



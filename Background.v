`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2023 05:53:34 PM
// Design Name: 
// Module Name: Background
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

module Background(

    input clk,
    input [14:0] Hpixel,
    input [14:0] Vpixel,
    input btnU,
    input btnC,
    
    output Water, 
    output Frame,
    output Slug,
    output Bug,
    output Plat1,
    output Plat2,
    output Plat3,
    output Caught
    );
    
    wire [14:0] TopFrame;
    wire [14:0] BottomFrame;
    wire [14:0] LeftFrame;
    wire [14:0] RightFrame;
    
    wire [7:0] RD;
    wire [7:0] RQ;
    wire [14:0] Vrand;
    
    wire [14:0] VSlug;
    wire [14:0] HSlug;
    wire [14:0] HBug;
    
    wire FPS1;
    wire FPS2;
    
    wire bug_out;
    
    wire [14:0] PlatTop;
    wire [14:0] PlatBottom;

    wire Start;
    wire Playing;
    wire [14:0] Plat1V, Plat1H, Plat2V, Plat2H, Plat3V, Plat3H;
    wire [14:0] LeftPlat1, LeftPlat2, LeftPlat3;
    
    wire SlugLeftPlat;
    wire SlugTopPlat;
    wire SlugBottomPlat;
    
    wire moving;
    wire waiting;
    wire [14:0] flashing;
    wire slug_flash, bug_flash;
    
    wire slug_border;
    
    wire [7:0] flip;
    wire flash_water;
    wire [7:0] waitingnew;

    //Assigning the confinements of the frame
    assign TopFrame = {4{(Hpixel>=15'd0) & (Hpixel<=15'd639) & (Vpixel>=15'd0) & (Vpixel<=15'd7)}};
    assign BottomFrame = {4{(Hpixel>=15'd0) & (Hpixel<=15'd639) & (Vpixel>=15'd472) & (Vpixel<=15'd479)}};
    assign LeftFrame = {4{(Hpixel>=15'd0) & (Hpixel<=15'd7) & (Vpixel>=15'd8) & (Vpixel<=15'd471)}};
    assign RightFrame = {4{(Hpixel>=15'd632) & (Hpixel<=15'd639) & (Vpixel>=15'd8) & (Vpixel<=15'd471)}};
    
    //Assigning Water and Frame: Background
    assign Water = {4{(Hpixel>=15'd8) & (Hpixel<=15'd631) & (Vpixel>=15'd375) & (Vpixel<=15'd471)}};
    assign Frame = (TopFrame | BottomFrame | LeftFrame | RightFrame);
    
    //Assigning three platforms for the game
    assign LeftPlat1 = Plat1H - Plat1V;
    assign LeftPlat2 = Plat2H - Plat2V;
    assign LeftPlat3 = Plat3H - Plat3V;
    
    assign Plat1 = ~Frame&({4{(Hpixel >= (LeftPlat1)) & (Hpixel <= Plat1H) & (Vpixel >= 15'd200) & (Vpixel <= 15'd207)}});
    assign Plat2 = ~Frame&({4{(Hpixel >= (LeftPlat2)) & (Hpixel <= Plat2H) & (Vpixel >= 15'd200) & (Vpixel <= 15'd207)}});
    assign Plat3 = ~Frame&({4{(Hpixel >= (LeftPlat3)) & (Hpixel <= Plat3H) & (Vpixel >= 15'd200) & (Vpixel <= 15'd207)}});

    assign SlugLeftPlat = (((
        ((HSlug + 15'd17) >= (LeftPlat1))
        & (HSlug + 15'd17) <= ((LeftPlat1) + 15'd17)
        | ((HSlug + 15'd17) >= (LeftPlat2))
        & (HSlug + 15'd17) <= ((LeftPlat2) + 15'd17)
        | ((HSlug + 15'd17) >= (LeftPlat3))
        & (HSlug + 15'd17) <= ((LeftPlat3) + 15'd17))
        & ((VSlug + 15'd1 <= PlatBottom)
        & (VSlug + 15'd16 >= PlatTop)
        )));
        
    assign PlatTop = 15'd201;
    assign PlatBottom = 15'd208;
    assign flash_water = VSlug + 15'd17 ==  15'd375;
    assign slug_border = HSlug == 15'd8;
        
    assign SlugTopPlat = (VSlug + 15'd17 == PlatTop)
         & ((LeftPlat1 < 15'd140 + 15'd16 & Plat1H > 15'd140 - 15'd2)
         | (LeftPlat2 < 15'd140 + 15'd16 & Plat2H > 15'd140 - 15'd2)  
         | (LeftPlat3 < 15'd140 + 15'd16 & Plat3H > 15'd140 - 15'd2));
                                 
    assign SlugBottomPlat =
        (VSlug == PlatBottom) 
        & ((LeftPlat1 < 15'd140 + 15'd16 & Plat1H > 15'd140 - 15'd2) 
        | (LeftPlat2 < 15'd140 + 15'd16 & Plat2H > 15'd140 - 15'd2)  
        | (LeftPlat3 < 15'd140 + 15'd16 & Plat3H > 15'd140 - 15'd2));

    
    //Assigning Slug and Bug
    //assign Bug = {4{(Hpixel>=HBug) & (Hpixel<=HBug+15'd8) & (Vpixel>=15'd128) & (Vpixel<=15'd128+15'd8)}}; //15'd623 15'd631
    //assign Slug = {4{(Hpixel>=15'd140) & (Hpixel<=15'd156) & (Vpixel>=VSlug) & (Vpixel<=(VSlug+15'd16))}}; //15'd184 15'd200
    //assign Bug = {4{(Hpixel>=HBug) & (Hpixel<=(HBug+15'd8)) & (Vpixel>={5'b0,Vrand[10:0]}) & (Vpixel<=({5'b0,Vrand[10:0]}+15'd8))}}; //15'd623 15'd631
    
    assign Slug = ~slug_flash & {4{(Hpixel >= HSlug) & (Hpixel <= HSlug + 15'd16) & (Vpixel >= VSlug) & (Vpixel <= (VSlug + 15'd16))}};
    assign Bug = ~Frame & ~bug_flash & {4{(Hpixel >= HBug) & (Hpixel <= HBug + 15'd7) & (Vpixel >= Vrand) & (Vpixel <= Vrand + 15'd8)}};
    
    //Random number generator
    LFSR myVrand (.clk(clk), .Q(RD));
    //Locking in Flip Flop
    
    //Fixing Random value to fit constriants + MUX
    //assign Vrand = ({10{RQ[4]}} & (RQ[1:0]*7)+10'd128) | (~{10{RQ[4]}} & (RQ[3:2]*7)+10'd256);
    assign Vrand = ({15{RQ[5]}}&(RQ[4:0]+15'd128)) | ({15{~RQ[5]}}&(RQ[4:0]+15'd256)) ;
    
    assign FPS1 = Hpixel == 15'd799 & Vpixel == 15'd524;
    assign FPS2 = FPS1 | Hpixel == 15'd798 & Vpixel == 15'd424;
    
    wire flashoff;
    assign flashoff = flashing <= 15'd8;
    
    assign waiting = (waitingnew >= 15'd128);
    assign slug_flash = (flash_water | slug_border | SlugLeftPlat) & flashoff;
    assign bug_flash = bug_out & ((flashing <= 15'd8));
    
    CountUD15L VSlugCounter(
        .Up((FPS2 & VSlug < 15'd358 & ~btnU) | SlugBottomPlat | SlugLeftPlat | slug_border | flash_water), 
        .Dw((FPS2 & VSlug > 15'd8 & btnU) | SlugTopPlat | SlugBottomPlat | SlugLeftPlat | slug_border | flash_water), 
        .LD(Start), //Reset value
        .clk(clk), 
        .Din(15'd180), //Starting Value
        .Q(VSlug)
    );
    
    CountUD15L HSlugCounter(
        .clk(clk),                 
        .Up(1'b0),
        .Dw((FPS1 & HSlug > 15'd8) & SlugLeftPlat), 
        .LD(Start),
        .Din(15'd140),
        .Q(HSlug)
    );
    
    //HSlug = new_top = slug_col
    //VSlug = new_bot = slug_wet
    
    CountUD15L HBugCounter(
        .Up(1'b0), 
        .Dw((FPS2 & HBug >= 15'd0) & ~bug_out), 
        .LD(HBug<=15'd0 | waiting | Start), //Reset value
        .clk(clk), 
        .Din(15'd623), //Starting Value
        .Q(HBug)
    );
    
    
    //My FlipFlop values for each State
    FDRE #(.INIT(1'b1)) StartFF (.C(clk), .CE(1'b1), .R(1'b0), .D(1'b0), .Q(Start));
    FDRE #(.INIT(1'b0)) MovingFF (.C(clk), .R(1'b0), .CE(btnC), .D(1'b1), .Q(moving));
    FDRE #(.INIT(1'b0)) SlugBugCollision (.C(clk), .R(waiting), .CE(Bug & Slug), .D(1'b1), .Q(bug_out));
    
    //Generating random value for Bug
    FDRE #(.INIT(1'b0)) RDFF [7:0] (.C({8{clk}}), .CE(HBug==15'd0 | waiting | Start), .R(8'b0), .D(RD), .Q(RQ));
    
    //modify later
        FDRE #(.INIT(1'b0)) ff [7:0](
        .C({8{clk}}),
        .R({8{1'b0}}),
        .CE(Plat1H == 15'd8 | Plat2H == 15'd8 | Plat3H == 15'd8),
        .D(RD[7:0]),
        .Q(flip[7:0])
    );
    

 

    CountUD15L WaitTimeCounter (.clk(clk), .Up(FPS1 & bug_out), .Dw(1'b0), .LD(waiting), .Din(15'b0), .Q(waitingnew));
    
    assign Caught = bug_out & waiting;
    
    //My counter for the Slug Flashing

    CountUD15L FlashTimer (.clk(clk), .Up(FPS1), .Dw(1'b0), .LD(flashing[5]), .Din(15'b0), .Q(flashing));
    
    //My Counters for the 3 Platforms
    CountUD15L Plat1VCounter(.Up(1'b0), .Dw((FPS1 & (LeftPlat1 <= 15'd7) & moving & ~slug_border) & ~bug_out), .LD(Plat1V == 0 | Start), .clk(clk), .Din(({15{~Start}} & {1'b1, flip[4:0], 2'b00}) | ({15{Start}} & 15'd200)), .Q(Plat1V));
    CountUD15L Plat1HCounter(.Up(1'b0), .Dw((FPS1 & moving & ~slug_border) & ~bug_out), .LD(Plat1H <= 15'd7 | Start), .clk(clk), .Din(({15{~Start}} & 15'd950) | ({15{Start}} & 15'd625)), .Q(Plat1H));
    CountUD15L Plat2VCounter(.Up(1'b0), .Dw((FPS1 & (LeftPlat2 <= 15'd7) & moving & ~slug_border) & ~bug_out), .LD(Plat2V == 0 | Start), .clk(clk), .Din(({15{~Start}} & {1'b1, flip[5:1], 2'b00}) | ({15{Start}} & 15'd200)), .Q(Plat2V));
    CountUD15L Plat2HCounter(.Up(1'b0), .Dw((FPS1 & moving & ~slug_border) & ~bug_out), .LD(Plat2H <= 15'd7 | Start), .clk(clk), .Din(({15{~Start}} & 15'd950) | ({15{Start}} & 15'd325)), .Q(Plat2H));
    CountUD15L Plat3VCounter(.Up(1'b0), .Dw((FPS1 & (LeftPlat3 <= 15'd7) & moving & ~slug_border) & ~bug_out), .LD(Plat3V == 0 | Start), .clk(clk), .Din(({15{~Start}} & {1'b1, flip[6:2], 2'b00}) | ({15{Start}} & 15'd200)), .Q(Plat3V));
    CountUD15L Plat3HCounter(.Up(1'b0), .Dw((FPS1 & moving & ~slug_border) & ~bug_out), .LD(Plat3H <= 15'd7 | Start), .clk(clk), .Din(({15{~Start}} & 15'd950) | ({15{Start}} & 15'd25)), .Q(Plat3H));
   
endmodule
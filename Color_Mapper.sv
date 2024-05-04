//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module color_mapper ( input logic [6:0] text[13],
                       input logic [2:0] grid[10][22], 
                       input logic [9:0] DrawX, DrawY,
                       input logic [9:0] score,
                       output logic [3:0]  Red, Green, Blue );
    
    logic ball_on, font_on;
    logic [10:0] addr;
    logic [7:0] data;
    
    always_comb begin
    
    if (DrawY >= 224 && DrawY < 240) begin
        addr = ((text[(DrawX - 468) >> 3]) << 4) + (DrawY - 224);
    end else begin
        if (DrawX >= 508 && DrawX < 516) begin
            addr = ((8'h30 + (score / 100) % 10) << 4) + (DrawY - 240);
        end else if (DrawX >= 516 && DrawX < 524) begin
            addr = ((8'h30 + ((score / 10) % 10)) << 4) + (DrawY - 240);
        end else begin
            addr = ((8'h30 + (score % 10)) << 4) + (DrawY - 240);
        end
    end
    
    end
    
    font_rom font_rom(.addr(addr), .data(data));
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
       )

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
//    int DistX, DistY, Size;
////    int i;
//    assign DistX = DrawX - BallX;
//    assign DistY = DrawY - BallY;    
    
//    assign Size = Ball_size;
  
    always_comb
    begin:Ball_on_proc
        if (DrawX >= 240 && DrawX < 400 && DrawY >= 80 && DrawY < 400)
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
    end 
     
    always_comb
    begin:font
        if (data[7-(DrawX-468) & 7] == 1)
            font_on = 1'b1;
        else
            font_on = 1'b0;
    end
       
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) begin 
//            if ((DrawX - 200) % 24 == 0) begin
//                Red = 0;
//                Green = 0;
//                Blue = 0;
//            end else if (DrawY % 24 == 0) begin
//                Red = 0;
//                Green = 0;
//                Blue = 0;
//            end else 
            if (grid[(DrawX-240) >> 4][((DrawY-80)>>4) + 2] == 1) begin
                Red = 4'h7;
                Green = 4'h7;
                Blue = 4'h7;
            end else if (grid[(DrawX-240) >> 4][((DrawY-80)>>4) + 2] == 2) begin
                Red = 4'h0;
                Green = 4'hf;
                Blue = 4'h0;
            end else if (grid[(DrawX-240) >> 4][((DrawY-80)>>4) + 2] == 3) begin
                Red = 4'hf;
                Green = 4'h0;
                Blue = 4'h0;
            end else if (grid[(DrawX-240) >> 4][((DrawY-80)>>4) + 2] == 4) begin
                Red = 4'h0;
                Green = 4'h0;
                Blue = 4'hf;
            end else if (grid[(DrawX-240) >> 4][((DrawY-80)>>4) + 2] == 5) begin
                Red = 4'hf;
                Green = 4'h7;
                Blue = 4'h0;
            end else if (grid[(DrawX-240) >> 4][((DrawY-80)>>4) + 2] == 6) begin
                Red = 4'hf;
                Green = 4'h9;
                Blue = 4'h0;
            end else if (grid[(DrawX-240) >> 4][((DrawY-80)>>4) + 2] == 7) begin
                Red = 4'h7;
                Green = 4'h0;
                Blue = 4'h7;
//            end else if (grid[(DrawX-240) >> 4][((DrawY-80)>>4) + 2] == 8) begin
//                Red = 4'hf;
//                Green = 4'h7;
//                Blue = 4'h0;
            end else begin
                Red = 4'hf;
                Green = 4'hb;
                Blue = 4'hc;
            end     
        end else begin 
            if (DrawX >= 468 && DrawX < 572 && DrawY >= 224 && DrawY < 240 && font_on) begin
                Red = 4'hf;
                Green = 4'hf;
                Blue = 4'hf;
            end else if (DrawX >= 508 && DrawX < 532 && DrawY >= 240 && DrawY < 256 && font_on) begin
                Red = 4'hf;
                Green = 4'hf;
                Blue = 4'hf;
            end else if (DrawX < 240 || DrawX >= 400 || DrawY < 80 || DrawY >= 400) begin
                Red = 4'h0;
                Green = 4'h0;
                Blue = 4'h0; // bruh
            end else begin
                Red = 4'hf;
                Green = 4'hf;
                Blue = 4'hf;
            end
        end
    end 
    
endmodule
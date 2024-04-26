//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf     03-01-2006                           --
//                                  03-12-2007                           --
//    Translated by Joe Meng        07-07-2013                           --
//    Modified by Zuofu Cheng       08-19-2023                           --
//    Modified by Satvik Yellanki   12-17-2023                           --
//    Fall 2024 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball 
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,

//    output logic [9:0]  BallX, 
//    output logic [9:0]  BallY, 
//    output logic [9:0]  BallS 

    output logic [3:0] grid[10][20]
);
    

	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=24;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=224;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=420;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=24;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=460;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=24;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=24;      // Step size on the Y axis

    logic [9:0] Ball_X_Motion;
    logic [9:0] Ball_X_Motion_next;
    logic [9:0] Ball_Y_Motion;
    logic [9:0] Ball_Y_Motion_next;

    logic [9:0] Ball_X_next;
    logic [9:0] Ball_Y_next;
    logic [7:0] prev_keycode;
    
    logic [7:0] timer;
    logic [7:0] downTick;
    
    logic alive;
    logic dummyAlive;
    
    // logic [3:0] grid[10][20];
    logic [3:0] temp_grid[10][20];

    always_comb begin
//        Ball_Y_Motion_next = Ball_Y_Motion; // set default motion to be same as prev clock cycle 
//        Ball_X_Motion_next = Ball_X_Motion;

        //modify to control ball motion with the keycode
//        if (keycode != 8'h00 && prev_keycode == 8'h00) begin
//            if (keycode == 8'h1A) begin
//                // Ball_Y_Motion_next = -10'd24;
//                // Ball_X_Motion_next = 0;
//                for (int i = 0; i < 10; i++) begin
//                    for (int j = 1; j < 20; j++) begin
//                        if (grid[i][j+1] == 1) begin
//                            temp_grid[i][j] = 1;
//                        end
//                    end
//                end
//            end else if (keycode == 8'h04) begin
////                Ball_X_Motion_next = -10'd24;
////                Ball_Y_Motion_next = 0;
//                for (int i = 0; i < 10-1; i++) begin
//                    for (int j = 0; j < 20; j++) begin
//                        if (grid[i+1][j] == 1) begin
//                            temp_grid[i][j] = 1;
//                        end
//                    end
//                end
//            end else if (keycode == 8'h16) begin
//                // Ball_Y_Motion_next = 10'd24;
//                // Ball_X_Motion_next = 0;
//                for (int i = 0; i < 10; i++) begin
//                    for (int j = 0; j < 20-1; j++) begin
//                        if (grid[i][j-1] == 1) begin
//                            temp_grid[i][j] = 1;
//                        end
//                    end
//                end
//            end else if (keycode == 8'h07) begin
////                Ball_X_Motion_next = 10'd24;
////                Ball_Y_Motion_next = 0;
//                for (int i = 1; i < 10; i++) begin
//                    for (int j = 0; j < 20; j++) begin
//                        if (grid[i-1][j] == 1) begin
//                            temp_grid[i][j] = 1;
//                        end
//                    end
//                end
//            end
//        end else begin
////            Ball_X_Motion_next = 0;
////            Ball_Y_Motion_next = 0;
//        end
        
//        if (downTick >= 50) begin
//            if (BallY < Ball_Y_Max - BallS && dummyAlive) begin
//                Ball_Y_Motion_next = 24;
//            end else begin
//                Ball_Y_Motion_next = 0;
//            end
//        end

//        if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
//        begin
//            Ball_Y_Motion_next = (~ (Ball_Y_Step) + 1'b1);  // set to -1 via 2's complement.
//        end
//        else if ( (BallY - BallS) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
//        begin
//            Ball_Y_Motion_next = Ball_Y_Step;
//        end  
//       //fill in the rest of the motion equations here to bounce left and right
//        if ( (BallX + BallS) >= Ball_X_Max )
//        begin
//            Ball_X_Motion_next = (~ (Ball_X_Step) + 1'b1);
//        end
//        else if ( (BallX - BallS) <= Ball_X_Min )
//        begin
//            Ball_X_Motion_next = Ball_X_Step;
//        end
    end

//    assign BallS = 24;  // default ball size
//    assign Ball_X_next = (BallX + Ball_X_Motion_next);
//    assign Ball_Y_next = (BallY + Ball_Y_Motion_next);

    logic validToMove;
   
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset)
        begin 
            for (int i = 0; i < 10; i++) begin
                for (int j = 0; j < 20; j++) begin
                    temp_grid[i][j] <= 0;
                end
            end
            
            temp_grid[5][1] <= 1;
            temp_grid[6][1] <= 1;
            temp_grid[5][2] <= 1;
            temp_grid[6][2] <= 1;
            
            grid <= temp_grid;

        end else begin
            if (keycode != 8'h00 && prev_keycode == 8'h00) begin
                if (keycode == 8'h1A) begin
                    // Ball_Y_Motion_next = -10'd24;
                    // Ball_X_Motion_next = 0;
                    for (int i = 0; i < 10; i++) begin
                        for (int j = 1; j < 20; j++) begin
//                            if (grid[i][j+1] == 1) begin
//                                temp_grid[i][j] = 1;
//                            end
                            temp_grid[i][j] = grid[i][j+1];
                        end
                    end
                end else if (keycode == 8'h04) begin
    //                Ball_X_Motion_next = -10'd24;
    //                Ball_Y_Motion_next = 0;
                    validToMove = 1;
                    for (int c = 0; c < 20; c++) begin
                        if (grid[0][c] != 0) begin
                            validToMove = 0;
                        end
                    end
                    if (validToMove) begin
                        validToMove = 0;
                        for (int i = 0; i < 10; i++) begin
                            for (int j = 0; j < 20; j++) begin
                                if (i == 9) begin
                                    temp_grid[i][j] = 0;
                                end else begin
                                    temp_grid[i][j] = grid[i+1][j];
                                end
                            end
                        end
                    end
                end else if (keycode == 8'h16) begin
                    // Ball_Y_Motion_next = 10'd24;
                    // Ball_X_Motion_next = 0;
                    validToMove = 1;
                    for (int c = 0; c < 10; c++) begin
                        if (grid[c][19] != 0) begin
                            validToMove = 0;
                        end
                    end
                    if (validToMove) begin
                        validToMove = 0;
                        for (int i = 0; i < 10; i++) begin
                            for (int j = 0; j < 20; j++) begin
                                if (j == 0) begin
                                    temp_grid[i][j] = 0;
                                end else begin
                                    temp_grid[i][j] = grid[i][j-1];
                                end
                            end
                        end
                    end
                end else if (keycode == 8'h07) begin
                    validToMove = 1;
                    for (int c = 0; c < 20; c++) begin
                        if (grid[9][c] != 0) begin
                            validToMove = 0;
                        end
                    end
                    if (validToMove) begin
                        validToMove = 0;
                        for (int i = 0; i < 10; i++) begin
                            for (int j = 0; j < 20; j++) begin
                                if (i == 0) begin
                                    temp_grid[i][j] = 0;
                                end else begin
                                    temp_grid[i][j] = grid[i-1][j];
                                end
                            end
                        end
                    end
                end
            end
            
			grid <= temp_grid;
			prev_keycode <= keycode;
		end  
    end


    
      
endmodule

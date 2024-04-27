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

    output logic [3:0] grid[10][22]
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
    
    // logic [3:0] grid[10][22];
    logic [3:0] temp_grid[10][22];
    logic [3:0] prev_grid[10][22];

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

    logic validToMove;
    logic blankBoard;
    logic rowComplete;
   
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset)
        begin 
            for (int i = 0; i < 10; i++) begin
                for (int j = 0; j < 22; j++) begin
                    temp_grid[i][j] <= 0;
                end
            end
            
            // hardcoded block
//            temp_grid[5][0] <= 1;
//            temp_grid[6][0] <= 1;
//            temp_grid[5][1] <= 1;
//            temp_grid[6][1] <= 1;
            
            grid <= temp_grid;
            timer <= 0;
            blankBoard <= 1;

        end else begin
            // keycode logic
            if (keycode != 8'h00 && prev_keycode == 8'h00) begin
                // w key
                if (keycode == 8'h1A) begin
                    // do nothing
                    
                // a key
                end else if (keycode == 8'h04) begin
                    validToMove = 1;
                    for (int i = 0; i < 10; i++) begin
                        for (int j = 0; j < 22; j++) begin
                            // check if cur pos is part of active block
                            if (grid[i][j] == 1) begin
                                if (i-1 < 0) begin
                                    validToMove = 0;
                                end else if (grid[i-1][j] != 0 && grid[i-1][j] != grid[i][j]) begin
                                    validToMove = 0;
                                end
                            end
                        end
                    end
                    
                    if (validToMove) begin
                        for (int i = 0; i < 10; i++) begin
                            for (int j = 0; j < 22; j++) begin
                                if (grid[i][j] == 2) begin
                                    temp_grid[i][j] = 2;
                                end else if (i < 9 && grid[i+1][j] == 1) begin
                                    temp_grid[i][j] = grid[i+1][j];
                                end else begin
                                    temp_grid[i][j] = 0;
                                end
                            end
                        end
                    end
                
//                    validToMove = 1;
//                    for (int c = 0; c < 22; c++) begin
//                        if (grid[0][c] != 0 || (c < 10 && grid[c][21] == 1)) begin
//                            validToMove = 0;
//                        end
//                    end
//                    if (validToMove) begin
//                        for (int i = 0; i < 10; i++) begin
//                            for (int j = 0; j < 22; j++) begin
//                                if (i == 9) begin
//                                    temp_grid[i][j] = 0;
//                                end else begin
//                                    temp_grid[i][j] = grid[i+1][j];
//                                end
//                            end
//                        end
//                    end
                    
                // s key
                end else if (keycode == 8'h16) begin
                    // do nothing
                    
                // d key
                end else if (keycode == 8'h07) begin
                    validToMove = 1;
                    for (int i = 0; i < 10; i++) begin
                        for (int j = 0; j < 22; j++) begin
                            if (grid[i][j] == 1) begin
                                if (i+1 >= 10) begin
                                    validToMove = 0;
                                end else if (grid[i+1][j] != 0 && grid[i+1][j] != grid[i][j]) begin
                                    validToMove = 0;
                                end
                            end
                        end
                    end
                    
                    if (validToMove) begin
                        for (int i = 0; i < 10; i++) begin
                            for (int j = 0; j < 22; j++) begin
                                if (grid[i][j] == 2) begin
                                    temp_grid[i][j] = 2;
                                end else if (i >= 1 && grid[i-1][j] == 1) begin
                                    temp_grid[i][j] = grid[i-1][j];
                                end else begin
                                    temp_grid[i][j] = 0;
                                end
                            end
                        end
                    end
                    
                    
//                    validToMove = 1;
//                    for (int c = 0; c < 22; c++) begin
//                        if (grid[9][c] != 0 || (c < 10 && grid[c][21] == 1)) begin
//                            validToMove = 0;
//                        end
//                    end
//                    if (validToMove) begin
//                        for (int i = 0; i < 10; i++) begin
//                            for (int j = 0; j < 22; j++) begin
//                                if (i == 0) begin
//                                    temp_grid[i][j] = 0;
//                                end else begin
//                                    temp_grid[i][j] = grid[i-1][j];
//                                end
//                            end
//                        end
//                    end
                end
            end
            
            // drop logic
            if (timer == 20) begin
                timer = 0;
                validToMove = 1;
                for (int i = 0; i < 10; i++) begin
                    for (int j = 0; j < 22; j++) begin
                        if (grid[i][j] == 1) begin
                            if (j+1 >= 22) begin
                                validToMove = 0;
                            end else if (grid[i][j+1] != 0 && grid[i][j+1] != grid[i][j]) begin
                                validToMove = 0;
                            end
                        end
                    end
                end
                
                if (blankBoard) begin
                    blankBoard = 0;
                    validToMove = 0;
                end
                
                if (validToMove) begin
                    for (int i = 0; i < 10; i++) begin
                        for (int j = 0; j < 22; j++) begin
                            if (j == 0) begin
                                temp_grid[i][j] = 0;
                            end else if (grid[i][j] == 2) begin
                                temp_grid[i][j] = grid[i][j];
                            end else if (grid[i][j-1] == 1) begin
                                temp_grid[i][j] = grid[i][j-1];
                            end else begin
                                temp_grid[i][j] = 0;
                            end
                        end
                    end
                // deactivate current block and generate new block
                end else begin
                    for (int i = 0; i < 10; i++) begin
                        for (int j = 0; j < 22; j++) begin
                            if (grid[i][j] == 1) begin
                                temp_grid[i][j] = 2;
                            end
                        end
                    end
                    
                    for (int j = 0; j < 22; j++) begin
                    grid = temp_grid;
                        rowComplete = 1;
                        for (int i = 0; i < 10; i++) begin
                            if (grid[i][j] != 2) begin
                                rowComplete = 0;
                            end
                        end
                        if (rowComplete == 1) begin
                            for (int i = 0; i < 10; i++) begin
                                temp_grid[i][j] = 0;
                            end
                            
                            for (int k = 0; k < 10; k++) begin
                                for (int l = 0; l <= j; l++) begin
                                    if (l == 0) begin
                                        temp_grid[k][l] = 0;
                                    end else begin
                                        temp_grid[k][l] = grid[k][l-1];
                                    end
                                end
                            end
                        end
                    end
                    
                    // hardcode new block
                    temp_grid[4][0] <= 1;
                    temp_grid[5][0] <= 1;
                    temp_grid[4][1] <= 1;
                    temp_grid[5][1] <= 1;
                end
            end
            
			grid <= temp_grid;
			prev_keycode <= keycode;
			timer <= timer + 1;
		end  
    end
      
endmodule

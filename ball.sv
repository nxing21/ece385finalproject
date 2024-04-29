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

//    logic [9:0] Ball_X_Motion;
//    logic [9:0] Ball_X_Motion_next;
//    logic [9:0] Ball_Y_Motion;
//    logic [9:0] Ball_Y_Motion_next;
//    logic [9:0] Ball_X_next;
//    logic [9:0] Ball_Y_next;

    logic [7:0] prev_keycode;
    logic [7:0] timer;
    logic [7:0] timerTemp;
    
    logic [3:0] temp_grid[10][22];
    logic [3:0] temp_temp_grid[10][22];
    logic [3:0] prev_grid[10][22];
    logic [3:0] sq_grid[10][22];
    
    logic validToMove;
    logic blankBoard;
    logic blankBoardTemp;
    logic rowComplete;
    logic [3:0] rand_num, randTemp;
    logic [1:0] rotated;
    logic validToDrop;
    logic validToDropTemp;


    always_comb begin
        
        temp_grid = grid;
        randTemp = rand_num;
        
        validToDropTemp = 1;
        for (int i = 0; i < 10; i++) begin
            for (int j = 0; j < 22; j++) begin
                // if cur is active and invalid --> not valid to move
                if (grid[i][j] >= 2) begin
                    if (j+1 >= 22) begin
                        validToDropTemp = 0;
                    end else if (grid[i][j+1] != 0 && grid[i][j+1] != grid[i][j]) begin
                        validToDropTemp = 0;
                    end
                end
            end
        end
        
        // timerTemp = timer;
        
        // keycode logic
        if (keycode != 8'h00 && prev_keycode == 8'h00) begin
            // w key
            if (keycode == 8'h1A) begin
//                rand_num += 1;
//                rotated += 1;
                
//                for (int i = 0; i < 10; i++) begin
//                    for (int j = 0; j < 22; j++) begin
//                        // 2x2 block
//                        if (grid[i][j] == 2) begin
//                            // do nothing
//                        end
                        
//                        // 4x1 block
//                        else if (grid[i][j] == 3) begin
//                            if (rotated[0] == 0) begin
//                                if (j <= 0 || j >= 20 || grid[i+1][j-1] == 1 || grid[i+1][j+1] == 1 || grid[i+1][j+2] == 1) begin
//                                    rotated += 3;
//                                end else begin
//                                    temp_grid[i][j] = 0;
//                                    temp_grid[i+2][j] = 0;
//                                    temp_grid[i+3][j] = 0;
//                                    temp_grid[i+1][j-1] = 3;
//                                    temp_grid[i+1][j+1] = 3;
//                                    temp_grid[i+1][j+2] = 3;
//                                end
//                            end else begin
//                                if (i <= 0 || i >= 8 || grid[i-1][j+1] == 1 || grid[i+1][j+1] == 1 || grid[i+2][j+1] == 1) begin
//                                    rotated = (rotated-1)%4;
//                                end else begin
//                                    temp_grid[i][j] = 0;
//                                    temp_grid[i][j+2] = 0;
//                                    temp_grid[i][j+3] = 0;
//                                    temp_grid[i-1][j+1] = 0;
//                                    temp_grid[i+1][j+1] = 0;
//                                    temp_grid[i+2][j+1] = 0;
//                                end
//                            end
//                            // end loop
//                            i = 10;
//                            j = 22;
//                        end
                        
//                        // s block
//                        else if (grid[i][j] == 4) begin
//                            if (rotated[0] == 0) begin
//                                if (j >= 21 || grid[i][j-1] == 1 || grid[i+1][j+1] == 1) begin
//                                    rotated += 3;
//                                end else begin
//                                    temp_grid[i+1][j-1] = 0;
//                                    temp_grid[i+2][j-1] = 0;
//                                    temp_grid[i][j-1] = 4;
//                                    temp_grid[i+1][j+1] = 4;
//                                end
//                            end else begin
//                                if (i >= 8 || grid[i+1][j-1] == 1 || grid[i+2][j-1] == 1) begin
//                                    rotated += 3;
//                                end else begin
//                                    temp_grid[i][j-1] = 0;
//                                    temp_grid[i+1][j+1] = 0;
//                                    temp_grid[i+1][j-1] = 4;
//                                    temp_grid[i+2][j-1] = 4;
//                                end
//                            end
//                            // end loop
//                            i = 10;
//                            j = 22;
//                        end
                        
//                        // z block
//                        else if (grid[i][j] == 5) begin
//                            if (rotated[0] == 0) begin
//                                if (1) begin
//                                    rotated += 3;
//                                end else begin
//                                    // changes
//                                end
//                            end else begin
//                                if (1) begin
//                                    rotated += 3;
//                                end else begin
//                                    // changes
//                                end
//                            end
//                            // end loop
//                            i = 10;
//                            j = 22;
//                        end
                        
//                        // l block
////                        else if (grid[i][j] == 6) begin
////                            if (rotated == 0) begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end else if (rotated == 1) begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end else if (rotated == 2) begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end else begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end 
////                            // end loop
////                            i = 10;
////                            j = 22;
////                        end
                        
////                        // j block
////                        else if (grid[i][j] == 7) begin
////                            if (rotated == 0) begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end else if (rotated == 1) begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end else if (rotated == 2) begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end else begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end 
////                            // end loop
////                            i = 10;
////                            j = 22;
////                        end
                        
////                        // t block
////                        else if (grid[i][j] == 8) begin
////                            if (rotated == 0) begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end else if (rotated == 1) begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end else if (rotated == 2) begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end else begin
////                                if (1) begin
////                                    rotated = (rotated-1)%4;
////                                end else begin
////                                    // changes
////                                end
////                            end 
////                            // end loop
////                            i = 10;
////                            j = 22;
////                        end
//                    end
//                end
                
            // a key
            end else if (keycode == 8'h04) begin
                // randTemp += 2;
                validToMove = 1;
                for (int i = 0; i < 10; i++) begin
                    for (int j = 0; j < 22; j++) begin
                        // check if cur pos is part of active block
                        if (grid[i][j] >= 2) begin
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
                            if (grid[i][j] == 1) begin
                                temp_grid[i][j] = 1;
                            end else if (i < 9 && grid[i+1][j] >= 2) begin
                                temp_grid[i][j] = grid[i+1][j];
                            end else begin
                                temp_grid[i][j] = 0;
                            end
                        end
                    end
                end
                
            // s key
            end else if (keycode == 8'h16) begin
                // do nothing
                
            // d key
            end else if (keycode == 8'h07) begin
                // randTemp += 3;
                validToMove = 1;
                for (int i = 0; i < 10; i++) begin
                    for (int j = 0; j < 22; j++) begin
                        if (grid[i][j] >= 2) begin
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
                            if (grid[i][j] == 1) begin
                                temp_grid[i][j] = 1;
                            end else if (i >= 1 && grid[i-1][j] >= 2) begin
                                temp_grid[i][j] = grid[i-1][j];
                            end else begin
                                temp_grid[i][j] = 0;
                            end
                        end
                    end
                end
            end
        end
    end  
        

   
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset)
        begin 
            for (int i = 0; i < 10; i++) begin
                for (int j = 0; j < 22; j++) begin
                    grid[i][j] <= 0;
                end
            end
            
            grid[4][2] <= 2;
            grid[5][2] <= 2;
            grid[4][3] <= 2;
            grid[5][3] <= 2;
            
            // grid <= temp_grid;
            timer <= 0;
            blankBoard <= 1;
            // blankBoardTemp <= 1;
            rand_num <= 1;
            rotated <= 0;
            validToMove <= 1;
            validToDrop <= 1;

        end else begin
        
            rand_num <= randTemp;
            grid <= temp_grid;
            sq_grid <= temp_grid;
            validToDrop <= validToDropTemp;
            
            // drop logic
            if (timer == 20) begin
                
//                validToMove = 1;
//                for (int i = 0; i < 10; i++) begin
//                    for (int j = 0; j < 22; j++) begin
//                        // if cur is active and invalid --> not valid to move
//                        if (grid[i][j] >= 2) begin
//                            if (j+1 >= 22) begin
//                                validToMove <= 0;
//                            end else if (grid[i][j+1] != 0 && grid[i][j+1] != grid[i][j]) begin
//                                validToMove <= 0;
//                            end
//                        end
//                    end
//                end

                
                
                // if no blocks exist yet
//                if (blankBoard) begin
//                    blankBoard <= 0;
//                    validToDrop <= 0;
//                end
                
                if (validToDrop) begin
                    for (int i = 0; i < 10; i++) begin
                        for (int j = 0; j < 22; j++) begin
                            if (j == 0) begin
                                grid[i][j] <= 0;
                            end else if (sq_grid[i][j] == 1) begin
                                grid[i][j] <= sq_grid[i][j];
                            end else if (sq_grid[i][j-1] >= 2) begin
                                grid[i][j] <= sq_grid[i][j-1];
                            end else begin
                                grid[i][j] <= 0;
                            end
                        end
                    end
                    
                // deactivate current block and generate new block
                end else begin
                    // blankBoard <= 0;
                    for (int i = 0; i < 10; i++) begin
                        for (int j = 0; j < 22; j++) begin
                            if (sq_grid[i][j] >= 2) begin
                                grid[i][j] <= 1;
                            end
                        end
                    end
                    
                    // delete rows
                    for (int j = 0; j < 22; j++) begin
                        temp_temp_grid = grid;
                        rowComplete <= 1;
                        for (int i = 0; i < 10; i++) begin
                            if (temp_temp_grid[i][j] != 1) begin
                                rowComplete <= 0;
                            end
                        end
                        if (rowComplete == 1) begin
                            for (int i = 0; i < 10; i++) begin
                                grid[i][j] <= 0;
                            end
                            
                            for (int k = 0; k < 10; k++) begin
                                for (int l = 0; l <= j; l++) begin
                                    if (l == 0) begin
                                        grid[k][l] <= 0;
                                    end else begin
                                        grid[k][l] <= temp_temp_grid[k][l-1];
                                    end
                                end
                            end
                        end
                    end
                    
                    // hardcode new block
                    rand_num <= rand_num+1;
                    if (rand_num >= 7) begin
                        rand_num = 0;
                    end
                    
                    // 2x2 block
                    if (rand_num == 0) begin
                        grid[4][0] <= 2;
                        grid[5][0] <= 2;
                        grid[4][1] <= 2;
                        grid[5][1] <= 2;
                    // 4x1 block
                    end else if (rand_num == 1) begin
                        grid[3][1] <= 3;
                        grid[4][1] <= 3;
                        grid[5][1] <= 3;
                        grid[6][1] <= 3;
                    // s block
                    end else if (rand_num == 2) begin
                        grid[4][1] <= 4;
                        grid[5][1] <= 4;
                        grid[5][0] <= 4;
                        grid[6][0] <= 4;
                    // z block
                    end else if (rand_num == 3) begin
                        grid[4][0] <= 5;
                        grid[5][0] <= 5;
                        grid[5][1] <= 5;
                        grid[6][1] <= 5;
                    // l block
                    end else if (rand_num == 4) begin
                        grid[4][1] <= 6;
                        grid[5][1] <= 6;
                        grid[6][1] <= 6;
                        grid[6][0] <= 6;
                    // j block
                    end else if (rand_num == 5) begin
                        grid[4][0] <= 7;
                        grid[4][1] <= 7;
                        grid[5][1] <= 7;
                        grid[6][1] <= 7;
                    // t block
                    end else if (rand_num == 6) begin
                        grid[4][1] <= 8;
                        grid[5][1] <= 8;
                        grid[5][0] <= 8;
                        grid[6][1] <= 8;
                    end
                end
            end
            
            prev_keycode <= keycode;
            // blankBoard <= blankBoardTemp;
            
            timer <= timer + 1;
            if (timer >= 21) begin
                timer <= 0;
            end
            
            // grid <= temp_grid;
        
        end
    end
      
endmodule
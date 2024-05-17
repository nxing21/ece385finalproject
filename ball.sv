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

    output logic [9:0] score,
    output logic [2:0] grid[10][22]
);
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=24;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=224;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=420;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=24;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=460;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=24;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=24;      // Step size on the Y axis

    logic [7:0] prev_keycode;
    logic [7:0] timer;
    logic [2:0] rotateTimer;
    
    logic [2:0] temp_grid[10][22];
    logic [2:0] temp_temp_grid[10][22];
    logic [2:0] prev_grid[10][22];
    
    logic validToMove;
    logic rowComplete;
    logic [2:0] rand_num, randTemp;
    logic [1:0] rotated, rotatedTemp;
    logic validToDrop, validToDropTemp;
    logic generateNew;
    logic [4:0] nx, ny, tx, ty;
    logic blankBoard, blankBoardTemp;
    logic alreadyMoved;
    logic [9:0] scoreTemp, scoreTracker;
    logic [4:0] update, updateTemp;
    logic dropIt, dropItTemp;


    always_comb begin
        
        // update variables
        temp_grid = grid;
        randTemp = rand_num;
        blankBoardTemp = blankBoard;
        rotated = rotatedTemp;
        scoreTemp = score;
        scoreTracker = score;
        updateTemp = update;
        generateNew = 0;
        alreadyMoved = 0;
        tx = nx;
        ty = ny;
        dropItTemp = dropIt;
        
        // check if okay to drop
        validToDropTemp = 1;
        for (int i = 0; i < 10; i++) begin
            for (int j = 0; j < 22; j++) begin
                if (grid[i][j] >= 2) begin
                    if (j >= 21) begin
                        validToDropTemp = 0;
                    end else if (grid[i][j+1] != 0 && grid[i][j+1] != grid[i][j]) begin
                        validToDropTemp = 0;
                    end
                end
            end
        end
        
        if (blankBoard) begin
            generateNew = 1;
            blankBoardTemp = 0;
        end
        
        // time cycle: update
        if (timer == update || dropIt) begin
            // drop logic
            if (validToDropTemp) begin
                alreadyMoved = 1;
                ty = ny + 1;
                for (int i = 0; i < 10; i++) begin
                    for (int j = 0; j < 22; j++) begin
                        if (j == 0) begin
                            temp_grid[i][j] = 0;
                        end else if (grid[i][j] == 1) begin
                            temp_grid[i][j] = grid[i][j];
                        end else if (grid[i][j-1] >= 2) begin
                            temp_grid[i][j] = grid[i][j-1];
                        end else begin
                            temp_grid[i][j] = 0;
                        end
                    end
                end
                
            // deactivate current block and generate new block
            end else begin
                dropItTemp = 0;
                for (int i = 0; i < 10; i++) begin
                    for (int j = 0; j < 22; j++) begin
                        if (grid[i][j] >= 2) begin
                            temp_grid[i][j] = 1;
                        end
                    end
                end
                generateNew = 1;
            end
        end
        
        if (generateNew) begin
            // delete completed rows
            for (int j = 0; j < 22; j++) begin
                temp_temp_grid = temp_grid;
                rowComplete = 1;
                for (int i = 0; i < 10; i++) begin
                    if (temp_temp_grid[i][j] != 1) begin
                        rowComplete = 0;
                    end
                end
                if (rowComplete) begin
                    scoreTracker += 1;
                    for (int k = 0; k < 10; k++) begin
                        for (int l = 0; l <= j; l++) begin
                            if (l == 0) begin
                                temp_grid[k][l] = 0;
                            end else begin
                                temp_grid[k][l] = temp_temp_grid[k][l-1];
                            end
                        end
                    end
                    
                    if (update > 5) begin
                        updateTemp = update - 1;
                    end
                end
            end
            
            scoreTemp = scoreTracker;
            
            // generate new block
            if (rand_num >= 5) begin
                randTemp = rand_num % 5;
            end else begin
                randTemp = rand_num + 1;
            end
            
            // 2x2 block
            if (randTemp == 0) begin
                temp_grid[4][0] = 2;
                temp_grid[5][0] = 2;
                temp_grid[4][1] = 2;
                temp_grid[5][1] = 2;
                tx = 4;
                ty = 0;
                rotated = 0;
            // 4x1 block
            end else if (randTemp == 1) begin
                temp_grid[3][1] = 3;
                temp_grid[4][1] = 3;
                temp_grid[5][1] = 3;
                temp_grid[6][1] = 3;
                tx = 3;
                ty = 1;
                rotated = 0;
            // s block
            end else if (randTemp == 2) begin
                temp_grid[4][1] = 4;
                temp_grid[5][1] = 4;
                temp_grid[5][0] = 4;
                temp_grid[6][0] = 4;
                tx = 4;
                ty = 1;
                rotated = 0;
            // z block
            end else if (randTemp == 3) begin
                temp_grid[4][0] = 5;
                temp_grid[5][0] = 5;
                temp_grid[5][1] = 5;
                temp_grid[6][1] = 5;
                tx = 4;
                ty = 0;
                rotated = 0;
            // l block
            end else if (randTemp == 4) begin
                temp_grid[4][1] = 6;
                temp_grid[5][1] = 6;
                temp_grid[6][1] = 6;
                temp_grid[6][0] = 6;
                tx = 4;
                ty = 1;
                rotated = 0;
            // j block
            end else if (randTemp == 5) begin
                temp_grid[4][0] = 7;
                temp_grid[4][1] = 7;
                temp_grid[5][1] = 7;
                temp_grid[6][1] = 7;
                tx = 4;
                ty = 0;
                rotated = 0;
            // t block
//            end else if (randTemp == 6) begin
//                temp_grid[4][1] = 8;
//                temp_grid[5][1] = 8;
//                temp_grid[5][0] = 8;
//                temp_grid[6][1] = 8;
//                tx = 4;
//                ty = 1;
//                rotated = 0;
            end
        end
        
        // keycode logic
        else if (keycode != 8'h00 && prev_keycode == 8'h00 && !alreadyMoved) begin
            // w key
            if (keycode == 8'h1A) begin
                randTemp = rand_num + 1;
                // 4x1 block
                if (grid[nx][ny] == 3) begin
                    if (rotatedTemp[0] == 0) begin
                        if (ny <= 0 || ny >= 20 || grid[nx+1][ny-1] == 1 || grid[nx+1][ny+1] == 1 || grid[nx+1][ny+2] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp + 1;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx+2][ny] = 0;
                            temp_grid[nx+3][ny] = 0;
                            temp_grid[nx+1][ny-1] = 3;
                            temp_grid[nx+1][ny+1] = 3;
                            temp_grid[nx+1][ny+2] = 3;
                            tx = nx + 1;
                            ty = ny - 1;
                        end
                    end else begin
                        if (nx <= 0 || nx >= 8 || grid[nx-1][ny+1] == 1 || grid[nx+1][ny+1] == 1 || grid[nx+2][ny+1] == 1) begin
                             // do nothing
                        end else begin
                            rotated = rotatedTemp - 1;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx][ny+2] = 0;
                            temp_grid[nx][ny+3] = 0;
                            temp_grid[nx-1][ny+1] = 3;
                            temp_grid[nx+1][ny+1] = 3;
                            temp_grid[nx+2][ny+1] = 3;
                            tx = nx - 1;
                            ty = ny + 1;
                        end
                    end
                end
                        
                // s block
                else if (grid[nx][ny] == 4) begin
                    if (rotatedTemp[0] == 0) begin
                        if (ny >= 21 || grid[nx][ny-1] == 1 || grid[nx+1][ny+1] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp + 1;
                            temp_grid[nx+1][ny-1] = 0;
                            temp_grid[nx+2][ny-1] = 0;
                            temp_grid[nx][ny-1] = 4;
                            temp_grid[nx+1][ny+1] = 4;
                            tx = nx;
                            ty = ny - 1;
                        end
                    end else begin
                        if (nx >= 8 || grid[nx+1][ny-1] == 1 || grid[nx+2][ny-1] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp - 1;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx+1][ny+2] = 0;
                            temp_grid[nx+1][ny] = 4;
                            temp_grid[nx+2][ny] = 4;
                            tx = nx;
                            ty = ny + 1;
                        end
                    end
                end
                
                // z block
                else if (grid[nx][ny] == 5) begin
                    if (rotatedTemp[0] == 0) begin
                        if (ny >= 21 || grid[nx+2][ny] == 1 || grid[nx+1][ny+2] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp + 1;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx+1][ny] = 0;
                            temp_grid[nx+2][ny] = 5;
                            temp_grid[nx+1][ny+2] = 5;
                            tx = nx + 1;
                            ty = ny + 1;
                        end
                    end else begin
                        if (nx <= 0 || grid[nx-1][ny-1] == 1 || grid[nx][ny-1] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp - 1;
                            temp_grid[nx][ny+1] = 0;
                            temp_grid[nx+1][ny-1] = 0;
                            temp_grid[nx-1][ny-1] = 5;
                            temp_grid[nx][ny-1] = 5;
                            tx = nx - 1;
                            ty = ny - 1;
                        end
                    end
                end
                
                // l block   
                else if (grid[nx][ny] == 6) begin
                    if (rotatedTemp == 0) begin
                        if (ny >= 21 || grid[nx+1][ny-1] == 1 || grid[nx+1][ny+1] == 1 || grid[nx+2][ny+1] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp + 1;
                            temp_grid[nx+1][ny-1] = 6;
                            temp_grid[nx+1][ny+1] = 6;
                            temp_grid[nx+2][ny+1] = 6;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx+2][ny] = 0;
                            temp_grid[nx+2][ny-1] = 0;
                            tx = nx + 1;
                            ty = ny - 1;
                        end
                    end else if (rotatedTemp == 1) begin
                        if (nx <= 0 || grid[nx-1][ny+1] == 1 || grid[nx-1][ny+2] == 1 || grid[nx+1][ny+1] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp + 1;
                            temp_grid[nx-1][ny+1] = 6;
                            temp_grid[nx-1][ny+2] = 6;
                            temp_grid[nx+1][ny+1] = 6;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx][ny+2] = 0;
                            temp_grid[nx+1][ny+2] = 0;
                            tx = nx - 1;
                            ty = ny + 1;
                        end
                    end else if (rotatedTemp == 2) begin
                        if (ny <= 0 || grid[nx][ny-1] == 1 || grid[nx+1][ny-1] == 1 || grid[nx+1][ny+1] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp + 1;
                            temp_grid[nx][ny-1] = 6;
                            temp_grid[nx+1][ny-1] = 6;
                            temp_grid[nx+1][ny+1] = 6;
                            temp_grid[nx][ny+1] = 0;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx+2][ny] = 0;
                            tx = nx;
                            ty = ny - 1;
                        end
                    end else begin
                        if (nx >= 8 || grid[nx+2][ny] == 1 || grid[nx+2][ny+1] == 1 || grid[nx][ny+1] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp - 3;
                            temp_grid[nx+2][ny] = 6;
                            temp_grid[nx+2][ny+1] = 6;
                            temp_grid[nx][ny+1] = 6;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx+1][ny] = 0;
                            temp_grid[nx+1][ny+2] = 0;
                            tx = nx;
                            ty = ny + 1;
                        end
                    end
                end
                
                // j block
                else if (grid[nx][ny] == 7) begin
                    if (rotatedTemp == 0) begin
                        if (ny >= 20 || grid[nx+1][ny] == 1 || grid[nx+2][ny] == 1 || grid[nx+1][ny+2] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp + 1;
                            temp_grid[nx+1][ny] = 7;
                            temp_grid[nx+2][ny] = 7;
                            temp_grid[nx+1][ny+2] = 7;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx][ny+1] = 0;
                            temp_grid[nx+2][ny+1] = 0;
                            tx = nx + 1;
                            ty = ny;
                        end
                    end else if (rotatedTemp == 1) begin
                        if (nx <= 0 || grid[nx-1][ny+1] == 1 || grid[nx+1][ny+1] == 1 || grid[nx+1][ny+2] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp + 1;
                            temp_grid[nx-1][ny+1] = 7;
                            temp_grid[nx+1][ny+1] = 7;
                            temp_grid[nx+1][ny+2] = 7;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx+1][ny] = 0;
                            temp_grid[nx][ny+2] = 0;
                            tx = nx - 1;
                            ty = ny + 1;
                        end
                    end else if (rotatedTemp == 2) begin
                        if (ny <= 0 || grid[nx][ny+1] == 1 || grid[nx+1][ny+1] == 1 || grid[nx+1][ny-1] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp + 1;
                            temp_grid[nx][ny+1] = 7;
                            temp_grid[nx+1][ny+1] = 7;
                            temp_grid[nx+1][ny-1] = 7;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx+2][ny] = 0;
                            temp_grid[nx+2][ny+1] = 0;
                            tx = nx;
                            ty = ny + 1;
                        end
                    end else begin
                        if (nx >= 8 || grid[nx][ny-1] == 1 || grid[nx][ny-2] == 1 || grid[nx+2][ny-1] == 1) begin
                            // do nothing
                        end else begin
                            rotated = rotatedTemp - 3;
                            temp_grid[nx][ny-1] = 7;
                            temp_grid[nx][ny-2] = 7;
                            temp_grid[nx+2][ny-1] = 7;
                            temp_grid[nx][ny] = 0;
                            temp_grid[nx+1][ny] = 0;
                            temp_grid[nx+1][ny-2] = 0;
                            tx = nx;
                            ty = ny - 2;
                        end
                    end 
                end
                
                // t block
//                else if (grid[nx][ny] == 8) begin
//                    if (rotated == 0) begin
//                        if (ny >= 21 || grid[nx+1][ny+1] == 1) begin
//                            // do nothing
//                        end else begin
//                            rotated += 1;
//                            temp_grid[nx+1][ny+1] = 8;
//                            temp_grid[nx][ny] = 0;
//                        end
//                    end else if (rotated == 1) begin
//                        if (nx <= 0 || grid[nx-1][ny+1] == 1) begin
//                            // do nothing
//                        end else begin
//                            rotated += 1;
//                            temp_grid[nx-1][ny+1] = 8;
//                            temp_grid[nx][ny] = 0;
//                        end
//                    end else if (rotated == 2) begin
//                        if (ny <= 0 || grid[nx+1][ny-1] == 1) begin
//                            // do nothing
//                        end else begin
//                            rotated += 1;
//                            temp_grid[nx+1][ny-1] = 8;
//                            temp_grid[nx+2][ny] = 0;
//                        end
//                    end else begin
//                        if (nx >= 8 || grid[nx+1][ny+1] == 1) begin
//                            // do nothing
//                        end else begin
//                            rotated -= 3;
//                            temp_grid[nx+2][ny] = 8;
//                            temp_grid[nx+1][ny+1] = 0;
//                        end
//                    end
//                end
                
            // a key
            end else if (keycode == 8'h04) begin
                randTemp = rand_num + 2;
                validToMove = 1;
                for (int i = 0; i < 10; i++) begin
                    for (int j = 0; j < 22; j++) begin
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
                    tx = nx - 1;
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
                dropItTemp = 1;
                
            // d key
            end else if (keycode == 8'h07) begin
                randTemp = rand_num + 3;
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
                    tx = nx + 1;
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
        

    always_ff @(posedge frame_clk) // make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset)
        begin 
            // set grid to empty
            for (int i = 0; i < 10; i++) begin
                for (int j = 0; j < 22; j++) begin
                    grid[i][j] <= 0;
                end
            end
            
            // set variables
            prev_keycode <= 8'h00;
            timer <= 0;
            rotateTimer <= 0;
            
            rand_num <= 5;
            validToDrop <= 1;
            blankBoard <= 1;
            score <= 0;
            update <= 30;
            rotatedTemp <= 0;
            dropIt <= 0;

        end else begin
            // update variables
            grid <= temp_grid;
            rand_num <= randTemp;
            validToDrop <= validToDropTemp;
            blankBoard <= blankBoardTemp;
            nx <= tx;
            ny <= ty;
            rotatedTemp <= rotated;
            score <= scoreTemp;
            update <= updateTemp;
            dropIt <= dropItTemp;
            
            // update more variables
            prev_keycode <= keycode;
            
            timer <= timer + 1;
            if (timer > update) begin
                timer <= 0;
            end
        end
    end
      
endmodule
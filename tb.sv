`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2024 02:36:16 PM
// Design Name: 
// Module Name: testbench
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


module testbench();

timeunit 1ns;
timeprecision 1ns;

 logic clk;
// logic reset;
// logic run_i;
// logic continue_i;
// logic [15:0] sw_i;

// logic [15:0] led_o;
// logic [7:0]  hex_seg_left;
// logic [3:0]  hex_grid_left;
// logic [7:0]  hex_seg_right;
// logic [3:0]  hex_grid_right;

logic        Reset;
logic [7:0]  keycode;
logic [2:0]     grid[10][22];

always begin: CLOCK_GENERATION
    #1 clk = ~clk;
end

initial begin: CLOCK_INITIALIZATION
    clk = 1;
end

ball test(.Reset(Reset), .frame_clk(clk), .keycode(keycode), .grid(grid));

initial begin: TEST
    
    Reset = 1;
    keycode <= 0;
    repeat(5) @(posedge clk);
    Reset <= 0;
    
    repeat(600) @(posedge clk);
    keycode <= 8'h04;
    repeat(5) @(posedge clk);
    keycode <= 0;
    repeat(50) @(posedge clk);
    keycode <= 8'h04;
    repeat(5) @(posedge clk);
    keycode <= 0;
    repeat(400) @(posedge clk);
    keycode <= 8'h04;
    repeat(5) @(posedge clk);
    keycode <= 8'h00;
    repeat(50) @(posedge clk);
    keycode <= 8'h04;
    repeat(5) @(posedge clk);
    keycode <= 8'h00;
    repeat(50) @(posedge clk);
    keycode <= 8'h04;
    repeat(5) @(posedge clk);
    keycode <= 8'h00;
    repeat(50) @(posedge clk);
    keycode <= 8'h04;
    repeat(5) @(posedge clk);
    keycode <= 8'h00;
    
    repeat(300) @(posedge clk);
    keycode <= 8'h07;
    repeat(5) @(posedge clk);
    keycode <= 0;
    repeat(50) @(posedge clk);
    keycode <= 8'h07;
    repeat(5) @(posedge clk);
    keycode <= 0;
    repeat(300) @(posedge clk);
    keycode <= 8'h07;
    repeat(5) @(posedge clk);
    keycode <= 8'h00;
    repeat(10) @(posedge clk);
    keycode <= 8'h07;
    repeat(5) @(posedge clk);
    keycode <= 8'h00;
    repeat(10) @(posedge clk);
    keycode <= 8'h07;
    repeat(5) @(posedge clk);
    keycode <= 8'h00;
    repeat(10) @(posedge clk);
    keycode <= 8'h07;
    repeat(5) @(posedge clk);
    keycode <= 8'h00;
    repeat(10) @(posedge clk);
    keycode <= 8'h07;
    repeat(5) @(posedge clk);
    keycode <= 8'h00;
    
end

endmodule
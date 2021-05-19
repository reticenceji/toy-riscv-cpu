`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2021 05:49:02 PM
// Design Name: 
// Module Name: cpusim
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


module cpusim();

    reg clk,rstn;
    reg [15:0] SW;
    reg [4:0] BTN_y;

    initial begin
        rstn = 0;
        BTN_y[4:0] = 1;
        SW[15:0] = 0;
        #1020;
        rstn = 1;      
        BTN_y[4:0] = 0;
        #20;
    end
    
    always begin
        clk = 1;
        #10;
        clk = 0;
        #10;
    end
    CPU_SOC cpu(
        .clk_100mhz(clk),
        .RSTN(rstn),
        .BTN_y(BTN_y),
        .SW(SW)
        );
endmodule

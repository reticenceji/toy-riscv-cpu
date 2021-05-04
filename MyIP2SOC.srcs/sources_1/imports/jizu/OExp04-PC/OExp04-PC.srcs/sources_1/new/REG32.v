`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2021 09:09:17 AM
// Design Name: 
// Module Name: REG32
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


module REG32(
    input clk,
    input rst,
    input CE,   //enable
    input [31:0] D,
    output reg [31:0] Q
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst==1) Q<=0;
        else if (CE==1) Q<=D;
    end
        
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2021 03:05:06 PM
// Design Name: 
// Module Name: RV_Int
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


module RV_Int(
    input clk,
    input reset,
    input INT,          // 这是电平信号，不要重复响应
    input ecall,
    input mret,
    input ill_instr,
    input [31:0] pc_next,

    output [31:0] pc
    );

    reg [31:0] reg_mepc,reg_pc;
    reg mstatus;        // 仅标记现在是否处于异常处理程序中
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_mepc <= 0;    
            mstatus <= 0;
        end 
        else begin
            if (mret) begin
                reg_mepc <= reg_mepc;
                mstatus <= 0;
            end 
            else begin
                if (mstatus==0) begin
                    reg_mepc <= pc_next;
                    mstatus <= (INT == 1 || ecall == 1 || ill_instr == 1)?1:0; 
                end 
                else begin
                    reg_mepc <= reg_mepc;
                    mstatus <= 1;
                end
            end
        end
    end
    
    // TODO 我发现这个应该是一个逻辑电路，但是我想不到一个好一点的办法来写
    assign pc = (reset == 1)    ?   0           : 
                (mret == 1)     ?   reg_mepc    :
                (mstatus ==1)   ?   pc_next     :
                (INT == 1)      ?   32'hc       :
                (ecall == 1)    ?   32'h8       :
                (ill_instr == 1)?   32'h4       :
                pc_next;    
endmodule

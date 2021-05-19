`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2021 09:14:30 AM
// Design Name: 
// Module Name: ImmGen
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


module ImmGen(
    input wire [1:0] ImmSel,
    input wire [31:0] inst_field,
    output reg [31:0] Imm_out
    );
    
    always @(*) begin
        case (ImmSel)
            2'b00: Imm_out = {{20{inst_field[31]}},inst_field[31:20]}; //addi\lw(I)
            2'b01: Imm_out = {{20{inst_field[31]}},inst_field[31:25],inst_field[11:7]}; //sw(s)
            2'b10: Imm_out = {{19{inst_field[31]}},inst_field[31],inst_field[7],inst_field[30:25],inst_field[11:8],1'b0};    //beq(b)
            2'b11: Imm_out = {{11{inst_field[31]}},inst_field[31],inst_field[19:12],inst_field[20],inst_field[30:21],1'b0};    //jal(j)
        endcase
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2021 04:03:12 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALU_operation,
    output reg [31:0] res,
    output reg zero
    );
    
    always @(*) begin
        case (ALU_operation[2:0]) 
        3'b000: 
            res = A & B;
        3'b001:
            res = A | B;
        3'b010:
            res = A + B;
        3'b110:
            res = A - B; 
        3'b111:
            res = (A<B)?1:0;
        3'b100: 
            res = ~(A | B);
        3'b101:
            res = A >> B[4:0];
        3'b011:
            res = A ^ B;     
        endcase
        zero = res==0?1:0;
    end
endmodule

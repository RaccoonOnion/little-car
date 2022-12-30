`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/09 23:46:33
// Design Name: 
// Module Name: edge_detector
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


module edge_detector(
    input clk,
    input rst_n,
    input signal,
    output raising_edge_detect, falling_edge_detect, 
    output double_edge_detect
    );

reg q0, q1;
assign raising_edge_detect = q0 & (~q1);
assign falling_edge_detect = ~q0 & q1;
assign double_edge_detect = q0 ^ q1;

always@(posedge clk, negedge rst_n)
begin
    if(!rst_n)
    begin
        q0 <= 0;
        q1 <= 0;
    end
    else
    begin
        q1 <= q0;
        q0 <= signal;
    end
end
endmodule

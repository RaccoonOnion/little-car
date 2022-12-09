`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/09 14:41:50
// Design Name: 
// Module Name: power_on_judge
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


module power_on_judge(
    input clk,
    input rst_n,
    input power_on_signal,
    output reg power_on
    );
    reg[26:0] cnt;
    
    always @(posedge clk, negedge rst_n) begin
        if(~rst_n)
        begin
            power_on <= 1'b0;
            cnt <= 27'b0;
        end
        else begin
            if(power_on_signal) cnt <= cnt + 1'b1;
            else cnt <= 27'b0;
            if(cnt >= 27'b101111101011110000100000000) power_on <= 1'b1;
            else power_on <= 1'b0;
        end
    end
    
endmodule

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


module no_barrier_detect(
    input clk,
    input rst_n,
    input start,
    input power_off_signal,
    output reg power_off
    );
    reg[5:0] cnt;
    
    always @(posedge clk, negedge rst_n) begin
        if(~rst_n || ~start)
        begin
            power_off <= 1'b0;
            cnt <= 6'b0;
        end
        else begin
            if(~power_off_signal) cnt <= cnt + 1'b1;
            else cnt <= 6'b0;
            if(cnt >= 6'd49) power_off <= 1'b1;
            else power_off <= 1'b0;
        end
    end
    
endmodule

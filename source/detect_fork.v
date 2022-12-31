`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/30 17:39:05
// Design Name: 
// Module Name: detect_fork
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


module detect_fork(
    input clk,
    input rst_n,
    input [3:0] detector_signal,
    output reg detect_fork
    );
     always @(posedge clk, negedge rst_n) 
     begin
        if(~rst_n)
        begin
            detect_fork <= 1'b0;
        end
        else
        begin
        casex (detector_signal)
            4'b0x01, 4'b0x10, 4'b1x00, 4'b0x00:
            begin
            detect_fork <= 1'b1;
            end
            default:
            begin
            detect_fork <= 1'b0;
            end
        endcase
        end
     end
endmodule

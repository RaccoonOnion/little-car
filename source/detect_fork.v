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
        case (detector_signal)
            4'b0001, 4'b0010, 4'b1000, 4'b0000:
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

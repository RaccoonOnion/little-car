`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/30 17:47:59
// Design Name: 
// Module Name: auto_turning
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


module auto_turning(
    input  clk_ms,
    input  rst_n,
    input is_turning,
    output reg turning,
    output reg finish_turning
    );
    reg[9:0] cnt;
    always @ (posedge clk_ms or negedge rst_n) 
        begin
            if(~rst_n || ~is_turning) 
            begin
                turning <= 1'b0; 
                cnt <= 10'b0;
                finish_turning <= 1'b0; 
            end
            else 
            begin
                if(cnt <= 10'd750)
                begin
                    cnt <= cnt + 1'b1;
                    turning <= 1'b1; 
                end
                else
                    turning <= 1'b0;
                    finish_turning <= 1'b1;  
            end
        end
endmodule

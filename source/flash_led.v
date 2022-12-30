`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/30 16:14:18
// Design Name: 
// Module Name: flash_led
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


module flash_led(
    input clk,
    input rst_n,
    output reg flash_led
    );
    reg [6:0] cnt;
    always @(posedge clk, negedge rst_n) begin
        if(~rst_n)
        begin
            flash_led <= 1'b0;
            cnt <= 7'b0;
        end
        else if (cnt == 7'd99)
        begin
        cnt <= 7'b0;
        flash_led <= ~flash_led;
        end
        else begin
            cnt <= cnt + 7'b1;
        end
    end
    
endmodule

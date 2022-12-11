`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/11 14:19:34
// Design Name: 
// Module Name: clk_div
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


module clk_div(
    input  clk,
    input  rst_n,
    output reg  clk_ms, clk_20ms, clk_100ms, clk_s
    );
    parameter period_ms = 100000, period_20ms = 2000000, period_100ms = 10000000, period_s = 100000000;  
     
    reg [31:0]  cnt_ms;
    reg [31:0]  cnt_20ms;
    reg [31:0]  cnt_100ms;
    reg [31:0]  cnt_s;
     
    always @ (posedge clk or negedge rst_n) 
    begin
        if(~rst_n) 
        begin
            cnt_ms <= 0;
            clk_ms <= 0;   
        end
        else 
        begin
            if(cnt_ms == ((period_ms >> 1) - 1)) begin
              clk_ms <= ~clk_ms;
              cnt_ms <= 0;
            end
        else
            cnt_ms <= cnt_ms + 1;
        end
    end
    
    always @ (posedge clk or negedge rst_n) 
        begin
            if(~rst_n) 
            begin
                cnt_20ms <= 0;
                clk_20ms <= 0;   
            end
            else 
            begin
                if(cnt_20ms == ((period_20ms >> 1) - 1)) begin
                  clk_20ms <= ~clk_20ms;
                  cnt_20ms <= 0;
                end
            else
                cnt_20ms <= cnt_20ms + 1;
            end
        end
        
    always @ (posedge clk or negedge rst_n) 
        begin
            if(~rst_n) 
            begin
                cnt_s <= 0;
                clk_s <= 0;   
            end
            else 
            begin
                if(cnt_s == ((period_s >> 1) - 1)) begin
                  clk_s <= ~clk_s;
                  cnt_s <= 0;
                end
            else
                cnt_s <= cnt_s + 1;
            end
        end
        
     always @ (posedge clk or negedge rst_n) 
            begin
                if(~rst_n) 
                begin
                    cnt_100ms <= 0;
                    clk_100ms <= 0;   
                end
                else 
                begin
                    if(cnt_100ms == ((period_100ms >> 1) - 1)) begin
                      clk_100ms <= ~clk_100ms;
                      cnt_100ms <= 0;
                    end
                else
                    cnt_100ms <= cnt_100ms + 1;
                end
            end
endmodule

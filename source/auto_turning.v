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
    input [3:0] state,
    input  left_right,
    input  turn_around,
    output reg turn_left,
    output reg turn_right,
    output reg finish_turning
    );
    reg[11:0] cnt;
    reg is_turning;
    
    always @(*)
    begin
        if(state == 4'b0111 || state == 4'b1001) is_turning = 1'b1;
        else is_turning = 1'b0;
    end
    
    always @ (posedge clk_ms or negedge rst_n) 
        begin
            if(~rst_n) 
            begin
                turn_left <= 1'b0;
                turn_right <= 1'b0;
                cnt <= 12'b0;
                finish_turning <= 1'b0; 
            end
            else if(~is_turning) 
                        begin
                            turn_left <= 1'b0;
                            turn_right <= 1'b0;
                            cnt <= 12'b0;
                            finish_turning <= 1'b0; 
                        end
            else if (is_turning)
                begin
                    if(turn_around)
                    begin
                        if(cnt <= 12'd2000)
                        begin
                            cnt <= cnt + 1'b1;
                            if(cnt <= 12'd1700)
                            begin        
                                if(~left_right) begin
                                    turn_left <= 1'b1;
                                    turn_right <= 1'b0;
                                end
                                else begin
                                    turn_left <= 1'b0;
                                    turn_right <= 1'b1;
                                end
                            end
                            else 
                            begin
                                turn_left <= 1'b0;
                                turn_right <= 1'b0;
                            end
                        end
                        else
                        begin
                            finish_turning <= 1'b1; 
                        end               
                    end
                    else if(~turn_around)
                    begin
                        if(cnt <= 12'd1000)
                        begin
                            cnt <= cnt + 1'b1;
                            if(cnt <= 12'd750)
                            begin        
                                if(~left_right) begin
                                    turn_left <= 1'b1;
                                    turn_right <= 1'b0;
                                end
                                else begin
                                    turn_left <= 1'b0;
                                    turn_right <= 1'b1;
                                end
                            end
                            else 
                            begin
                                turn_left <= 1'b0;
                                turn_right <= 1'b0;
                            end
                        end
                        else
                        begin
                            finish_turning <= 1'b1; 
                        end
                    end           
            end
        end
endmodule

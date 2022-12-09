`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/26 22:10:40
// Design Name: 
// Module Name: dev_top
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


module SimulatedDevice(
    input sys_clk, //bind to P17 pin (100MHz system clock)
    input rx, //bind to N5 pin
    output tx, //bind to T4 pin
    
    input rst_n,
    input power_on_signal,
    input power_off_signal,
    output reg poweron,
    output reg poweroff,
    
    input turn_left_signal,
    input turn_right_signal,
    input move_forward_signal,
    input move_backward_signal,
    input place_barrier_signal,
    input destroy_barrier_signal,
    output front_detector,
    output back_detector,
    output left_detector,
    output right_detector
    );
    reg[3:0] state,next_state;
    reg turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier;
    parameter power_off = 4'b0000, power_on = 4'b0001;
    
    always @(posedge sys_clk, negedge rst_n) begin
        if(~rst_n)
        begin
            state <= power_off;
         end
         else
            state <= next_state;
    end
    
//    state,turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier, power_on_signal,power_off_signal
    always @(state,power_on_signal,power_off_signal) begin
        case(state)
        power_off: if(power_on_signal) next_state <= power_on; else next_state <= power_off;
        power_on: 
            if(power_off_signal) next_state <= power_off;
            else begin
//                {next_state,turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= {power_on,turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal,place_barrier_signal,destroy_barrier_signal};
                   next_state <= power_on;
            end
        endcase
    end
    
    always @(posedge sys_clk, negedge rst_n) begin
            if(~rst_n)
            begin
                turn_left <= 1'b0;
                turn_right <= 1'b0;
                move_forward <= 1'b0;
                move_backward <= 1'b0;
                place_barrier <= 1'b0;
                destroy_barrier <= 1'b0;
             end
             else begin
             case(state)
                power_on: {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= {turn_left_signal,turn_right_signal,move_forward_signal,move_backward_signal,place_barrier_signal,destroy_barrier_signal};
                power_off: {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= 8'b0;    
             endcase
             end
        end
    
    
    always@(negedge sys_clk) begin
        if(state == power_on) begin
            poweron <= 1'b1;
            poweroff <= 1'b0;
        end
        if(state == power_off) begin
            poweron <= 1'b0;
            poweroff <= 1'b1;
        end
    end
    
    wire [7:0] in = {2'b10, destroy_barrier, place_barrier, turn_right, turn_left, move_backward, move_forward};
//    wire [7:0] in = {2'b10, destroy_barrier_signal, place_barrier_signal, turn_right_signal, turn_left_signal, move_backward_signal, move_forward_signal};
    wire [7:0] rec;
    assign front_detector = rec[0];
    assign back_detector = rec[1];
    assign left_detector = rec[2];
    assign right_detector = rec[3];
    
    uart_top md(.clk(sys_clk), .rst(0), .data_in(in), .data_rec(rec), .rxd(rx), .txd(tx));
    
endmodule

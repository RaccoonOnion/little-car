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
    // 1. original (11)
    input sys_clk, // (100MHz system clock)
    input rx,
    input turn_left_signal,
    input turn_right_signal,
    input place_barrier_signal,
    input destroy_barrier_signal,
    
    output tx,
    output front_detector,
    output back_detector,
    output left_detector,
    output right_detector,
    // -------------------------------------------------------------
    
    // 2. new (11 + 4)
    input rst, // reset
    input power_on_signal, 
    input power_off_signal,
    input manual_driving_signal,
    input throttle_signal,
    input clutch_signal,
    input brake_signal,
    input reverse_signal,
    
    output reg [3:0] state_led,
    output reg left_turn_led,
    output reg right_turn_led,
    output reg reverse_led,
    output [7:0] seg_en,
    output [7:0] seg_out0,
    output [7:0] seg_out1
    );

    reg[3:0] state, next_state;
    reg turn_left, turn_right, move_forward, move_backward, place_barrier, destroy_barrier;
    wire power_on_1sec; // power on for 1s
    wire reverse_change; // switch reverse without clutch
    wire clk_ms, clk_20ms, clk_100ms, clk_s; // clock division
    
    parameter power_off = 4'b0000, power_on = 4'b0001, not_starting = 4'b0010, starting = 4'b0011, moving = 4'b0100; // more states TODO!!
    
    always @(*) begin //  Next State Combinational Logic TODO!! add power_off
        case(state)
        power_off: // power off state
        begin
            if(power_on_1sec) next_state = power_on; else next_state = power_off;
        end
        power_on: // power on state
        begin
            if(power_off_signal) next_state = power_off;
            else if(manual_driving_signal) next_state = not_starting;
            else next_state = power_on;
        end
        not_starting: // not starting state
        begin
            casex ({throttle_signal, brake_signal, clutch_signal})
                3'b101: next_state = starting;
                3'b100: next_state = power_off;
                default: next_state = not_starting;
            endcase
        end
        
        starting: // starting state
        begin
            casex ({throttle_signal, brake_signal, clutch_signal})
                3'bx1x: next_state = not_starting;
                3'b100: next_state = moving;
                default: next_state = starting;
            endcase
        end
        moving: // moving state
        begin
        if (reverse_change & ~clutch_signal)
            next_state = power_off;
        else
            begin
            casex ({throttle_signal, brake_signal, clutch_signal})
                3'bx1x: next_state = not_starting;
                3'bx01, 3'b00x: next_state = starting;
                default: next_state = moving;
            endcase
            end
        end
        
        default: next_state = next_state; // TODO!!
        endcase
    end

    always @(posedge sys_clk, negedge rst) // State Register
    begin
        if(~rst)
        begin
            state <= power_off;
            // output set to zero TODO!!

            turn_left <= 1'b0;
            turn_right <= 1'b0;
            move_forward <= 1'b0;
            move_backward <= 1'b0;
            place_barrier <= 1'b0;
            destroy_barrier <= 1'b0;
        end
        else 
        begin
            state <= next_state;
            case(state)
            power_on: {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= 8'b0;
            power_off: {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= 8'b0;
            not_starting: {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= 8'b0;
            starting: {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= 8'b0;
           
            moving: 
            begin
            if (!reverse_signal)
                {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= {turn_left_signal,turn_right_signal,1'b1,1'b0,place_barrier_signal,destroy_barrier_signal};
            else
                {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= {turn_left_signal,turn_right_signal,1'b0,1'b1,place_barrier_signal,destroy_barrier_signal}; 
            end
            endcase
        end
    end
    
    always@(*) // Output Combinational Logic
    begin
        state_led = state;
        left_turn_led = turn_left_signal;  // turn led to improve
        right_turn_led = turn_right_signal;
        reverse_led = reverse_signal;
        // Milage led output TODO!!
    end
    
    
    wire [7:0] in = {2'b10, destroy_barrier, place_barrier, turn_right, turn_left, move_backward, move_forward};

    wire [7:0] rec;
    assign front_detector = rec[0];
    assign back_detector = rec[1];
    assign left_detector = rec[2];
    assign right_detector = rec[3];
    
    seg s(clk_ms, clk_100ms, rst, state, seg_en, seg_out0, seg_out1); //seg 
    clk_div cd( .clk(sys_clk), .rst_n(rst), .clk_ms(clk_ms), .clk_20ms(clk_20ms), .clk_100ms(clk_100ms), .clk_s(clk_s)); // clock division
    power_on_judge poj(clk_20ms, rst, power_on_signal, power_on_1sec); // power on 1 sec
    edge_detector ed1(.clk(sys_clk), .rst_n(rst), .signal(reverse_signal), .double_edge_detect(reverse_change) );// detect reverse change
    
    uart_top md(.clk(sys_clk), .rst(0), .data_in(in), .data_rec(rec), .rxd(rx), .txd(tx)); // uart top
   
endmodule

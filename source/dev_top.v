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
    
    input rst_n, // reset
    input power_on_signal, power_off_signal,
    input manual_driving_signal,
    input throttle_signal, clutch_signal, // brake, reverse TODO!!
    
    output reg [3:0] state_led,
    
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

    reg[3:0] state, next_state;
    reg turn_left, turn_right, move_forward, move_backward, place_barrier, destroy_barrier; // remove some TODO!!
    wire power_on_1sec; // power on for 1s
    wire clk_ms, clk_20ms, clk_16x, clk_x; // clock division

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
            if(clutch_signal)
            begin
                if(throttle_signal) next_state = starting;
                else next_state = not_starting;
            end
            else 
            begin
                if(throttle_signal) next_state = power_off;
                else next_state = not_starting;
            end
        end
        starting: // starting state
        begin
            if(throttle_signal)
            begin
                if(~clutch_signal) next_state = moving;
                else next_state = starting;
            end 
            else next_state = starting;  
        end
        moving: // moving state
        begin
            if(~throttle_signal || clutch_signal) next_state = starting;
            else next_state = moving;
        end

        default: next_state = next_state; // TODO!!

        endcase
    end
    
    // always @(posedge sys_clk, negedge rst_n) // State Register
    // begin 
    //     if(~rst_n)
    //     begin
    //         state <= power_off;
    //         // output set to zero TODO!!
    //     end
    //     else
    //         state <= next_state;
    // end

    always @(posedge sys_clk, negedge rst_n) // State Register
    begin
        if(~rst_n)
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
            // reverse function TODO!!
            moving: {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= {turn_left_signal,turn_right_signal,1'b1,1'b0,place_barrier_signal,destroy_barrier_signal};    
            endcase
        end
    end
    
    always@(*) // Output Combinational Logic
    begin
        state_led = state;
        // case(state)
        // power_off: state_led <= power_off;
        // power_on: state_led <= power_on;
        // not_starting: state_led <= not_starting;
        // starting: state_led <= starting;
        // moving: state_led <= moving;
        // default: ;
        // endcase
    end
    
    wire [7:0] in = {2'b10, destroy_barrier, place_barrier, turn_right, turn_left, move_backward, move_forward};

    wire [7:0] rec;
    assign front_detector = rec[0];
    assign back_detector = rec[1];
    assign left_detector = rec[2];
    assign right_detector = rec[3];
    
    power_on_judge poj(clk_20ms, rst_n, power_on_signal, power_on_1sec); // power on 1 sec
    
    uart_top md(.clk(sys_clk), .rst(0), .data_in(in), .data_rec(rec), .rxd(rx), .txd(tx)); // uart top

    divclk my_divclk( // clock division
        .clk(sys_clk),
        .clk_ms(clk_ms),
        .btnclk(clk_20ms),
        .clk_16x(clk_16x),
        .clk_x(clk_x)
    );
    
endmodule

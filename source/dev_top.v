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
    input semi_manual_driving_signal,
    input throttle_signal,
    input clutch_signal,
    input brake_signal,
    input reverse_signal,
    input move_forward_signal,
    
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
    wire reverse_change; // switch reverse
    wire clk_ms, clk_20ms, clk_100ms, clk_s; // clock division
    wire flash_led; // flashing led light
    wire fork_here; // fork detecting signal
    wire detect_fork_appear; // detecting fork appearance
    wire detect_fork_disappear; // detecting fork disappearing
    wire finish_turning; // finish turning signal 
    reg is_turning, left_right; // is turning signal and turning direction signal
    wire turn_l,turn_r; // left, right turning signal
    reg just_turned; // state control signal
    // barrier detection signals
    wire left_detect_on_1s;
    wire right_detect_on_1s;
    wire left_detect_off_1s;
    wire right_detect_off_1s;
    wire front_detect_on_005s;
    wire front_detect_off_1s;
    // more turning control signals
    reg turn_around;
    reg start_detect;
    
    parameter power_off = 4'b0000, power_on = 4'b0001, not_starting = 4'b0010, starting = 4'b0011, moving = 4'b0100, sauto_moving = 4'b0101, sauto_waiting = 4'b0110, sauto_turning = 4'b0111, sauto_self_checking = 4'b1000, sauto_self_turning = 4'b1001;// state parameters
    
    always @(*) begin //  Next State Combinational Logic
        if(~rst)
        begin
            next_state = power_off;
            turn_around = 1'b0;
            start_detect = 1'b0;
            just_turned = 1'b0;
        end
        else
        begin
        case(state)
        power_off: // power off state
        begin
            if(power_on_1sec)
            begin
                next_state = power_on; 
            end
            else 
            next_state = power_off;
        end
        power_on: // power on state
        begin
            if(power_off_signal) next_state = power_off;
            else if(manual_driving_signal) next_state = not_starting;
            else if(semi_manual_driving_signal) next_state = sauto_moving;
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
        
        sauto_moving: // semi-auto moving state
        begin
            turn_around = 1'b0;
            if(detect_fork_disappear)
            begin
                just_turned = 1'b0;
            end
            else if (~just_turned && detect_fork_appear)
            begin
                next_state = sauto_waiting;
            end
            else if (~detect_fork_appear && front_detect_on_005s)
            begin
                next_state = sauto_self_checking;
            end
            else
            begin
                next_state = sauto_moving;
            end
        end
        
        sauto_waiting: // semi-auto waiting state
        begin
            if (move_forward_signal)
            begin
                next_state = sauto_moving;
            end
            else if(turn_left_signal)
            begin
                left_right = 1'b0;
                next_state = sauto_turning;
            end
            else if(turn_right_signal)
            begin
                left_right = 1'b1;
                next_state = sauto_turning; 
            end
            else if(power_off_signal)
            begin
                left_right = 1'b0;
                turn_around = 1'b1;
                next_state = sauto_turning; 
            end
            else
            begin
                next_state = sauto_waiting;
            end
        end
        
        sauto_turning: // semi-auto turning state
        begin       
            if (finish_turning)
            begin
                 next_state = sauto_moving;
                 just_turned = 1'b1;
            end
            else
            begin
                next_state = sauto_turning;
            end
        end
        
        sauto_self_checking: // semi-auto self checking state
        begin
            if (left_detect_off_1s && right_detect_on_1s)
            begin
                start_detect = 1'b0;
                left_right = 1'b0;
                next_state = sauto_self_turning;
            end
            else if (left_detect_on_1s && right_detect_off_1s)
            begin
                start_detect = 1'b0;
                left_right = 1'b1;
                next_state = sauto_self_turning;
            end
            else if (left_detect_off_1s && right_detect_off_1s)
            begin
                start_detect = 1'b0;
                next_state = sauto_moving;
            end
            else if (left_detect_on_1s && right_detect_on_1s) // dead end
            begin
                start_detect = 1'b0;
                left_right = 1'b0;
                turn_around = 1'b1;
                next_state = sauto_self_turning;                
            end
            else if (~(left_detect_on_1s || left_detect_off_1s) || ~(right_detect_on_1s || right_detect_off_1s))
            begin
                start_detect = 1'b1;
                next_state = sauto_self_checking; 
            end
            else
            begin
                start_detect = 1'b0;
                next_state = sauto_self_checking;
            end
        end
        
        sauto_self_turning: // semi-auto self turning state
        begin
            if (finish_turning && front_detect_off_1s)
            begin
                start_detect = 1'b0;
                next_state = sauto_moving;
            end
            else
            begin
                start_detect = 1'b1;
                next_state = sauto_self_turning;
            end
        end
        
        default: next_state = next_state; 
        endcase
        end
    end

    always @(posedge sys_clk, negedge rst) // State Register
    begin
        if(~rst)
        begin
            state <= power_off;
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
            // case selection for states   
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

            sauto_moving:
            begin
                {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= {1'b0,1'b0,1'b1,1'b0,1'b0,1'b0};
            end
            
            sauto_waiting:
            begin
                {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
            end
            
            sauto_turning, sauto_self_turning:
            begin
                {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= {turn_l, turn_r, 1'b0,1'b0,1'b0,1'b0};
            end
            
            sauto_self_checking:
            begin
                {turn_left,turn_right,move_forward,move_backward,place_barrier,destroy_barrier} <= {1'b0, 1'b0, 1'b0,1'b0,1'b0,1'b0};
            end            
            
            endcase
        end
    end
    
    always@(*) // Output Combinational Logic
    begin
        state_led = state;
        // case selection for states
        case(state)
        
        not_starting: 
        begin
            left_turn_led = 1'b1; 
            right_turn_led = 1'b1;
            reverse_led = 1'b0;
        end
        
        starting:
        begin
            left_turn_led = 1'b0; 
            right_turn_led = 1'b0;
            reverse_led = reverse_signal;
        end
        
        moving:
        begin
            if (turn_left_signal && ~turn_right_signal)
            begin
                left_turn_led = flash_led;
                right_turn_led = 1'b0;
            end
            else if (~turn_left_signal && turn_right_signal)
            begin
                left_turn_led = 1'b0;
                right_turn_led = flash_led;
            end
            else
            begin
                left_turn_led = 1'b0;  
                right_turn_led = 1'b0;            
            end         
            reverse_led = reverse_signal;
        end
        
        sauto_moving:
        begin
            left_turn_led = 1'b0;
            right_turn_led = 1'b0;
            reverse_led = 1'b0;
        end
        
        sauto_waiting:
        begin
            left_turn_led = flash_led;
            right_turn_led = flash_led;
            reverse_led = flash_led;
        end
        
        sauto_turning:
        begin
        end
        default:
        begin
            left_turn_led = 1'b0;  
            right_turn_led = 1'b0;
            reverse_led = 1'b0;
        end
        endcase
        
    end
    
    // uart
    wire [7:0] in = {2'b10, destroy_barrier, place_barrier, turn_right, turn_left, move_backward, move_forward};
    wire [7:0] rec;
    assign front_detector = rec[0];
    assign left_detector = rec[1];
    assign right_detector = rec[2];
    assign back_detector = rec[3];

    // sub-modules
    seg s(clk_ms, clk_100ms, rst, state, seg_en, seg_out0, seg_out1); //seg 
    clk_div cd( .clk(sys_clk), .rst_n(rst), .clk_ms(clk_ms), .clk_20ms(clk_20ms), .clk_100ms(clk_100ms), .clk_s(clk_s)); // clock division
    power_on_judge poj(clk_20ms, rst, power_on_signal, power_on_1sec); // power on 1 sec
    
    edge_detector ed1(.clk(sys_clk), .rst_n(rst), .signal(reverse_signal), .double_edge_detect(reverse_change) );// detect reverse signal change
    flash_led fled1(.clk(clk_ms), .rst_n(rst), .flash_led(flash_led)); // flash_led
    
    detect_fork df(sys_clk, rst, {front_detector,back_detector,left_detector, right_detector}, fork_here); // detect fork
    edge_detector ed2(.clk(sys_clk), .rst_n(rst), .signal(fork_here), .raising_edge_detect(detect_fork_appear));// detect fork appearing edge
    edge_detector ed3(.clk(sys_clk), .rst_n(rst), .signal(fork_here), .falling_edge_detect(detect_fork_disappear) );// detect fork disappearing edge
    
    uart_top md(.clk(sys_clk), .rst(0), .data_in(in), .data_rec(rec), .rxd(rx), .txd(tx)); // uart top
    
    auto_turning at (clk_ms, rst, state, left_right, turn_around, turn_l, turn_r, finish_turning); // auto-turning
    
    // barrier detection
    barrier_detecting bd1(clk_20ms, rst, start_detect, left_detector, 1'b1 ,left_detect_on_1s);
    barrier_detecting bd2(clk_20ms, rst, start_detect, left_detector, 1'b0 ,left_detect_off_1s);
    barrier_detecting bd3(clk_20ms, rst, start_detect, right_detector, 1'b1 ,right_detect_on_1s);
    barrier_detecting bd4(clk_20ms, rst, start_detect, right_detector, 1'b0 ,right_detect_off_1s);
    barrier_detecting bd5(clk_20ms, rst, start_detect, front_detector, 1'b0 ,front_detect_off_1s);
    
    power_on_judge front_judge(clk_ms, rst, front_detector, front_detect_on_005s); // front detect 0.05 sec
    
endmodule

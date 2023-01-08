`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/11 15:29:02
// Design Name: 
// Module Name: seg
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


module seg(
    input clk_ms,
    input clk_100ms,
    input rst,
    input [3:0] state,                 //current state
    output reg [7:0] seg_en,     //bit selection signal
    output reg [7:0] seg_out0,  //left segment selection signal
    output reg [7:0] seg_out1  //right segment selection signal
    );
        
    reg [31:0] data;
    reg [3:0] data_temp0;
    reg [3:0] data_temp1;
    
    reg power_off, moving;
    
    always@(*)
    begin
        case(state)
            4'b0000:
            begin
                moving = 1'b0; 
                power_off = 1'b1;
            end
            4'b0100:
            begin
                moving = 1'b1;
                power_off = 1'b0;
            end
            default: {power_off, moving} = 2'b0;
        endcase
    end
    
    always@(posedge clk_ms, negedge rst)
    begin
        if(~rst || power_off)
            seg_en <= 8'b0000_0000;
        else if((seg_en == 8'b1000_0000) || (seg_en == 8'b0000_0000))
            seg_en <= 8'b0000_0001;
        else
            seg_en <= seg_en << 1;
    end

always@(posedge clk_100ms, negedge rst)
begin
    if(~rst || power_off || data == 32'hffffffff)
        data <= 32'd0;
    else if(moving)
    begin
        if(data[3:0] == 4'd9) 
        begin
            data[3:0] <= 4'd0;
            data[7:4] <= data[7:4] + 1'd1;
        end
        else
            data[3:0] <= data[3:0] + 1'd1;
 
        if(data[7:4] == 4'd9 && data[3:0] == 4'd9)
        begin
            data[7:4] <= 4'd0;
            data[11:8] <= data[11:8] + 1'd1;
        end

        if(data[11:8] == 4'd9 && data[7:4] == 4'd9 && data[3:0] == 4'd9)
        begin
            data[11:8] <= 4'd0;
            data[15:12] <= data[15:12] + 1'd1;
        end

        if(data[15:12] == 4'd9 && data[11:8] == 4'd9 && data[7:4] == 4'd9 && data[3:0] == 4'd9)
        begin
            data[15:12] <= 4'd0;
            data[19:16] <= data[19:16] + 1'd1;
        end

        if(data[19:16] == 4'd9 && data[15:12] == 4'd9 && data[11:8] == 4'd9 && data[7:4] == 4'd9 && data[3:0] == 4'd9)
        begin
            data[19:16] <= 4'd0;
            data[23:20] <= data[23:20] + 1'd1;
        end
        
        if(data[23:20] == 4'd9 && data[19:16] == 4'd9 && data[15:12] == 4'd9 && data[11:8] == 4'd9 && data[7:4] == 4'd9 && data[3:0] == 4'd9)
        begin
            data[23:20] <= 4'd0;
            data[27:24] <= data[27:24] + 1'd1;
        end

        if(data[27:24] == 4'd9 && data[23:20] == 4'd9 && data[19:16] == 4'd9 && data[15:12] == 4'd9 && data[11:8] == 4'd9 && data[7:4] == 4'd9 && data[3:0] == 4'd9)
        begin
            data[27:24] <= 4'd0;
            data[31:28] <= data[31:28] + 1'd1;
        end
    end
end
    
    always@(*)
    begin
        case(seg_en)
            8'b0000_0001: data_temp1 = data[3:0];
            8'b0000_0010: data_temp1 = data[7:4];
            8'b0000_0100: data_temp1 = data[11:8];
            8'b0000_1000: data_temp1 = data[15:12];
            8'b0001_0000: data_temp0 = data[19:16];
            8'b0010_0000: data_temp0 = data[23:20];
            8'b0100_0000: data_temp0 = data[27:24];
            8'b1000_0000: data_temp0 = data[31:28];
            default: {data_temp0 ,data_temp1} = 8'b0;
        endcase
    end
    
    always @(*)
    begin
    case(data_temp1)
        4'h0:   seg_out1 = 8'b1111_1100;
        4'h1:   seg_out1 = 8'b0110_0000;
        4'h2:   seg_out1 = 8'b1101_1010;
        4'h3:   seg_out1 = 8'b1111_0010;
        4'h4:   seg_out1 = 8'b0110_0110;
        4'h5:   seg_out1 = 8'b1011_0110;
        4'h6:   seg_out1 = 8'b1011_1110;
        4'h7:   seg_out1 = 8'b1110_0000;
        4'h8:   seg_out1 = 8'b1111_1110;
        default:seg_out1 = 8'b1110_0110;
    endcase
    end

    always @(*)
    begin
    case(data_temp0)
        4'h0:   seg_out0 = 8'b1111_1100;
        4'h1:   seg_out0 = 8'b0110_0000;
        4'h2:   seg_out0 = 8'b1101_1010;
        4'h3:   seg_out0 = 8'b1111_0010;
        4'h4:   seg_out0 = 8'b0110_0110;
        4'h5:   seg_out0 = 8'b1011_0110;
        4'h6:   seg_out0 = 8'b1011_1110;
        4'h7:   seg_out0 = 8'b1110_0000;
        4'h8:   seg_out0 = 8'b1111_1110;
        default:seg_out0 = 8'b1110_0110;
    endcase
    end
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/09 16:25:51
// Design Name: 
// Module Name: project3_2
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


module counter(
    input clk,          // 时钟输入（上升沿触发）
    output reg [2:0] out // 3位计数输出（必须声明为reg类型）
);

// 时序逻辑块
always @(posedge clk) begin
    out <= out + 1;     // 每个时钟周期加1（自动溢出）
end

endmodule

module divider(
    input clk,          // 系统时钟（100MHz）
    output reg clk_N    // 分频后时钟
);
    parameter N = 100_000_000;  // 默认1Hz分频（100MHz / 100,000,000）
    reg [31:0] counter;

    always @(posedge clk) begin
        if (counter >= (N/2 - 1)) begin  // 计数达到N/2时翻转
            clk_N <= ~clk_N;
            counter <= 0;
        end 
        else begin
            counter <= counter + 1;
        end
    end

    // 初始化时钟信号
    initial begin
        clk_N = 0;
        counter = 0;
    end
endmodule

module lab3_1(
    input clk,          // 来自E3引脚的100MHz时钟
    output [2:0] LED    // LED0[0]、LED1[1]、LED2[2]
);

wire clk_N;   // 分频后的时钟

// 实例化分频器（1Hz）
divider #(
    .N(100_000_000)   // 1秒周期
) div_inst (
    .clk(clk),
    .clk_N(clk_N)
);

// 实例化计数器
counter cnt_inst (
    .clk(clk_N),    // 使用分频后的时钟
    .out(LED)          // 直接连接LED
);

endmodule

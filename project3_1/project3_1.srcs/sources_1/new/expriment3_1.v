`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/09 15:41:06
// Design Name: 
// Module Name: expriment3_1
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
    output led0         // LED0显示分频结果
);

    // 实例化分频器（可修改参数值观察效果）
    divider #(
        .N(50_000_000)  // 修改此处数值（示例为2Hz）
    ) D1 (
        .clk(clk),
        .clk_N(led0)
    );

endmodule

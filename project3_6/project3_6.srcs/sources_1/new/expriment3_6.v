`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/09 17:23:21
// Design Name: 
// Module Name: expriment3_6
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
module rom8x4(
    input [2:0] addr,    // 3位地址输入
    output [3:0] data    // 4位数据输出
);

// 8x4存储器声明
reg [3:0] mem [7:0];

// 存储器初始化（二进制对应0,2,4,6,8,A,C,E）
initial begin
    mem[0] = 4'b0000;    // 0
    mem[1] = 4'b0010;    // 2
    mem[2] = 4'b0100;    // 4
    mem[3] = 4'b0110;    // 6
    mem[4] = 4'b1000;    // 8
    mem[5] = 4'b1010;    // A
    mem[6] = 4'b1100;    // C
    mem[7] = 4'b1110;    // E
end

// 数据读取（组合逻辑）
assign data = mem[addr];

endmodule

module _7Seg_Driver_Decode(
    input [3:0] SW,        // 4位输入
    output reg [7:0] SEG   // 7段译码输出（reg类型）
);

always @(*) begin
    case (SW)
        4'b0000: SEG = 8'b11000000; // 0
        4'b0001: SEG = 8'b11111001; // 1
        4'b0010: SEG = 8'b10100100; // 2
        4'b0011: SEG = 8'b10110000; // 3
        4'b0100: SEG = 8'b10011001; // 4
        4'b0101: SEG = 8'b10010010; // 5
        4'b0110: SEG = 8'b10000010; // 6
        4'b0111: SEG = 8'b11111000; // 7
        4'b1000: SEG = 8'b10000000; // 8
        4'b1001: SEG = 8'b10011000; // 9
        4'b1010: SEG = 8'b10001000; // A
        4'b1011: SEG = 8'b10000011; // b
        4'b1100: SEG = 8'b11000110; // C
        4'b1101: SEG = 8'b10100001; // d
        4'b1110: SEG = 8'b10000110; // E
        4'b1111: SEG = 8'b10001110; // F
        default: SEG = 8'b11111111; // 全灭
    endcase
end

endmodule

module _7Seg_Driver_Selector(
    input [2:0] SW,        // 3位选择信号
    output reg [7:0] AN    // 片选信号输出（reg类型）
);

always @(*) begin
    // 优化后的片选逻辑
    AN = ~(8'b00000001 << SW);  // 等价于原式 8'b11111111 - (8'b00000001 << SW)
end

endmodule

module dynamic_scan(
    input clk,           // 100MHz系统时钟
    output [7:0] SEG,    // 七段数码管段选信号（CA-CG + DP）
    output [7:0] AN      // 八位数码管位选信号（低电平有效）
);

// 内部信号声明
wire clk_scan;          // 扫描时钟信号
wire [2:0] addr;        // 地址计数器输出
wire [3:0] rom_data;    // ROM输出数据
wire [7:0] seg_decoded; // 七段译码结果

// 分频模块实例化（扫描频率控制）
divider #(
    .N(50_000)          // 分频参数（100MHz/50000/2 = 1kHz扫描频率）
) div_inst (
    .clk(clk),
    .clk_N(clk_scan)
);

// 计数器模块实例化（地址生成）
counter cnt_inst (
    .clk(clk_scan),     // 使用分频后的扫描时钟
    .out(addr)          // 生成0-7循环地址
);

// ROM存储器实例化
rom8x4 rom_inst (
    .addr(addr),        // 当前扫描地址
    .data(rom_data)     // 对应存储数据输出
);

// 七段显示译码器实例化
_7Seg_Driver_Decode seg_decoder (
    .SW(rom_data),      // 输入ROM数据
    .SEG(seg_decoded)   // 输出段码
);

// 数码管选择模块实例化（3-8译码器）
_7Seg_Driver_Selector selector (
    .SW(addr),          // 输入当前地址
    .AN(AN)             // 输出位选信号
);

// 最终段码输出（DP点默认关闭）
assign SEG = seg_decoded;

endmodule
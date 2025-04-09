`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/09 16:59:21
// Design Name: 
// Module Name: project3_4
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
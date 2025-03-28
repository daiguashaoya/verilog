`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/28 21:41:12
// Design Name: 
// Module Name: project_3
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


module _7Seg_Driver_Decode(
    input [3:0] SW,   // 4位拨动开关
    output reg [7:0] SEG  // 7段数码管驱动，低电平有效
);

always @(*) begin
    case (SW[3:0])
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
        default: SEG = 8'b11111111; // 默认全灭
    endcase
    end

endmodule

module _7Seg_Driver_Selector(
    input [2:0] SW,    // 3位拨动开关，用于选择数码管
    output reg [7:0] AN  // 7段数码管片选信号，低电平有效
);

    always @(*) begin
           assign AN = 8'b11111111 - (8'b00000001 << SW[15:13]);
    end

endmodule

module _7Seg_Driver_Choice(
    input [15:0] SW,   // 16位拨动开关
    output reg [7:0] SEG,  // 7段数码管驱动，低电平有效
    output [7:0] AN,   // 7段数码管片选信号，低电平有效
    output [15:0] LED  // 16位LED显示
);

    // 内部信号
    reg [7:0] decoded_SEG;
    reg [7:0] decoded_AN;

    // 调用译码显示模块
    _7Seg_Driver_Decode decoder (
        .SW(SW[3:0]),
        .SEG(decoded_SEG)
    );

    // 调用译码选择模块
    _7Seg_Driver_Selector selector (
        .SW(SW[15:13]),
        .AN(decoded_AN)
    );

    // 将译码选择模块的输出连接到顶层模块的输出
    assign SEG = decoded_SEG;
    assign AN = decoded_AN;
    assign LED = SW;

endmodule
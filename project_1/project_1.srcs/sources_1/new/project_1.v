`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/28 19:15:43
// Design Name: 
// Module Name: project_1
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


module _7Seg_Driver_Direct(
  input [15:0] SW,  // 16位拨动开关
  output CA, CB, CC, CD, CE, CF, CG, DP,  // 7段数码管驱动，低电平有效
  output [7:0] AN,  // 7段数码管片选信号，低电平有效
  output [15:0] LED  // 16位LED显示，高电平有效
);

assign CA = SW[7];
assign CB = SW[6];
assign CC = SW[5];
assign CD = SW[4];
assign CE = SW[3];
assign CF = SW[2];
assign CG = SW[1];
assign DP = SW[0];

assign AN = 8'b11111111 - (8'b00000001 << SW[15:13]);
assign LED[15:0] = SW[15:0];  // 将开关状态显示在LED上

endmodule

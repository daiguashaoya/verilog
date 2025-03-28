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
  input [15:0] SW,  // 16λ��������
  output CA, CB, CC, CD, CE, CF, CG, DP,  // 7��������������͵�ƽ��Ч
  output [7:0] AN,  // 7�������Ƭѡ�źţ��͵�ƽ��Ч
  output [15:0] LED  // 16λLED��ʾ���ߵ�ƽ��Ч
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
assign LED[15:0] = SW[15:0];  // ������״̬��ʾ��LED��

endmodule

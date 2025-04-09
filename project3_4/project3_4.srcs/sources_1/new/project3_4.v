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
    input [2:0] addr,    // 3λ��ַ����
    output [3:0] data    // 4λ�������
);

// 8x4�洢������
reg [3:0] mem [7:0];

// �洢����ʼ���������ƶ�Ӧ0,2,4,6,8,A,C,E��
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

// ���ݶ�ȡ������߼���
assign data = mem[addr];

endmodule
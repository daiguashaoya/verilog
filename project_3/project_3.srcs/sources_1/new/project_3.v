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
    input [3:0] SW,   // 4λ��������
    output reg [7:0] SEG  // 7��������������͵�ƽ��Ч
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
        default: SEG = 8'b11111111; // Ĭ��ȫ��
    endcase
    end

endmodule

module _7Seg_Driver_Selector(
    input [2:0] SW,    // 3λ�������أ�����ѡ�������
    output reg [7:0] AN  // 7�������Ƭѡ�źţ��͵�ƽ��Ч
);

    always @(*) begin
           assign AN = 8'b11111111 - (8'b00000001 << SW[15:13]);
    end

endmodule

module _7Seg_Driver_Choice(
    input [15:0] SW,   // 16λ��������
    output reg [7:0] SEG,  // 7��������������͵�ƽ��Ч
    output [7:0] AN,   // 7�������Ƭѡ�źţ��͵�ƽ��Ч
    output [15:0] LED  // 16λLED��ʾ
);

    // �ڲ��ź�
    reg [7:0] decoded_SEG;
    reg [7:0] decoded_AN;

    // ����������ʾģ��
    _7Seg_Driver_Decode decoder (
        .SW(SW[3:0]),
        .SEG(decoded_SEG)
    );

    // ��������ѡ��ģ��
    _7Seg_Driver_Selector selector (
        .SW(SW[15:13]),
        .AN(decoded_AN)
    );

    // ������ѡ��ģ���������ӵ�����ģ������
    assign SEG = decoded_SEG;
    assign AN = decoded_AN;
    assign LED = SW;

endmodule
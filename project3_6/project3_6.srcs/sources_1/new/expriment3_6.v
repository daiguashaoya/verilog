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
    input clk,          // ʱ�����루�����ش�����
    output reg [2:0] out // 3λ�����������������Ϊreg���ͣ�
);

// ʱ���߼���
always @(posedge clk) begin
    out <= out + 1;     // ÿ��ʱ�����ڼ�1���Զ������
end

endmodule

module divider(
    input clk,          // ϵͳʱ�ӣ�100MHz��
    output reg clk_N    // ��Ƶ��ʱ��
);
    parameter N = 100_000_000;  // Ĭ��1Hz��Ƶ��100MHz / 100,000,000��
    reg [31:0] counter;

    always @(posedge clk) begin
        if (counter >= (N/2 - 1)) begin  // �����ﵽN/2ʱ��ת
            clk_N <= ~clk_N;
            counter <= 0;
        end 
        else begin
            counter <= counter + 1;
        end
    end

    // ��ʼ��ʱ���ź�
    initial begin
        clk_N = 0;
        counter = 0;
    end
endmodule
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

module _7Seg_Driver_Decode(
    input [3:0] SW,        // 4λ����
    output reg [7:0] SEG   // 7�����������reg���ͣ�
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
        default: SEG = 8'b11111111; // ȫ��
    endcase
end

endmodule

module _7Seg_Driver_Selector(
    input [2:0] SW,        // 3λѡ���ź�
    output reg [7:0] AN    // Ƭѡ�ź������reg���ͣ�
);

always @(*) begin
    // �Ż����Ƭѡ�߼�
    AN = ~(8'b00000001 << SW);  // �ȼ���ԭʽ 8'b11111111 - (8'b00000001 << SW)
end

endmodule

module dynamic_scan(
    input clk,           // 100MHzϵͳʱ��
    output [7:0] SEG,    // �߶�����ܶ�ѡ�źţ�CA-CG + DP��
    output [7:0] AN      // ��λ�����λѡ�źţ��͵�ƽ��Ч��
);

// �ڲ��ź�����
wire clk_scan;          // ɨ��ʱ���ź�
wire [2:0] addr;        // ��ַ���������
wire [3:0] rom_data;    // ROM�������
wire [7:0] seg_decoded; // �߶�������

// ��Ƶģ��ʵ������ɨ��Ƶ�ʿ��ƣ�
divider #(
    .N(50_000)          // ��Ƶ������100MHz/50000/2 = 1kHzɨ��Ƶ�ʣ�
) div_inst (
    .clk(clk),
    .clk_N(clk_scan)
);

// ������ģ��ʵ��������ַ���ɣ�
counter cnt_inst (
    .clk(clk_scan),     // ʹ�÷�Ƶ���ɨ��ʱ��
    .out(addr)          // ����0-7ѭ����ַ
);

// ROM�洢��ʵ����
rom8x4 rom_inst (
    .addr(addr),        // ��ǰɨ���ַ
    .data(rom_data)     // ��Ӧ�洢�������
);

// �߶���ʾ������ʵ����
_7Seg_Driver_Decode seg_decoder (
    .SW(rom_data),      // ����ROM����
    .SEG(seg_decoded)   // �������
);

// �����ѡ��ģ��ʵ������3-8��������
_7Seg_Driver_Selector selector (
    .SW(addr),          // ���뵱ǰ��ַ
    .AN(AN)             // ���λѡ�ź�
);

// ���ն��������DP��Ĭ�Ϲرգ�
assign SEG = seg_decoded;

endmodule
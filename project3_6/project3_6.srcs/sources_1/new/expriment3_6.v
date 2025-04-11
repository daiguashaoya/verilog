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
    input dir,
    input clk,          // ʱ�����루�����ش�����
    output reg [2:0] out // 3λ�����������������Ϊreg���ͣ�
);

// ʱ���߼���
always @(posedge clk) begin
        out <= dir ? out + 1 : out - 1; // �������
end

endmodule

module divider(
    input clk,          // ϵͳʱ�ӣ�100MHz��
    input speed_mode,
    output reg clk_N    // ��Ƶ��ʱ��
);
    parameter SLOW_N = 50_000_000; // ������
    parameter FAST_N = 50_000;
    
    reg [31:0] counter;
    wire [31:0] N = speed_mode ? FAST_N : SLOW_N;

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
    AN = ~(8'b00000001 << SW);   
end

endmodule

module dynamic_scan(
    input clk,           // 100MHzϵͳʱ��
    input [2:0] SW,
    output [7:0] SEG,    // �߶�����ܶ�ѡ�źţ�CA-CG + DP��
    output [7:0] AN     // ��λ�����λѡ�źţ��͵�ƽ��Ч��
);

// �ڲ��ź�����
wire clk_scan;          // ɨ��ʱ���ź�
wire [2:0] addr;        // ��ַ���������
wire [3:0] rom_data;    // ROM�������
wire [7:0] seg_decoded; // �߶�������

// ��������߼������ȼ����� > �ң�
wire direction = SW[2] ? 1'b1 : 
                SW[0] ? 1'b0 : 
                1'b1;   // Ĭ������

// ��Ƶ����ȷʵ����
divider #(
    .SLOW_N(50_000_000),  // ��ȷ��������
    .FAST_N(50_000)
) div_inst (
    .clk(clk),
    .speed_mode(SW[1]),
    .clk_N(clk_scan)
);

// ������ģ��ʵ��������ַ���ɣ�
counter cnt_inst (
    .dir(direction),
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

// �����ѡ��ģ��ʵ����
_7Seg_Driver_Selector selector (
    .SW(addr),          // ���뵱ǰ��ַ
    .AN(AN)             // ���λѡ�ź�
);

// ���ն������
assign SEG = seg_decoded;

endmodule
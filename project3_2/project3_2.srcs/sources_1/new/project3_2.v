`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/09 16:25:51
// Design Name: 
// Module Name: project3_2
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

module lab3_1(
    input clk,          // ����E3���ŵ�100MHzʱ��
    output [2:0] LED    // LED0[0]��LED1[1]��LED2[2]
);

wire clk_N;   // ��Ƶ���ʱ��

// ʵ������Ƶ����1Hz��
divider #(
    .N(100_000_000)   // 1������
) div_inst (
    .clk(clk),
    .clk_N(clk_N)
);

// ʵ����������
counter cnt_inst (
    .clk(clk_N),    // ʹ�÷�Ƶ���ʱ��
    .out(LED)          // ֱ������LED
);

endmodule

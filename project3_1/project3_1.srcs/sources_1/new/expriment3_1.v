`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/09 15:41:06
// Design Name: 
// Module Name: expriment3_1
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
    output led0         // LED0��ʾ��Ƶ���
);

    // ʵ������Ƶ�������޸Ĳ���ֵ�۲�Ч����
    divider #(
        .N(50_000_000)  // �޸Ĵ˴���ֵ��ʾ��Ϊ2Hz��
    ) D1 (
        .clk(clk),
        .clk_N(led0)
    );

endmodule

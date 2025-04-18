
module full_adder(a, b, c_in, sum, c_out);
    parameter WIDTH = 8;
    
    input [WIDTH-1:0] a, b;
    input c_in;
    output [WIDTH-1:0] sum;
    output c_out;
    
    assign { c_out, sum } = a + b + c_in;
endmodule

module comparator(a, b, is_equal, is_great, is_less);
    parameter WIDTH = 8;
    
    input [WIDTH-1:0] a, b;
    output is_equal, is_great, is_less;
    
    assign is_equal = (a == b) ? 1'b1 : 1'b0;
    assign is_great = (a > b) ? 1'b1 : 1'b0;
    assign is_less = (a < b) ? 1'b1 : 1'b0;

endmodule

module mux_21(a, b, sel, out);
    parameter WIDTH = 8;
    
    input [WIDTH-1:0] a, b;
    input sel;
    output [WIDTH-1:0] out;
    
    // ��Ԫ�����
    assign out = sel == 0 ? a : b;
    
endmodule

module ram(data, read_addr, write_addr, clk, we, q);
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 3;

  input clk, we;
  input [DATA_WIDTH-1:0] data;
  input [ADDR_WIDTH-1:0] read_addr, write_addr;
  output reg [DATA_WIDTH-1:0] q;

  // �����洢������
  reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

  always @(posedge clk) begin
    if (we)
      ram[write_addr] <= data;

    q <= ram[read_addr];
  end    
endmodule

// ����ģ�鱣�ֲ��䣬���޸�registerģ��Ϊͬ����λ�汾
module register(clk, rst, load, D, Q);
  parameter WIDTH = 8;
  input clk, rst, load;
  input [WIDTH-1:0] D;
  output reg [WIDTH-1:0] Q;

  always @(posedge clk) begin
    if (rst) Q <= 0;
    else if (load) Q <= D;
  end    
endmodule

module datapath(
  input  wire        clk,
  input  wire        rst,
  input  wire        SUM_SEL,
  input  wire        NEXT_SEL,
  input  wire        A_SEL,
  input  wire        LD_SUM,
  input  wire        LD_NEXT,
  output wire        NEXT_ZERO,
  output wire [31:0] sum_out
);
  parameter n = 32;        // ������λ��8/16/32��
  parameter ADDR_WIDTH = 8; // ��ַ���߿��
  
  // �ڲ��ź�����
  wire [n-1:0] sum_mux_out, next_mux_out, a_mux_out;
  wire [n-1:0] sum_reg_out, next_reg_out;
  wire [n-1:0] adder_sum;
  wire [n-1:0] mem_next_addr, mem_node_data;
  wire [n-1:0] next_plus_1;

  // =================================================================
  // ������ַƫ���߼�
  // =================================================================
  full_adder #(n) addr_offset_adder(
    .a(next_reg_out),
    .b(1),              // �̶�+1����
    .c_in(1'b0),
    .sum(next_plus_1),  // �������ݵ�ַ
    .c_out()
  );

  // =================================================================
  // �洢�����ʿ����߼�
  // =================================================================
  // ��ַѡ�����������ֵ�ַģʽ
  mux_21 #(n) addr_mux(
    .a(next_plus_1),    // ���ݵ�ַ��NEXT+1��
    .b(next_reg_out),   // ָ���ַ��NEXT��
    .sel(A_SEL),        // A_SEL=1:ѡ��ָ���ַ��A_SEL=0:ѡ�����ݵ�ַ
    .out(a_mux_out)
  );

  // ���˿ڴ洢��ʵ����
  ram #(
    .DATA_WIDTH(n),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) memory (
    .clk(clk),
    .we(1'b0),           // ֻ��ģʽ
    .data({n{1'b0}}),    // ��д������
    .read_addr(a_mux_out[ADDR_WIDTH-1:0]),
    .write_addr(0),
    .q((A_SEL) ? mem_next_addr : mem_node_data) // ���ݵ�ַ���������ͬ����
  );

  // =================================================================
  // ����·�������߼�
  // =================================================================
  // SUM�Ĵ�������·��
  mux_21 #(n) sum_mux(
    .a(adder_sum),      // �ۼӽ��
    .b({n{1'b0}}),      // ��������
    .sel(SUM_SEL),      // SUM_SEL=1ʱ����
    .out(sum_mux_out)
  );
  
  register #(n) SUM_reg(
    .clk(clk),
    .rst(rst),
    .load(LD_SUM),
    .D(sum_mux_out),
    .Q(sum_reg_out)
  );

  // NEXT�Ĵ�������·��
  mux_21 #(n) next_mux(
    .a(mem_next_addr),  // ���Դ洢������һ��ַ
    .b({n{1'b0}}),      // ��������
    .sel(NEXT_SEL),     // NEXT_SEL=1ʱ����
    .out(next_mux_out)
  );
  
  register #(n) NEXT_reg(
    .clk(clk),
    .rst(rst),
    .load(LD_NEXT),
    .D(next_mux_out),
    .Q(next_reg_out)
  );

  // =================================================================
  // ���㵥Ԫ
  // =================================================================
  full_adder #(n) adder(
    .a(sum_reg_out),
    .b(mem_node_data),  // ���Դ洢���Ľڵ�����
    .c_in(1'b0),
    .sum(adder_sum),
    .c_out()
  );

  // =================================================================
  // ��ֹ�������
  // =================================================================
  comparator #(n) zero_compare(
    .a(next_reg_out),
    .b({n{1'b0}}),
    .is_equal(NEXT_ZERO)
  );

  assign sum_out = {{(32-n){1'b0}}, sum_reg_out}; // ������չ��32λ

endmodule
module multipumped_memory(clk, wr, addr, d, q);
    parameter PORTS = 8;
    parameter WIDTH = 64;
    parameter DEPTH = 512;
    parameter LOG2_DEPTH = log2(DEPTH - 1);
    parameter LOG2_PORTS = log2(PORTS - 1);
    input clk;
    input [0:PORTS - 1] wr;
    input [PORTS * LOG2_DEPTH - 1:0] addr;
    input [PORTS * WIDTH - 1:0] d;
    output reg [PORTS * WIDTH - 1:0] q;
reg [LOG2_PORTS - 2:0] counter;
initial counter = 0;
always @(posedge clk) begin
    counter <= counter + 1;
end
integer i, j;
reg [LOG2_DEPTH - 1:0] addr_2d [0:PORTS - 1];
reg [WIDTH - 1:0] d_2d [0:PORTS - 1];
always @* for(i = 0; i < PORTS; i = i + 1) begin
    addr_2d[i] = addr[(i + 1) * LOG2_DEPTH - 1 -:LOG2_DEPTH];
    d_2d[i] = d[(i + 1) * WIDTH - 1 -: WIDTH];
end
wire [WIDTH - 1:0] ram_q_a, ram_q_b;
dual_port_block_ram ram(clk, wr[{1'H0, counter}], addr_2d[{1'H0, counter}], d_2d[{1'H0, counter}], ram_q_a, wr[{1'H1, counter}], addr_2d[{1'H1, counter}], d_2d[{1'H1, counter}], ram_q_b);

always @(posedge clk) begin
    for(i = 1; i < PORTS / 2; i = i + 1) begin
        if((i + 1) % (PORTS / 2) == counter) begin
            q[(i + 1) * WIDTH - 1 -: WIDTH] <= ram_q_a;
            q[(i + PORTS / 2 + 1) * WIDTH - 1 -: WIDTH] <= ram_q_b;
        end
    end
end
`include "common.vh"
endmodule

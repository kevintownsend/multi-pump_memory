module multipumped_memory
#(
    parameter PORTS = 8;
    parameter WIDTH = 64;
    parameter DEPTH = 512;
    parameter LOG2_DEPTH = log2(DEPTH - 1);
    parameter LOG2_PORTS = log2(PORTS - 1);
)(
    input [0:PORTS - 1] wr;
    input [PORTS * LOG2_DEPTH - 1:0] addr;
    input [PORTS * WIDTH - 1:0] d;
    output [PORTS * WIDTH - 1:0] q;
)
reg [LOG2_PORTS - 1:0] counter;
initial counter = 0;
always @(posedge clk) begin
    counter <= counter + 1;
    if(counter[LOG2_PORTS - 1])
        counter[LOG2_PORTS - 1] <= 0;
end
reg [LOG2_PORTS - 2:0] counter_pipe;
always @(posedge clk) begin
    counter_pipe <= counter;
end

integer i;
reg [LOG2_DEPTH - 1:0] addr_2d [0:PORTS - 1];
reg [WIDTH - 1:0] d_2d [0:PORTS - 1];
always @* for(i = 0; i < PORTS; i = i + 1) begin
    addr_2d[i] = addr[(i + 1) * LOG2_DEPTH - 1:LOG2_DEPTH];
    d_2d[i] = d[(i + 1) * WIDTH - 1 -: WIDTH];
end
wire [WIDTH - 1:0] ram_q_a, ram_q_b;
dual_port_block_ram(clk, wr[{1'H0, counter_pipe}], addr_2d[{1'H0, counter_pipe}], d_2d[{1'H0, counter_pipe}], ram_q_a, wr[{1'H1, counter_pipe}], addr_2d[{1'H1, counter_pipe}], d_2d[{1'H1, counter_pipe}], ram_q_b);

//TODO
endmodule

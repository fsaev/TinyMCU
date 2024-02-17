/* Shamelessly stolen from https://digilent.com/reference/learn/programmable-logic/tutorials/use-flip-flops-to-build-a-clock-divider/start */

module clk_divider #(parameter DIV = 2) (
    input clk,
    input rst,
    output out
    );
 
wire [DIV - 1:0] din;
wire [DIV - 1:0] clkdiv;
 
dff dff_inst0 (
    .clk(clk),
    .rst(rst),
    .D(din[0]),
    .Q(clkdiv[0])
);
 
genvar i;
generate
for (i = 1; i < DIV; i=i+1) 
begin : dff_gen_label
    dff dff_inst (
        .clk(clkdiv[i-1]),
        .rst(rst),
        .D(din[i]),
        .Q(clkdiv[i])
    );
    end
endgenerate;
 
assign din = ~clkdiv;
 
assign out = clkdiv[DIV - 1];
 
endmodule

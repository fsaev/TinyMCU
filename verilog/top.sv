/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN*/
/* verilator lint_off DECLFILENAME*/
/* verilator lint_off PINMISSING */

module top(input clk_in, input reset_in, input uart_rx, output uart_tx, output [3:0] leds);

wire [7:0] cpu_data_in; // 8 bit data in to cpu
wire [7:0] cpu_data_out; // 8 bit data out from cpu
wire [15:0] cpu_addr_out; // 16 bit address controlled by cpu
wire ram_read;
wire ram_write;
wire [3:0] stage_no;

wire reset = ~reset_in;

wire pll_450;
wire pll_10;
main_pll main_pll_inst(.clk_in1(clk_in), .clk_out1(pll_450), .clk_out2(pll_10));

assign leds [3:0] = ~stage_no [3:0];

wire [15:0] translated_addr_out;
wire [2:0] device_select;
memmap memmap_inst(.addr_in(cpu_addr_out), .translated_addr_out(translated_addr_out), .device_select(device_select));

simple_ram simple_ram(.device_select(device_select), .clk(pll_10), .addr_in(cpu_addr_out), 
    .we(ram_write), .oe(ram_read), 
    .data_in(cpu_data_out), .data_out(cpu_data_in));

uart uart_inst(.device_select(device_select), .clk(pll_10), .mmio_addr(translated_addr_out), .mmio_wr(ram_write), .mmio_rd(ram_read), 
    .mmio_data_in(cpu_data_out), .mmio_data_out(cpu_data_in), .tx(uart_tx), .rx(uart_rx));

cpu cpu_inst(.clk_in(pll_10), .reset_in(reset), 
        .data_in(cpu_data_in), .data_out(cpu_data_out), .addr_out(cpu_addr_out),
        .ram_oe(ram_read), .ram_wr(ram_write), .stage_no(stage_no));

endmodule

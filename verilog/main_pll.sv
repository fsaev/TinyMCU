/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN*/
/* verilator lint_off DECLFILENAME*/
/* verilator lint_off PINMISSING */

module main_pll(input clk_in1, output reg clk_out1, output reg clk_out2);
    reg [3:0] clkdiv_reg = 0;

    always_ff @(clk_in1) begin
        clk_out1 <= ~clk_out1;
        clkdiv_reg <= clkdiv_reg + 3'h01;
        if(clkdiv_reg == 10) begin
            clk_out2 <= ~clk_out2;
        end
    end
endmodule


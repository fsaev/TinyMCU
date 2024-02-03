/* verilator lint_off DECLFILENAME*/

module clkdiv(input in,
                  input reg [31:0] div,
                  output reg out
);

reg [31:0] clkdiv_reg;

always @(posedge in) begin
    if(clkdiv_reg == 0) begin
        clkdiv_reg <= div;
        out <= !out;
    end else
        clkdiv_reg <= clkdiv_reg - 32'h00000001;
end

endmodule

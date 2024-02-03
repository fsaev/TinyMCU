/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN*/
/* verilator lint_off DECLFILENAME*/

module register(input clk, input we, input [7:0] data_in, output reg [7:0] data_out);

    always @(posedge clk)
    begin
        if (we)
            data_out <= data_in;
        //data_out <= data;
    end
endmodule

module counter(input clk, input load, input enable, input [15:8] data_in_h, input [7:0] data_in_l, output reg [15:0] data_out);

    always @(posedge clk)
    begin
        if (load) begin
            data_out[15:8] <= data_in_h;
            data_out[7:0] <= data_in_l;
        end
        else if (enable)
            data_out <= data_out + 16'h0001;
    end
endmodule

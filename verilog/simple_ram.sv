/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN*/
/* verilator lint_off DECLFILENAME*/
/* verilator lint_off PINMISSING */

`include "global_defines.sv"

module simple_ram(
    input [2:0] device_select,
    input clk,
    input [15:0] addr_in,
    input we,
    input oe,
    input [7:0] data_in,
    output reg [7:0] data_out
    );

    parameter device_address = 3'b001;

    reg [7:0] mem [0:255];

    initial begin
        mem[0] = `NOP;
        mem[1] = `LDAI;
        mem[2] = 8'h03; // Enable RX and TX
        mem[3] = `STA;
        mem[4] = 8'hF0; // On UART CR
        mem[5] = 8'h00;
        mem[6] = `LDBI; // Load index into B
        mem[7] = 8'h80; // Start of string

        // Start of loop
        mem[8] = `LDA;



        mem[128] = "H";
        mem[129] = "e";
        mem[130] = "l";
        mem[131] = "l";
        mem[132] = "o";
        mem[133] = " ";
        mem[134] = "W";
        mem[135] = "o";
        mem[136] = "r";
        mem[137] = "l";
        mem[138] = "d";
        mem[139] = "!";
        mem[140] = "\n";
        mem[141] = "\r";
        mem[140] = 8'h00;

    end

    assign data_out = (oe && (device_address == device_select)) ? mem[addr_in[7:0]] : 8'hZZ;

    always @(posedge clk)
    begin
        if (we && (device_address == device_select))
            mem[addr_in[7:0]] <= data_in;
    end
endmodule

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
        mem[6] = `LDAI; // Load 0x02 into A
        mem[7] = 8'h02;
        mem[8] = `LDB; // Load [0xFF] into B
        mem[9] = 8'h00;
        mem[10] = 8'hFF;
        mem[11] = `ADD; // Add A + B
        mem[12] = `STA; // Store A into [0xFF]
        mem[13] = 8'h00;
        mem[14] = 8'hFF;
        mem[15] = `LDA; // Load [0xFE] into A
        mem[16] = 8'h00;
        mem[17] = 8'hFE;
        mem[18] = `LDBI; // Load 0x01 into B
        mem[19] = 8'h01;
        mem[20] = `SUB; // Subtract A - B
        mem[21] = `STA; // Store A into [0xFE]
        mem[22] = 8'h00;
        mem[23] = 8'hFE;
        mem[24] = `JNZ; // If result of SUB was not zero, jump to 0x00
        mem[25] = 8'h00;
        mem[26] = 8'h00;
        mem[27] = `LDAI; // Load 0x02 into A
        mem[28] = 8'h00;
        mem[29] = `STA; // Store A into [0xFF]
        mem[30] = 8'h00;
        mem[31] = 8'hFF;
        mem[32] = `STA; // Store A into [0xFE]
        mem[33] = 8'h00;
        mem[34] = 8'hFE;
        mem[35] = `JMP; // Jump to 0x00
        mem[36] = 8'h00;
        mem[37] = 8'h00;

        mem[8'hFE] = 8'h80;
        mem[8'hFF] = 8'h00;

    end

    assign data_out = (oe && (device_address == device_select)) ? mem[addr_in[7:0]] : 8'hZZ;

    always @(posedge clk)
    begin
        if (we && (device_address == device_select))
            mem[addr_in[7:0]] <= data_in;
    end
endmodule

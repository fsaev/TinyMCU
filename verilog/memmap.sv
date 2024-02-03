/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN*/
/* verilator lint_off DECLFILENAME*/
/* verilator lint_off PINMISSING */



module memmap(input [15:0] addr_in, output reg [15:0] translated_addr_out, output [2:0] device_select);


always_comb begin
        if(addr_in > 16'h0000 && addr_in <= 16'h00FF) begin // 0x0000 - 0x00FF
            device_select = 3'b001;
            translated_addr_out = addr_in;
        end else if(addr_in >= 16'h0100 && addr_in <= 16'hEFFF) begin // 0x0100 - 0xEFFF
            device_select = 3'b010;
            translated_addr_out = addr_in - 16'h0100;
        end else if(addr_in >= 16'hF000 && addr_in <= 16'hF010) begin // 0xF000 - 0xF00F
            device_select = 3'b011;
            translated_addr_out = addr_in - 16'hF000;
        end else if(addr_in > 16'hF010 && addr_in < 16'hFFFF) begin // 0xF010 - 0xFFFF
            device_select = 3'b100;
            translated_addr_out = addr_in - 16'hF011;
        end else begin // 0x0000 (Or out of range)
            device_select = 3'b000;
            translated_addr_out = 16'h0000;
        end
end


endmodule

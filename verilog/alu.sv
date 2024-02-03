/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN*/
/* verilator lint_off DECLFILENAME*/

`include "global_defines.sv"

module alu(input clk, input reset, input wire [7:0] a, input wire [7:0] b, input wire [7:0] mode, output reg [7:0] out, output reg carry, output reg zero);

    // ALU mode is persistent until pipeline resets at the beginning of a new ALU operation
    // This persistence is used for when doing conditional jumps
    reg [7:0] alu_mode;
    always_ff @(posedge clk) begin
        if(mode != `ALU_NON)
            alu_mode <= mode;
        if(reset)
            alu_mode <= `ALU_NON;
    end

    always_comb
    begin
        case (alu_mode)
            `ALU_ADD: begin // ADD
                out = a + b;
                carry = (out[7] == 1'b1);
                zero = (out == 8'h00);
            end
            `ALU_SUB: begin // SUB
                out = a - b;
                carry = (out[7] == 1'b1);
                zero = (out == 8'h00);
            end
            `ALU_AND: begin // AND
                out = a & b;
                carry = 1'b0;
                zero = (out == 8'h00);
            end
            `ALU_OR: begin // OR
                out = a | b;
                carry = 1'b0;
                zero = (out == 8'h00);
            end
            `ALU_XOR: begin // XOR
                out = a ^ b;
                carry = 1'b0;
                zero = (out == 8'h00);
            end
            `ALU_NOT: begin // NOT
                out = ~a;
                carry = 1'b0;
                zero = (out == 8'h00);
            end
            `ALU_SHL: begin // SHL
                out = a << 1;
                carry = a[7];
                zero = (out == 8'h00);
            end
            `ALU_SHR: begin // SHR
                out = a >> 1;
                carry = a[0];
                zero = (out == 8'h00);
            end
            default: begin
                out = 8'h00;
                carry = 1'b0;
                zero = 1'b0;
            end
        endcase
    end
endmodule

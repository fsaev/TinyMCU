`define DIG_0 8'b00111111
`define DIG_1 8'b00000110
`define DIG_2 8'b01011011
`define DIG_3 8'b01001111
`define DIG_4 8'b01100110
`define DIG_5 8'b01101101
`define DIG_6 8'b01111101
`define DIG_7 8'b00000111
`define DIG_8 8'b01111111
`define DIG_9 8'b01101111
`define DIG_A 8'b01110111
`define DIG_B 8'b01111100
`define DIG_C 8'b00111001
`define DIG_D 8'b01011110
`define DIG_E 8'b01111001
`define DIG_F 8'b01110001

module seg(input clk_in,
            input [15:0] value,
            output wire [3:0] digit_select_out,
            output wire [7:0] segment_output);

    reg [3:0] digit_select;
    assign digit_select_out = ~digit_select;

    reg [7:0] segment_composition;
    assign segment_output = ~segment_composition;

    always_ff @(posedge clk_in) begin
        if (digit_select == 4'b1000 || digit_select == 4'b0000)
            digit_select <= 4'b0001;
        else
            digit_select <= digit_select << 1;
    end

    always_comb begin
        case (digit_select) // Select digit
            4'b0001: begin
                case (value[3:0]) // Select segment
                    4'h0: segment_composition = `DIG_0;
                    4'h1: segment_composition = `DIG_1;
                    4'h2: segment_composition = `DIG_2;
                    4'h3: segment_composition = `DIG_3;
                    4'h4: segment_composition = `DIG_4;
                    4'h5: segment_composition = `DIG_5;
                    4'h6: segment_composition = `DIG_6;
                    4'h7: segment_composition = `DIG_7;
                    4'h8: segment_composition = `DIG_8;
                    4'h9: segment_composition = `DIG_9;
                    4'ha: segment_composition = `DIG_A;
                    4'hb: segment_composition = `DIG_B;
                    4'hc: segment_composition = `DIG_C;
                    4'hd: segment_composition = `DIG_D;
                    4'he: segment_composition = `DIG_E;
                    4'hf: segment_composition = `DIG_F;
                    default: segment_composition = 8'b00000000;
                endcase
            end
            4'b0010: begin
                case (value[7:4]) // Select segment
                    4'h0: segment_composition = `DIG_0;
                    4'h1: segment_composition = `DIG_1;
                    4'h2: segment_composition = `DIG_2;
                    4'h3: segment_composition = `DIG_3;
                    4'h4: segment_composition = `DIG_4;
                    4'h5: segment_composition = `DIG_5;
                    4'h6: segment_composition = `DIG_6;
                    4'h7: segment_composition = `DIG_7;
                    4'h8: segment_composition = `DIG_8;
                    4'h9: segment_composition = `DIG_9;
                    4'ha: segment_composition = `DIG_A;
                    4'hb: segment_composition = `DIG_B;
                    4'hc: segment_composition = `DIG_C;
                    4'hd: segment_composition = `DIG_D;
                    4'he: segment_composition = `DIG_E;
                    4'hf: segment_composition = `DIG_F;
                    default: segment_composition = 8'b00000000;
                endcase
            end
            4'b0100: begin
                case (value[11:8]) // Select segment
                    4'h0: segment_composition = `DIG_0;
                    4'h1: segment_composition = `DIG_1;
                    4'h2: segment_composition = `DIG_2;
                    4'h3: segment_composition = `DIG_3;
                    4'h4: segment_composition = `DIG_4;
                    4'h5: segment_composition = `DIG_5;
                    4'h6: segment_composition = `DIG_6;
                    4'h7: segment_composition = `DIG_7;
                    4'h8: segment_composition = `DIG_8;
                    4'h9: segment_composition = `DIG_9;
                    4'ha: segment_composition = `DIG_A;
                    4'hb: segment_composition = `DIG_B;
                    4'hc: segment_composition = `DIG_C;
                    4'hd: segment_composition = `DIG_D;
                    4'he: segment_composition = `DIG_E;
                    4'hf: segment_composition = `DIG_F;
                    default: segment_composition = 8'b00000000;
                endcase
            end
            4'b1000: begin
                case (value[15:12]) // Select segment
                    4'h0: segment_composition = `DIG_0;
                    4'h1: segment_composition = `DIG_1;
                    4'h2: segment_composition = `DIG_2;
                    4'h3: segment_composition = `DIG_3;
                    4'h4: segment_composition = `DIG_4;
                    4'h5: segment_composition = `DIG_5;
                    4'h6: segment_composition = `DIG_6;
                    4'h7: segment_composition = `DIG_7;
                    4'h8: segment_composition = `DIG_8;
                    4'h9: segment_composition = `DIG_9;
                    4'ha: segment_composition = `DIG_A;
                    4'hb: segment_composition = `DIG_B;
                    4'hc: segment_composition = `DIG_C;
                    4'hd: segment_composition = `DIG_D;
                    4'he: segment_composition = `DIG_E;
                    4'hf: segment_composition = `DIG_F;
                    default: segment_composition = 8'b00000000;
                endcase
            end
            default: segment_composition = 8'b00000000;
        endcase
    end
endmodule

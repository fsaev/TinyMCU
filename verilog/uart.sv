/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN*/

module uart(   input [2:0] device_select,
               input clk,
               input [7:0] mmio_data_in,
               input [15:0] mmio_addr,
               input mmio_wr,
               input mmio_rd,
               input reg rx,
               output reg tx,
               output reg [7:0] mmio_data_out
);

parameter device_address = 3'b011;

/* UART State Machine */
typedef enum logic [2:0] {
    IDLE,
    LOAD_DATA_OUT,
    SHIFT_OUT_BYTE
} tx_state_e;

/* Peripheral registers */
reg [7:0] CR = 0; // [x][x][x][x][P_H][P_L][TXE][RXE]
reg [7:0] SR = 0; // [x][x][x][x][x][x][TXR][RXR]
reg [7:0] CDIV_H = 0; // [15][14][13][12][11][10][9][8]
reg [7:0] CDIV_L = 0; // [7][6][5][4][3][2][1][0] Clock divider
reg [7:0] DI = 0; // [7:0] Data in
reg [7:0] DO = 0; // [7:0] Data out

reg [9:0] DO_byte_out = 0;
reg [3:0] DO_bit_cnt = 0;

reg [7:0] DI_shift_reg [0:7];

tx_state_e tx_state;

/* Address mapping */
always_ff @(posedge clk) begin
    if(device_select == device_address) begin
        if(mmio_wr) begin
            case(mmio_addr)
                16'h0000: CR <= mmio_data_in;
                16'h0001: begin end // SR is read only
                16'h0002: CDIV_H <= mmio_data_in;
                16'h0003: CDIV_L <= mmio_data_in;
                16'h0004: begin end // DI is read only
                16'h0005: DO <= mmio_data_in;
                default: begin end // Do nothing
            endcase
        end

        if(mmio_rd) begin
            case(mmio_addr)
                16'h0000: mmio_data_out <= CR;
                16'h0001: mmio_data_out <= SR;
                16'h0002: mmio_data_out <= CDIV_H;
                16'h0003: mmio_data_out <= CDIV_L;
                16'h0004: mmio_data_out <= DI;
                16'h0005: mmio_data_out <= DO;
                default:  begin end // Do nothing
            endcase
        end
    end
end

/* Status Register */
always_comb begin
    SR[0] <= !(DI & 8'hFF); // If DI contains any bits, TXR is clear
    SR[1] <= (DO_bit_cnt == 3'b000); // If bitcount is 0 RXR is clear
end

always_ff @(posedge clk) begin
    if(device_select == device_address) begin

        /* Load byte out */
        if(CR[0]) begin // TX Enabled
            if(SR[0] && DO) begin // TX Ready
                SR[0] <= 0;
                DO_byte_out <= DO;
            end
        end

        // TX State Machine
        case(tx_state)
            IDLE: begin
                // State transition conditions and actions
            end
            LOAD_DATA_OUT: begin
                DO_byte_out[10] <= 1; // Start bit
                DO_byte_out[9:1] <= DO[7:0];
                DO_byte_out[0] <= 0; // Stop bit

                D0_bit_cnt <= 3'b000;
                tx_state <= SHIFT_OUT_BYTE;
            end
            SHIFT_OUT_BYTE: begin
                // State transition conditions and actions
            end
            default: begin
                // Default state
            end
        endcase

    end
end
//         cnt <= cnt + 1;
// end

endmodule



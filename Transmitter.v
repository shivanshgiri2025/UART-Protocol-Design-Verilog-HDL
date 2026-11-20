
`timescale 1ns / 1ps

module Transmitter(
    input clk,
    input wr_en,
    input rst,
    input enb,
    input [7:0] data_in,
    output reg tx,
    output busy
);

    parameter idle_state  = 2'b00;
    parameter start_state = 2'b01;
    parameter data_state  = 2'b10;
    parameter stop_state  = 2'b11;

    reg [7:0] data;
    reg [2:0] index;
    reg [1:0] state;

    // Transmitter sequential logic
    always @(posedge clk) begin
        if (rst) begin
            tx    <= 1'b1;
            state <= idle_state;
            index <= 3'b000;
            data  <= 8'b00000000;
        end
        else begin
            case (state)

                // Idle state
                idle_state: begin
                    if (wr_en) begin
                        state <= start_state;
                        data  <= data_in;
                        index <= 3'b000;
                    end
                end

                // Start bit
                start_state: begin
                    if (enb) begin
                        tx    <= 1'b0;
                        state <= data_state;
                    end
                end

                // Data transmission
                data_state: begin
                    if (enb) begin
                        tx <= data[index];

                        if (index == 3'd7)
                            state <= stop_state;
                        else
                            index <= index + 1'b1;
                    end
                end

                // Stop bit
                stop_state: begin
                    if (enb) begin
                        tx    <= 1'b1;
                        state <= idle_state;
                    end
                end

                default: begin
                    tx    <= 1'b1;
                    state <= idle_state;
                end

            endcase
        end
    end

    assign busy = (state != idle_state);

endmodule

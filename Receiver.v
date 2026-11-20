
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 22:44:50
// Design Name: 
// Module Name: Receiver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module Receiver(
    input clk,
    input rst,
    input rx,
    input rdy_clr,
    input clk_en,
    output reg rdy,
    output reg [7:0] data_out
);

    parameter start_state    = 2'b00;
    parameter data_out_state = 2'b01;
    parameter stop_state     = 2'b10;

    reg [1:0] state;
    reg [3:0] sample;
    reg [3:0] index;
    reg [7:0] temp_register;

    // Receiver sequential logic
    always @(posedge clk) begin

        if (rst) begin
            rdy           <= 1'b0;
            data_out      <= 8'b0;
            state         <= start_state;
            sample        <= 4'b0;
            index         <= 4'b0;
            temp_register <= 8'b0;
        end

        else begin

            if (rdy_clr)
                rdy <= 1'b0;

            if (clk_en) begin

                case (state)

                    // Start bit detection
                    start_state: begin
                        if (rx == 1'b0) begin
                            sample <= sample + 1'b1;

                            if (sample == 4'hF) begin
                                state         <= data_out_state;
                                sample        <= 4'b0;
                                index         <= 4'b0;
                                temp_register <= 8'b0;
                            end
                        end
                        else begin
                            sample <= 4'b0;
                        end
                    end

                    // Data reception
                    data_out_state: begin
                        sample <= sample + 1'b1;

                        if (sample == 4'h8) begin
                            temp_register[index] <= rx;
                            index <= index + 1'b1;
                        end

                        if (index == 4'd8 && sample == 4'hF)
                            state <= stop_state;
                    end

                    // Stop bit detection
                    stop_state: begin
                        sample <= sample + 1'b1;

                        if (sample == 4'hF) begin
                            state    <= start_state;
                            data_out <= temp_register;
                            rdy      <= 1'b1;
                            sample   <= 4'b0;
                        end
                    end

                    default: begin
                        state <= start_state;
                        sample <= 4'b0;
                    end

                endcase
            end
        end
    end

endmodule
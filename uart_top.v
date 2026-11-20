`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2026 22:09:34
// Design Name: 
// Module Name: uart_top
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

module uart_top(
    input rst,
    input [7:0] data_in,
    input wr_en,
    input clk,
    input rdy_clr,
    output rdy,
    output busy,
    output [7:0] data_out
);

    // Internal wires
    wire rx_clk_en;
    wire tx_clk_en;
    wire tx_temp;

    // Baud Rate Generator
    Baud_Rate_Generator bg (
        .clk(clk),
        .rst(rst),
        .tx_clk_en(tx_clk_en),
        .rx_clk_en(rx_clk_en)
    );

    // Transmitter
    Transmitter us (
        .clk(clk),
        .wr_en(wr_en),
        .rst(rst),
        .enb(tx_clk_en),
        .data_in(data_in),
        .tx(tx_temp),
        .busy(busy)
    );

    // Receiver
    Receiver ur (
        .clk(clk),
        .rst(rst),
        .rx(tx_temp),
        .rdy_clr(rdy_clr),
        .clk_en(rx_clk_en),
        .rdy(rdy),
        .data_out(data_out)
    );

endmodule
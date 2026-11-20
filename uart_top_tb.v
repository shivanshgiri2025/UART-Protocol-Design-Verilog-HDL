
`timescale 1ns / 1ps

module uart_top_tb;

    reg clk;
    reg rst;
    reg [7:0] data_in;
    reg wr_en;
    reg rdy_clr;

    wire rdy;
    wire busy;
    wire [7:0] dout;

    // DUT instantiation
    uart_top uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .wr_en(wr_en),
        .rdy_clr(rdy_clr),
        .rdy(rdy),
        .busy(busy),
        .data_out(dout)
    );

    // Clock generation (100 MHz)
    always #5 clk = ~clk;

    // Send byte task
    task send_byte(input [7:0] din);
        begin
            wait(!busy);

            @(negedge clk);
            data_in = din;
            wr_en = 1'b1;

            @(negedge clk);
            wr_en = 1'b0;
        end
    endtask

    // Clear ready flag
    task clear_ready;
        begin
            @(negedge clk);
            rdy_clr = 1'b1;

            @(negedge clk);
            rdy_clr = 1'b0;
        end
    endtask

    // Test stimulus
    initial begin

        clk     = 1'b0;
        rst     = 1'b1;
        wr_en   = 1'b0;
        rdy_clr = 1'b0;
        data_in = 8'h00;

        // Apply reset
        repeat (5) @(negedge clk);
        rst = 1'b0;

        // Send character A
        send_byte(8'h41);

        wait(busy);
        wait(!busy);
        wait(rdy);

        $display("Time=%0t | Received=%h | Character=%c",
                  $time, dout, dout);

        if (dout == 8'h41)
            $display("TEST 1 PASSED");
        else
            $display("TEST 1 FAILED");

        clear_ready();

        // Send character V
        send_byte(8'h56);

        wait(busy);
        wait(!busy);
        wait(rdy);

        $display("Time=%0t | Received=%h | Character=%c",
                  $time, dout, dout);

        if (dout == 8'h56)
            $display("TEST 2 PASSED");
        else
            $display("TEST 2 FAILED");

        clear_ready();

        #500;
        $finish;

    end

endmodule

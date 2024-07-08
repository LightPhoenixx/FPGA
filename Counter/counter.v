`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2024 14:49:19
// Design Name: 
// Module Name: Counter
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


//module top_module (
//    input wire clk,              // Clock input
//    input wire reset,            // Reset input
//    output wire [3:0] led        // LED outputs
//);

//    // Instantiate the led_counter module
//    led_counter counter (
//        .clk(clk),
//        .reset(reset),
//        .led(led)
//    );

//endmodule

//module led_counter(
//    input wire clk,              // Clock input
//    input wire reset,            // Reset input
//    output reg [3:0] led         // LED outputs
//);

//    // 4-bit counter
//    reg [3:0] counter = 4'b0000;

//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            counter <= 4'b0000;   // Reset counter to 0
//        end else begin
//            counter <= counter + 1; // Increment counter
//        end
//    end

//    // Assign counter value to LED outputs
//    always @(posedge clk) begin
//        led <= counter;
//    end

//endmodule

module top_module (
    input wire clk,             // Main clock input
    input wire reset,           // Reset input
    output wire [3:0] led       // LED outputs
);

    wire slow_clk;

    // Instantiate the clock divider
    clock_divider clk_div (
        .clk_in(clk),
        .reset(reset),
        .clk_out(slow_clk)
    );

    // Instantiate the LED sequencer
    led_sequencer led_seq (
        .clk(slow_clk),
        .reset(reset),
        .led(led)
    );

endmodule

module clock_divider(
    input wire clk_in,          // Input clock (e.g., 100 MHz)
    input wire reset,           // Reset signal
    output reg clk_out          // Divided clock output
);

    // Assuming the input clock is 100 MHz and we need a 0.5 Hz clock (2-second period)
    localparam DIVISOR = 50_000_000; // 100 MHz / 0.5 Hz = 200_000_000 / 2 = 100_000_000

    reg [31:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else if (counter == (DIVISOR - 1)) begin
            counter <= 0;
            clk_out <= ~clk_out; // Toggle the output clock
        end else begin
            counter <= counter + 1;
            clk_out <= clk_out;
        end
    end

endmodule

module led_sequencer(
    input wire clk,             // Slow clock input
    input wire reset,           // Reset input
    output reg [3:0] led        // LED outputs
);

    // State machine to control which LED is on
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            led <= 4'b0001;
        end else begin
            case (state)
                2'd0: begin
                    led <= 4'b0001; // LED0
                    state <= 2'd1;
                end
                2'd1: begin
                    led <= 4'b0010; // LED1
                    state <= 2'd2;
                end
                2'd2: begin
                    led <= 4'b0100; // LED2
                    state <= 2'd3;
                end
                2'd3: begin
                    led <= 4'b1000; // LED3
                    state <= 2'd0;
                end
                default: begin
                    led <= 4'b0001;
                    state <= 2'd0;
                end
            endcase
        end
    end

endmodule
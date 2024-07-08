`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire [3:0] led;

    // Instantiate the top module
    top_module uut (
        .clk(clk),
        .reset(reset),
        .led(led)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock (10 ns period)
    end

    // Stimulus
    initial begin
        // Initialize Inputs
        reset = 1;

        // Wait for global reset to finish
        #100;
        reset = 0;

        // Wait some time to observe LED sequence
        #100000000; // Wait 1 second

        // Reset the system
        reset = 1;
        #20;
        reset = 0;

        // Wait some time to observe LED sequence again
        #100000000; // Wait 1 second

        // Finish simulation
        $stop;
    end

endmodule

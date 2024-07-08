`timescale 1ns / 1ps

module half_adder_test;

reg a;
reg b;
wire sum,carry;
half_adder uut(.A(a), .B(b) , .SUM(sum) , .CARRY(carry));
initial begin
    #10;
    $monitor("a = %d , b = %d , sum = %d , carry = %d" , a,b,sum,carry);
    a = 1'b0 ; b = 1'b0; #100;
    a = 1'b0 ; b = 1'b1; #100;
    a = 1'b1 ; b = 1'b1; #100;
    a = 1'b1 ; b = 1'b0; #100;
    #10;
    $finish;
    end
endmodule

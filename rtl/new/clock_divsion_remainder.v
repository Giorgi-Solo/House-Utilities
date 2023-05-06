`timescale 1ns / 1ps
// dividend is to be divided by divisor

module clock_divsion_remainder(
input CLK,
input [6:0] dividend,divisor, 
output reg [6:0] quotient, remainder);

reg [6:0] first_term, second_term,result;// dividend, divisor, result of division

always @(dividend or divisor) begin //whenever we have new dividend or divisor
first_term = dividend;
second_term = divisor;
result = 0;
end

always @(CLK) begin 
if(dividend<divisor) begin // if dividend<divisor, quotient is 0 and remainder is dividend
quotient = 0;
remainder = dividend; 
end//if
else if(dividend==divisor) begin // if they equal, quotient is 1 and remainder 0
quotient = 1;
remainder = 0; 
end//els if
else begin
    if(first_term>second_term) begin // subtract divisor from dividend untill divend  becomes less or equal to dividend
    first_term = first_term - second_term; 
    result = result+1; // after each difference, increase result. 
    end
    else if(first_term==second_term) begin // if dividend becomes the same as divisor, dividend is divisible by divisor
    quotient = result+1; // result is result so far + 1
    remainder = 0; // rmainder 0
    end
    else begin
    quotient = result; // output quotient
    remainder = first_term; // output remainder
    end
end
end
endmodule

`timescale 1ns / 1ps


module leap_year_detector(
input [3:0] millenia, century, decade, year,
output reg leap_year);

wire  [6:0] upper2;
wire  [6:0] lower2;

assign lower2=decade*10+year; // last two digits of year if year is 1234, lower2 is 23
assign upper2=millenia*10+century; // first two digts of year. if year is 1234, upper2 is 12 

always @(*) begin // if number is divisible by 4, its last two digits are 00
if((decade==0)&(year==0)) begin // if the year is century year, 1900,12800...,upper2 should be divisible by 4
leap_year = upper2[1:0]==(2'b00); // leap year
end
else if(lower2[1:0]==(2'b00)) begin // not century year, if low2 is divisible by 4
leap_year = 1; // leap year
end
else begin
leap_year=0; // no leap year
end
end
endmodule

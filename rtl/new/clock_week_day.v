`timescale 1ns / 1ps

// Determine weekday using John H Conway's algorith
// each day has its own number
// sun 0 |mon  1| tue 2 |wed 3 |th 4 |fr 5 |sat - 6

module clock_week_day(
input Is_Leap_Year,CLK, // clock signal and signal telling if year is leap
input [3:0] clock_day,clock_10day,clock_1month,clock_10month,clock_year,clock_decade,clock_century, clock_millenia,
output [2:0] weekday);// output

wire [4:0] day; // this represents day
wire [4:0] month; // this represents month
wire [6:0] year_2_least_signif;//this is last two digits of year 34 out of 1234
wire [6:0] year_2_most_signif;//this is most two digits of year 12 out of 1234

assign day = clock_day + clock_10day*10;
assign month = clock_1month + clock_10month*10;
assign year_2_least_signif = clock_year + clock_decade*10;
assign year_2_most_signif = clock_century + clock_millenia*10;

wire [2:0] century_code; // this is century code 

assign century_code =  // choosing doomsdays based on century
    (year_2_most_signif[1:0]==0) ? 2: // if last two bits of year_2_most_signifis 0, century code is 2
    (year_2_most_signif[1:0]==1) ? 0:// if last two bits of year_2_most_signifis 1, century code is 0
    (year_2_most_signif[1:0]==2) ? 5:// if last two bits of year_2_most_signifis 2, century code is 5
    (year_2_most_signif[1:0]==3) ? 3: 2'bx;// if last two bits of year_2_most_signifis 3, century code is 3

wire [6:0] division_of_year_2_least_signif_by_12; // this is us an integer part of ratio of year_2_least_signif and 12
wire [6:0] remainder_of_division_of_year_2_least_signif_by_12; // this is us an remainder of ratio of year_2_least_signif and 12

clock_divsion_remainder clock_divsion_remainder00(.CLK(CLK),.dividend(year_2_least_signif),.divisor(12),
.quotient(division_of_year_2_least_signif_by_12),.remainder(remainder_of_division_of_year_2_least_signif_by_12)); // year by 12
//year_2_least_signif

wire [6:0] qoution_of_remainder_by_4;// this is us an integer part of ratio of remainder_of_division_of_year_2_least_signif_by_12 and 4
assign qoution_of_remainder_by_4 = remainder_of_division_of_year_2_least_signif_by_12>>2;

wire [7:0] sum; // this of all four things calculated above
assign sum = century_code + division_of_year_2_least_signif_by_12 + remainder_of_division_of_year_2_least_signif_by_12 + qoution_of_remainder_by_4;

wire [2:0] Doomsday_of_year; // this is doomsday of the year, remainder of sum/7
clock_divsion_remainder clock_divsion_remainder01(.CLK(CLK),.dividend(sum),.divisor(7),
.remainder(Doomsday_of_year)); // find doomsday of the year

reg [4:0] Doomsday_of_month; // this table stores which dates are doomsdays in each month

always @(month) begin
case(month)
1: Doomsday_of_month <= 3 + Is_Leap_Year;
2: Doomsday_of_month <= 28 + Is_Leap_Year;
3: Doomsday_of_month <= 14;
4: Doomsday_of_month <= 4;
5: Doomsday_of_month <= 9;
6: Doomsday_of_month <= 6;
7: Doomsday_of_month <= 11;
8: Doomsday_of_month <= 8;
9: Doomsday_of_month <= 5;
10: Doomsday_of_month <= 10;
11: Doomsday_of_month <= 7;
12: Doomsday_of_month <= 12;
default:  Doomsday_of_month <= 'bx;
endcase
end

reg [6:0] difference; // difference of Doomsday_of_year and day. Only value withouth sign. This is always positive
//wire [2:0] remainder;
always @(Doomsday_of_year or day) begin
if(Doomsday_of_month>day) 
difference = Doomsday_of_month-day+Doomsday_of_year;
else
difference = day-Doomsday_of_month+Doomsday_of_year;
end

// remainder of difference / 7 is weekday
clock_divsion_remainder clock_divsion_remainder10(.CLK(CLK),.dividend(difference),.divisor(7),
.remainder(weekday));


endmodule

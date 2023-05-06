`timescale 1ns / 1ps

module Top_Module(
input CLK, RST,
// digital clock inputs and outputs
input set_time_enable,b_1,b_2,b_3,b_4,b_5,b_6,b_7,b_8,b_9,b_0,up,down,
output [3:0] clock_second, clock_10second, clock_1minute, clock_10minute, clock_1hour,clock_10hour,clock_day,clock_10day,clock_1month,clock_10month,clock_year, clock_decade, clock_century, clock_millenia, 
output [2:0] weekday, //tells which day it is
output [6:0] display_clock_second, display_clock_10second, display_clock_1minute, display_clock_10minute, display_clock_1hour,display_clock_10hour,
output [6:0] display_clock_day, display_clock_10day, display_clock_1month, display_clock_10month, display_clock_millenia,display_clock_century,display_clock_decade,display_clock_year,
output [19:0] display_I_letter,
output [9:0] display_II_letter,display_III_letter);


// instantiating clocks with periods 1s, 10s, 60s
wire clk_out_1; // clock woth period 1s
wire clk_out_10; // clock with period 10s
wire clk_out_60; // clock with period 60s
clock #(1) clok00(.clk_in(CLK),.clk_out(clk_out_1));// 1s
clock #(10) clok01(.clk_in(CLK),.clk_out(clk_out_10)); // 10s
clock #(60) clok10(.clk_in(CLK),.clk_out(clk_out_60)); // 60s

//   DIGITAL CLOCK /////////////////////////////////////////////////////////////////////////////////////////////////////
wire [3:0] counter_for_seconds=clock_second; // this will count secconds
wire pulse_period_10seconds;
clock_digit_counters #(5) ut00(.RST(RST),.CLKk(clk_out_1),.counter_in(counter_for_seconds),.counter_out(clock_second),.check(tmp),.pulse(pulse_period_10seconds),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));


// this will count 10 secconds/////////////////////////////////////////////////////////////////////////////////
wire [3:0] counter_for_10seconds = clock_10second; // this will count 10 secconds
wire pulse_period_1minute;
clock_digit_counters #(4) ut01(.RST(RST),.CLKk(pulse_period_10seconds),.counter_in(counter_for_10seconds),
.counter_out(clock_10second),.check(tmp),.pulse(pulse_period_1minute),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));



// this will count 1 minute/////////////////////////////////////////////////////////////////////////////////
wire [3:0] counter_for_1minute = clock_1minute; // this will count 1 minute
wire pulse_period_10minute;
clock_digit_counters #(3) ut11(.RST(RST),.CLKk(pulse_period_1minute),.counter_in(counter_for_1minute),
.counter_out(clock_1minute),.check(tmp),.pulse(pulse_period_10minute),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));


// this will count 10 minute/////////////////////////////////////////////////////////////////////////////////
wire [3:0] counter_for_10minute = clock_10minute; // this will count 10 minute
wire pulse_period_1hour;
clock_digit_counters #(2) ut100(.RST(RST),.CLKk(pulse_period_10minute),.counter_in(counter_for_10minute),
.counter_out(clock_10minute),.check(tmp),.pulse(pulse_period_1hour),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));



// this will count 1 hour/////////////////////////////////////////////////////////////////////////////////
wire [3:0] counter_for_1hour = clock_1hour; // this will count 1 hour
wire pulse_period_10hour;
clock_digit_counters #(1) ut101(.RST(RST),.CLKk(pulse_period_1hour),.counter_in(counter_for_1hour),
.counter_out(clock_1hour),.check(tmp),.pulse(pulse_period_10hour),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));
wire [3:0] tmp;
assign tmp = (clock_10hour<2);



// this will count 10 hour///////////
wire [3:0] counter_for_10hour = clock_10hour; // this will count 10 hour
wire pulse_period_24hour;
clock_digit_counters #(0) ut110(.RST(RST),.CLKk(pulse_period_10hour),.counter_in(counter_for_10hour),
.counter_out(clock_10hour),.pulse(pulse_period_24hour),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// you are HERE
wire Is_Leap_Year; //this is 1 if it is leap year
wire Is_February; // is 1 if february
wire Is_31_day; // 1 if there is 31 days in month
wire [3:0] month; //month in decimal

assign month =clock_1month + clock_10month*10;
assign  Is_31_day = (month==1)|(month==3)|(month==5)|(month==7)|(month==8)|(month==10)|(month==12); // 
assign Is_February = month==2; 
leap_year_detector leap_year_detector00(.millenia(clock_millenia),.century(clock_century),.decade(clock_decade),.year(clock_year),.leap_year(Is_Leap_Year));//determine if we have leap year

wire pulse_period_10days; // becomes 1 when 10day digit change
wire pulse_period_month; // becomes 1 when month digit changeonce in a month
wire pulse_period_10month; // becoms 1 when 10month digit change
wire pulse_period_year; // becomes 1 at new year

// counters for mm/dd and four pulses mentine in lines 69-72
clock_mm_dd_counters clock_mm_dd_counters00(.Is_Leap_Year(Is_Leap_Year),.Is_February(Is_February),.Is_31_day(Is_31_day),.pulse_period_24hour(pulse_period_24hour),
.RST(RST),.counter_for_clock_day(clock_day),.counter_for_clock_10day(clock_10day),.counter_for_clock_month(clock_1month),.counter_for_clock_10month(clock_10month),
.pulse_period_10days(pulse_period_10days),.pulse_period_month(pulse_period_month),.pulse_period_10month(pulse_period_10month),.pulse_period_year(pulse_period_year),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));

wire pulse_period_decade; // becomes 1 once in a decade
wire pulse_period_century; // becomes 1 once in a century
wire pulse_period_millenia; // becoms 1 once in a millenia

// counters for years            
clock_year_YY #(.reset(9),.which_digit(13)) YEARS(.CLK_for_year(pulse_period_year),.RST(RST),.counter_for_clock_year_or_dec_or_cen_mill(clock_year),.pulse_from_year(pulse_period_decade),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));

clock_year_YY #(.reset(9),.which_digit(12)) DECADE(.CLK_for_year(pulse_period_decade),.RST(RST),.counter_for_clock_year_or_dec_or_cen_mill(clock_decade),.pulse_from_year(pulse_period_century),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));

clock_year_YY #(.reset(9),.which_digit(11)) CENTURY(.CLK_for_year(pulse_period_century),.RST(RST),.counter_for_clock_year_or_dec_or_cen_mill(clock_century),.pulse_from_year(pulse_period_millenia),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));

clock_year_YY #(.reset(1),.which_digit(10)) MILLENIA(.CLK_for_year(pulse_period_millenia),.RST(RST),.counter_for_clock_year_or_dec_or_cen_mill(clock_millenia),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));

//determining weekday
clock_week_day clock_week_daymodule00(.Is_Leap_Year(Is_Leap_Year),.CLK(CLK),
.clock_day(clock_day),.clock_10day(clock_10day),.clock_1month(clock_1month),.clock_10month(clock_10month),
.clock_year(clock_year),.clock_decade(clock_decade),.clock_century(clock_century),.clock_millenia(clock_millenia),
.weekday(weekday));

// instantiating 7-segment BCD for time
wire ny_countdown;
assign ny_countdown = (clock_10hour==2)&(clock_1hour==3)&(clock_10minute==5)&(clock_1minute==9)&(clock_10second==5)&(month==12)&(clock_day==1)&(clock_10day==3); // 31 december 23:59:50

//ss
Clock_digit_display #(1) display_for_1second(.RST(RST),.digit_to_display(clock_second),.ny_countdown(ny_countdown),.display(display_clock_second));
Clock_digit_display #(0) display_for_10second(.RST(RST),.digit_to_display(clock_10second),.ny_countdown(ny_countdown),.display(display_clock_10second));
//mm
Clock_digit_display #(0) display_for_1minute(.RST(RST),.digit_to_display(clock_1minute),.ny_countdown(ny_countdown),.display(display_clock_1minute));
Clock_digit_display #(0) display_for_10minute(.RST(RST),.digit_to_display(clock_10minute),.ny_countdown(ny_countdown),.display(display_clock_10minute));
//hh
Clock_digit_display #(0) display_for_1hour(.RST(RST),.digit_to_display(clock_1hour),.ny_countdown(ny_countdown),.display(display_clock_1hour));
Clock_digit_display #(0) display_for_10hour(.RST(RST),.digit_to_display(clock_10hour),.ny_countdown(ny_countdown),.display(display_clock_10hour));


//DAY
Clock_digit_display #(0) display_for_day(.RST(RST),.digit_to_display(clock_day),.ny_countdown(ny_countdown),.display(display_clock_day));
Clock_digit_display #(0) display_for_10day(.RST(RST),.digit_to_display(clock_10day),.ny_countdown(ny_countdown),.display(display_clock_10day));
//MONTH
Clock_digit_display #(0) display_for_1month(.RST(RST),.digit_to_display(clock_1month),.ny_countdown(ny_countdown),.display(display_clock_1month));
Clock_digit_display #(0) display_for_10month(.RST(RST),.digit_to_display(clock_10month),.ny_countdown(ny_countdown),.display(display_clock_10month));
//YERAR
Clock_digit_display #(0) display_for_millenia(.RST(RST),.digit_to_display(clock_millenia),.ny_countdown(ny_countdown),.display(display_clock_millenia));
Clock_digit_display #(0) display_for_century(.RST(RST),.digit_to_display(clock_century),.ny_countdown(ny_countdown),.display(display_clock_century));
Clock_digit_display #(0) display_for_decade(.RST(RST),.digit_to_display(clock_decade),.ny_countdown(ny_countdown),.display(display_clock_decade));
Clock_digit_display #(0) display_for_year(.RST(RST),.digit_to_display(clock_year),.ny_countdown(ny_countdown),.display(display_clock_year));
//weekday
Clock_digit_display_weekday  Clock_digit_display_weekday00(.day_to_display(weekday),.display_I_letter(display_I_letter),.display_II_letter(display_II_letter),
.display_III_letter(display_III_letter));


endmodule

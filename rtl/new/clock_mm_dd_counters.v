`timescale 1ns / 1ps

// this module contains code that counts days and months
// variablewhich_digit determines whether it is month, or day
// m10 - which_digit = 6
// m1 - which_digit = 7
// d10 - which_digit = 8
// d1 - which_digit = 9

module clock_mm_dd_counters(
input Is_Leap_Year,Is_February,Is_31_day,pulse_period_24hour,RST,// to identify if year is leap, month is february, month has 30 or 31 days
input set_time_enable,b_1,b_2,b_3,b_4,b_5,b_6,b_7,b_8,b_9,b_0,up,down,//this is for changing value
output reg [3:0] counter_for_clock_day,counter_for_clock_10day,counter_for_clock_month,counter_for_clock_10month,//output time digit values
output reg pulse_period_10days, pulse_period_month, pulse_period_10month, pulse_period_year);//output pulses


 // this will count days
always @(posedge pulse_period_24hour or posedge RST) begin // 
if(RST) begin
counter_for_clock_day=7; //reset to 7
end //if
else if(Is_February) begin // if month is february the second digit for days - d1, days change from 01 to 28 or 29(leap)
    if((counter_for_clock_10day<2)) begin // if the first digit of day is less thatn 2, it is noth 20th feb yet
        if(counter_for_clock_day<9) begin // d1 increases up to 9
        pulse_period_10days=0; // this pulse is for the first day digit - d10, and becomes 1 when 10 days is passed - d reset. This doesnot happen here
        counter_for_clock_day=counter_for_clock_day+1; // increment day. at this point day changes from 01 to 19
        end//if    
        else begin
        pulse_period_10days=1; // second digit is reset, this pulse will be clock for the first day digit counter
        counter_for_clock_day=0; //if the first digit for days < 2 and thescond digit is 9, reset the second digit to 0.
        end//else
    end//if
    else begin // if it is february and date is more than 20
        if(counter_for_clock_day<(8+Is_Leap_Year)) begin //d can count up to 8 or 9(leap)
        pulse_period_10days=0; 
        counter_for_clock_day=counter_for_clock_day+1; 
        end//if    
        else begin
        pulse_period_10days=1;// day is reset, so set pulse for 10day digit counter
        counter_for_clock_day=1;// at this point the month changed, so i need to set the second day digit to 1. day starts at 01.
        end//else
    end//else
end//else if
else if(Is_31_day) begin // month has 31 days
    if((counter_for_clock_10day<3)) begin // day is or is less that 30
        if(counter_for_clock_day<9) begin // the second digit for day increases till 9.
        pulse_period_10days=0; // counter does not reset, so pulse is 0
        counter_for_clock_day=counter_for_clock_day+1; // increase counter. at tis point day changes from 01 to 29
        end//if    
        else begin// day is above
        pulse_period_10days=1; // //set pulse which will be used for counter of the first digit of day - d10
        counter_for_clock_day=0; // reset counter, because the last digit increase from 9 to 0.
        end//else
    end//if
    else begin // day is 30 or 31
        if(counter_for_clock_day<1) begin // if day is 30
        pulse_period_10days=0; // 
        counter_for_clock_day=counter_for_clock_day+1; // next day is 31
        end//if    
        else begin // if day is 31
        pulse_period_10days=1; // the first digit of day d10 shouls change, so pulse becomes 1
        counter_for_clock_day=1; // we have a new month, that starts at 01. That is why reset to 1, not  to0.
        end//else
    end//else
end//else if
else begin // month has 30 days
    if(counter_for_clock_day<9) begin //counter is less than 9
    pulse_period_10days=0; // no pulse for the first digit of days yet
    counter_for_clock_day=counter_for_clock_day+1; // increment last digit of day
    end//if    
    else begin // if day is 09 or 19 or 29
    pulse_period_10days=1; // pulse for the first digit of day
    counter_for_clock_day=0;//set the last digit for day to 0 // I do not have 31 days, which is followed by 01. I do not have two consecutive 1s
    end//else 
end//else 
end //always

// this will count ten days/
always @(posedge pulse_period_10days or posedge RST) begin
if(RST) begin
counter_for_clock_10day=0; // reset to 0
end //if
else if(Is_February) begin // month is february
    if(counter_for_clock_10day<2) begin // the first digit for days changes from 0 to 2. Day is below 20
    pulse_period_month=0; // this will be clock for always of the last digit of month
    counter_for_clock_10day=counter_for_clock_10day+1; //increase 10days - the first digit of day
    end//if
    else begin // day is 28(9)
    pulse_period_month=1; //month changed. Spring has come
    counter_for_clock_10day=0;//that is why the first digit became 0. 
    end//else
end // else if
else begin // not february
    if(counter_for_clock_10day<3) begin // if day is less than 30
    pulse_period_month=0; // month should not change yet
    counter_for_clock_10day=counter_for_clock_10day+1;//increment the first digit of day
    end//if
    else begin // day is 30 or 31
    pulse_period_month=1; // month should change
    counter_for_clock_10day=0; // set the first digit of month to 0. because we have a new month.
    end//else // there is a problem if month has only 30 days. after 30 day, the first digit does not resets. The following always corrects it
end // else  // 
end//always

always @(negedge pulse_period_10days) begin // this marks end of month with 30 days.
if((counter_for_clock_10day==3)&(~Is_31_day)) begin/// day was 30 and needs to change, month has 30 days
counter_for_clock_10day=0; // new month, the first digit of day is 0
pulse_period_month=1; // new month
end
end

// this will count month///////
always @(posedge pulse_period_month or posedge RST) begin
if(RST) begin
counter_for_clock_month=1;  // reset to 1
end//if
else if(counter_for_clock_10month<1) begin // month is less than 10, it is not october yet
    if(counter_for_clock_month<9) begin // it is not september yet
    pulse_period_10month=0; // this will be clock for the first digit of month
    counter_for_clock_month=counter_for_clock_month+1; // month changes from 01 to 09 (jan-aug)
    end//if
    else begin
    pulse_period_10month=1; // it was september and now it should becom october
    counter_for_clock_month=0; // october has 0 for the last digit - 10
    end//else
end//else if
else begin // month is 10, 11 or 12
    if(counter_for_clock_month<2) begin // month is 10 or 11
    pulse_period_10month=0;
    counter_for_clock_month=counter_for_clock_month+1; // increment the last digit of month
    end//if
    else begin // it is december
    pulse_period_10month=1; // the first digit of month should change
    counter_for_clock_month=1; // new year, january is next - 01
    end//else
end//else 
end // always


// this will count 10months
always @(posedge pulse_period_10month or posedge RST) begin
if(RST) begin
counter_for_clock_10month=1;        ////////////reset to 0
end//if
else if(counter_for_clock_10month<1) begin // month is less than 10
counter_for_clock_10month=counter_for_clock_10month+1; // month becomes octomber
pulse_period_year=0; // this will be used as a clock for the least significant digit of year. there is no new year yet
end//elseif
else begin // new year
counter_for_clock_10month=0;
pulse_period_year=1;
end//else
end//always


wire [3:0] counter,new_value;

always @(new_value) begin
if((set_time_enable)&(counter==6)) // month_10
counter_for_clock_10month=new_value;
else if((set_time_enable)&(counter==7)) // month
counter_for_clock_month=new_value;
else if((set_time_enable)&(counter==8)) // day_10
counter_for_clock_10day=new_value;
else if((set_time_enable)&(counter==9)) // day
counter_for_clock_day=new_value;
end

clock_set_time instance10(.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down),.counter(counter),.new_value(new_value));



endmodule

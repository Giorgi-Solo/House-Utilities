`timescale 1ns / 1ps

// parameter which_digit determines whether it is hour, minute or second digit
// h10 - which_digit = 0
// h1 - which_digit = 1
// m10 - which_digit = 2
// m1 - which_digit = 3
// s10 - which_digit = 4
// s1 - which_digit = 5

module clock_digit_counters #(which_digit = 5)(
input RST, CLKk,
input [3:0] counter_in,check, //counter_in intput time digit; check is the first hour digit, I need to check it before incrementing the second hour digit
input set_time_enable,b_1,b_2,b_3,b_4,b_5,b_6,b_7,b_8,b_9,b_0,up,down,//this is for changing value
output reg [3:0] counter_out,// output time digit
output reg pulse);// clock for the time digit whose wchich_digit is current whichdigit-1

always @(posedge CLKk or posedge RST)begin
if(set_time_enable!=1) // if the user does not try to change time manually
    if(RST) begin // reset clock 
    counter_out=0;
    end//if
    else if(which_digit==0) begin // for the first hour digit 
        if(counter_in<2) begin  // the first hour value changes from 0 to 2, because of 24 hour format
        pulse=0; // becomes 1 if counter value is reseted to 0, which does not happen here
        counter_out=counter_in+1; // if first hour is 0 or 1, increment it
        end//else if
        else begin// 
        pulse=1; // counter is reseted day changed so pulse is 1. This will be clock for day counter
        counter_out=0;//if the first hour is 2 and it should change, it resets to 0, because of 24 hour format
        end//else
    end // else if for the first hour digit
    else if(which_digit==1) begin // for the second hour digit 
        if((counter_in<9)&check) begin // if the first hour digit <2, snd hour digit increases from 0 to 9.at this point time changes from 00 hours to 19 hours
        pulse=0; //becomes 1 if counter value is reseted to 0, which does not happen here
        counter_out=counter_in+1; // increment second hour digit counter
        end//else if
        else if((counter_in<3)) begin // at this point the first hour digit is 2, time is above 20 hours, the second hour digit can change from 0 to 3. 24 hour format
        pulse=0; //becomes 1 if counter value is reseted to 0, which does not happen here
        counter_out=counter_in+1;// increment second hour digit counter
        end//else if
        else begin// mid night
        pulse=1; // new day, counter is reseted. this will be clock for the first hour digit
        counter_out=0; // reset counter
        end//else
    end // else if for the second hour digit
    else begin // for seconds and minutes
        if((counter_in<9)&&((which_digit==3)|(which_digit==5))) begin // if this is for the last second or last minute digit, counter from 0 to 9
        pulse=0;
        counter_out=counter_in+1;
        end//else if
        else if((counter_in<5)&&((which_digit==2)||(which_digit==4))) begin // if this is for 10 second and 10 minute digit, counter from 0 to 5, 
        pulse=0;
        counter_out=counter_in+1;
        end//else if
        else begin// after 10s
        pulse=1;
        counter_out=0;
        end//else
    end//else    
end // always

wire [3:0] counter,new_value;

always @(new_value) begin // user entered new value
if((set_time_enable)&(counter==which_digit)) // the user trys to set time
counter_out=new_value; //output new value
end
// the following module allows user to set time.
clock_set_time instance00(.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down),.counter(counter),.new_value(new_value));

endmodule

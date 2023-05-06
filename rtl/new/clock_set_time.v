`timescale 1ns / 1ps
// b_n represents nth button on keyboard
// when set_time_enable is 1, this module will give values to time components
// up increases counter, down decreases
module clock_set_time(
input set_time_enable,b_1,b_2,b_3,b_4,b_5,b_6,b_7,b_8,b_9,b_0,up,down,// keyboard
output reg [3:0] counter,new_value); // counte for position of input digit; new_value will be assigned to digit we want to change

always @(set_time_enable) // when we deside to change time, counter becomes 0
counter=0;

always @(negedge up) // if we press up button counter increases
if(counter<13)      // counter cant be more than 13
counter=counter+1;

always @(negedge down) // if we press down button counter decreases
if(counter>0)           // counter cant be less than 0
counter=counter-1;

always @(negedge b_1) // pushing button 1 writes 1 in new value
new_value = 1;
always @(negedge b_2) // pushing button 2 writes 2 in new value
new_value = 2;
always @(negedge b_3) // pushing button 3 writes 3 in new value
new_value = 3;
always @(negedge b_4) // pushing button 4 writes 4 in new value
new_value = 4;
always @(negedge b_5) // pushing button 5 writes 5 in new value
new_value = 5;
always @(negedge b_6) // pushing button 6 writes 6 in new value
new_value = 6;
always @(negedge b_7) // pushing button 7 writes 7 in new value
new_value = 7;
always @(negedge b_8) // pushing button 8 writes 8 in new value
new_value = 8;
always @(negedge b_9) // pushing button 9 writes 9 in new value
new_value = 9;
always @(negedge b_0) // pushing button 0 writes 0 in new value
new_value = 0;


endmodule

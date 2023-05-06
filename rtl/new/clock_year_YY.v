`timescale 1ns / 1ps
// parameter which_digit determines whether it is month, or day
// millenia - which_digit = 10
// century - which_digit = 11
// decade - which_digit = 12
// year - which_digit = 13


module clock_year_YY #(parameter reset=0,which_digit=0)(
input CLK_for_year, RST,
input set_time_enable,b_1,b_2,b_3,b_4,b_5,b_6,b_7,b_8,b_9,b_0,up,down,//this is for changing value
output reg [3:0] counter_for_clock_year_or_dec_or_cen_mill,
output reg pulse_from_year);

always @(posedge CLK_for_year or posedge RST) begin
if(RST) begin
counter_for_clock_year_or_dec_or_cen_mill = reset; //reset to 0
end // if
else if(counter_for_clock_year_or_dec_or_cen_mill<9) begin
counter_for_clock_year_or_dec_or_cen_mill=counter_for_clock_year_or_dec_or_cen_mill+1; // increment counter
pulse_from_year=0; // no need for pulse
end//else if
else begin
counter_for_clock_year_or_dec_or_cen_mill=0; // ten unit is past
pulse_from_year=1; // give pulse 
end//else
end//always


wire [3:0] counter,new_value;

always @(new_value) begin // this helps user set new value
if((set_time_enable)&(counter==which_digit))
counter_for_clock_year_or_dec_or_cen_mill=new_value;
end

clock_set_time instance01(.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down),.counter(counter),.new_value(new_value));


endmodule

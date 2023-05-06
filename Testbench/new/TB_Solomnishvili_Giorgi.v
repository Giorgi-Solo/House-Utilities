`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////


module TB_Solomnishvili_Giorgi;
// chekc clocks
reg CLK;
wire clk_out_1;
wire clk_out_10;
wire clk_out_60;

clock #(1) clok00(.clk_in(CLK),.clk_out(clk_out_1));// 1s
clock #(10) clok01(.clk_in(CLK),.clk_out(clk_out_10)); // 10s
clock #(60) clok10(.clk_in(CLK),.clk_out(clk_out_60)); // 60s

initial CLK=0;
always #(1000000000*0.5*1/50) CLK=~CLK;// /60 for 60hz 1000000000

// check 7-segment BCD 
reg [3:0] digit_to_display;
reg ny_countdown_check;
wire [6:0] display;
reg [3:0] i;
Clock_digit_display #(1) digit00(.digit_to_display(digit_to_display),.ny_countdown(ny_countdown_check),.display(display));
initial begin
ny_countdown_check=0;
//digit_to_display=1;
#3; ny_countdown_check=1;
for(i=0;i<10;i=i+1) begin
digit_to_display=i;
#2;
end
end

// check qoutient remainder
reg [6:0] dividend,divisor; 
wire [6:0] quotient, remainder;

clock_divsion_remainder clock_divsion_remainder00(.CLK(CLK),.dividend(dividend),.divisor(divisor),.quotient(quotient),.remainder(remainder));
initial begin
dividend = 13;
divisor = 23; 
end

// check leap year detector
reg [3:0] milleniacheck, centurycheck, decadecheck, yearcheck;
wire leap_yearcheck;
leap_year_detector leap_year_detector00(.millenia(milleniacheck),.century(centurycheck),.decade(decadecheck),.year(yearcheck),.leap_year(leap_yearcheck));

initial begin;
milleniacheck = 1; 
centurycheck = 9; 
decadecheck = 9; 
yearcheck = 9;

clock_10monthcheck = 1; 
clock_1monthcheck = 1;
clock_10daycheck = 1;
clock_daycheck = 4;
/*
for(m_10=0;m_10<2;m_10=m_10+1) begin: waldo1
    for(m=1;m<10;m=m+1) begin: waldo2
    @(posedge CLK);
    clock_10monthcheck=m_10;
    clock_1monthcheck=m;
    if((clock_1monthcheck==2)&(clock_10monthcheck==1))
    disable waldo2;
    end
    if((clock_1monthcheck==2)&(clock_10monthcheck==1))
    disable waldo1;
end
*/
end

//check clock_week_day
reg [3:0] clock_daycheck,clock_10daycheck,clock_1monthcheck,clock_10monthcheck;
wire [2:0] weekday_check;

wire [4:0] differencecheck=clock_week_day00.difference;
wire [6:0] second_term=clock_week_day00.clock_divsion_remainder10.divisor;
wire [6:0] first_term=clock_week_day00.clock_divsion_remainder10.dividend;
wire [6:0] result=clock_week_day00.clock_divsion_remainder10.quotient;

wire [4:0] day = clock_week_day00.day; //numbers ind 10base value
wire [4:0] month = clock_week_day00.month;
wire [6:0] year_2_least_signif = clock_week_day00.year_2_least_signif;
wire [6:0] year_2_most_signif = clock_week_day00.year_2_most_signif;
wire [2:0] century_code = clock_week_day00.century_code;

wire [2:0] Doomsday_of_year=clock_week_day00.Doomsday_of_year;
wire [4:0] Doomsday_of_month=clock_week_day00.Doomsday_of_month; 
reg [3:0] m=1;
reg m_10=0;
clock_week_day clock_week_day00(.Is_Leap_Year(leap_yearcheck),.CLK(CLK),
.clock_day(clock_daycheck),.clock_10day(clock_10daycheck),.clock_1month(clock_1monthcheck),.clock_10month(clock_10monthcheck),
.clock_year(yearcheck),.clock_decade(decadecheck),.clock_century(centurycheck),.clock_millenia(milleniacheck),
.weekday(weekday_check));

// check clock_set_time

//check Top module
reg CLK, RST;
reg set_time_enable,b_1,b_2,b_3,b_4,b_5,b_6,b_7,b_8,b_9,b_0,up,down;
wire [3:0] clock_second;// digit for second
wire [3:0] clock_10second,clock_1minute, clock_10minute,clock_1hour,clock_10hour,clock_day,clock_10day,clock_1month,clock_10month,year,decade,century,millenia;
wire [2:0] weekday;
wire [6:0] display_clock_second, display_clock_10second, display_clock_1minute, display_clock_10minute, display_clock_1hour,display_clock_10hour;
wire [6:0] display_clock_day, display_clock_10day, display_clock_1month, display_clock_10month, display_clock_millenia,display_clock_century,display_clock_decade,display_clock_year;
wire [19:0] display_I_letter;
wire [9:0] display_II_letter,display_III_letter;

Top_Module ut00(.CLK(CLK),.RST(RST),.clock_second(clock_second),.clock_10second(clock_10second),.clock_1minute(clock_1minute),.clock_10minute(clock_10minute),.clock_1hour(clock_1hour),.clock_10hour(clock_10hour),
.clock_day(clock_day),.clock_10day(clock_10day),.clock_1month(clock_1month),.clock_10month(clock_10month),
.clock_year(year),.clock_decade(decade),.clock_century(century),.clock_millenia(millenia),.weekday(weekday),
.display_clock_second(display_clock_second),.display_clock_10second(display_clock_10second),.display_clock_1minute(display_clock_1minute),.display_clock_10minute(display_clock_10minute),.display_clock_1hour(display_clock_1hour),.display_clock_10hour(display_clock_10hour),
.display_clock_day(display_clock_day),.display_clock_10day(display_clock_10day),.display_clock_1month(display_clock_1month),.display_clock_10month(display_clock_10month),
.display_clock_millenia(display_clock_millenia),.display_clock_century(display_clock_century),.display_clock_decade(display_clock_decade),.display_clock_year(display_clock_year),
.display_I_letter(display_I_letter),.display_II_letter(display_II_letter),.display_III_letter(display_III_letter),
.set_time_enable(set_time_enable),.b_1(b_1),.b_2(b_2),.b_3(b_3),.b_4(b_4),.b_5(b_5),.b_6(b_6),.b_7(b_7),.b_8(b_8),
.b_9(b_9),.b_0(b_0),.up(up),.down(down));


wire tmp = ut00.pulse_period_year;
wire Is_Leap_Year= ut00.Is_Leap_Year; //this is 1 if it is leap year
wire Is_February= ut00.Is_February; // is 1 if february
wire Is_31_day= ut00.Is_31_day;
wire [4:0] difference=ut00.clock_week_daymodule00.difference;


initial begin
RST=1;set_time_enable=0;
@(posedge clk_out_1);
//@(posedge clk_out_1);
RST=0;set_time_enable=1; // counter = 0

@(posedge clk_out_1);b_1=1; // set h10 to 1
@(posedge clk_out_1);b_1=0;

@(posedge clk_out_1);up = 1; // counter =1
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_2=1; // set h to 2
@(posedge clk_out_1);b_2=0;

@(posedge clk_out_1);up = 1; // counter =2
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_3=1; // set m10 to 3
@(posedge clk_out_1);b_3=0;

@(posedge clk_out_1);up = 1; // counter =3
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_4=1; // set m to 4
@(posedge clk_out_1);b_4=0;

@(posedge clk_out_1);up = 1; // counter =4
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_5=1; // set s10 to 5
@(posedge clk_out_1);b_5=0;

@(posedge clk_out_1);up = 1; // counter =5
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_8=1; // set s to 8
@(posedge clk_out_1);b_8=0;

@(posedge clk_out_1);up = 1; // counter =6
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_0=1; // set month10 to  0
@(posedge clk_out_1);b_0=0;

@(posedge clk_out_1);up = 1; // counter =7
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_7=1; // set month to 7
@(posedge clk_out_1);b_7=0;

@(posedge clk_out_1);up = 1; // counter =8
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_2=1; // set d10 to 2
@(posedge clk_out_1);b_2=0;

@(posedge clk_out_1);up = 1; // counter =9
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_9=1; // set d to 9
@(posedge clk_out_1);b_9=0;

@(posedge clk_out_1);up = 1; // counter =10
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_2=1; // set Milen to 2
@(posedge clk_out_1);b_2=0;

@(posedge clk_out_1);up = 1; // counter =11
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_0=1; // set centurey to 0
@(posedge clk_out_1);b_0=0;

@(posedge clk_out_1);up = 1; // counter =12
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_2=1; // set decade to 2
@(posedge clk_out_1);b_2=0;

@(posedge clk_out_1);up = 1; // counter =13
@(posedge clk_out_1);up = 0;

@(posedge clk_out_1);b_0=1; // set year to 0
@(posedge clk_out_1);b_0=0;

@(posedge clk_out_1);set_time_enable=0;
end
// END of DIGITAL CLOCK

// Begin Check of Lokc
wire clock_for_locker;
assign clock_for_locker=CLK;
reg RST_For_Lock;
//reg [3:0] input_number; // this will be changed by the keyboard
reg b_1_for_lock,b_2_for_lock,b_3_for_lock,b_4_for_lock,b_5_for_lock,b_6_for_lock,b_7_for_lock,b_8_for_lock,b_9_for_lock,b_0_for_lock;// keyboard
reg OK;
reg door_is_open;
wire unlock;

wire [2:0] state_for_lock_sequence = Top_Module_For_lock00.Lock_Sequence_Detector00.state;
wire [2:0] counter_for_combination_digits = Top_Module_For_lock00.Lock_Sequence_Detector00.counter;
wire [3:0] combination [1:4] =Top_Module_For_lock00.Lock_Sequence_Detector00.combination; // this array stores correct combination
 
 Top_Module_For_lock Top_Module_For_lock00(.CLK_For_Lock(CLK),
.RST_For_Lock(RST_For_Lock),.OK(OK),.unlock(unlock),.door_is_open(door_is_open),
.b_1_for_lock(b_1_for_lock),.b_2_for_lock(b_2_for_lock),.b_3_for_lock(b_3_for_lock),.b_4_for_lock(b_4_for_lock),.b_5_for_lock(b_5_for_lock),
.b_6_for_lock(b_6_for_lock),.b_7_for_lock(b_7_for_lock),.b_8_for_lock(b_8_for_lock),.b_9_for_lock(b_9_for_lock),.b_0_for_lock(b_0_for_lock));

initial begin
RST_For_Lock = 0; door_is_open=1; // door is open, 
@(posedge CLK); RST_For_Lock=1; // reset clock states
@(posedge CLK); RST_For_Lock=0;

@(posedge CLK); b_7_for_lock=1; // setting combination 1
@(posedge CLK); b_7_for_lock=0;

@(posedge CLK); b_8_for_lock=1; // setting combination 2
@(posedge CLK); b_8_for_lock=0;

@(posedge CLK); b_9_for_lock=1; // setting combination 3
@(posedge CLK); b_9_for_lock=0;

@(posedge CLK); b_0_for_lock=1; // setting combination 4
@(posedge CLK); b_0_for_lock=0;

@(posedge CLK); door_is_open = 0; // close the door

//entering correct combination to unlock
@(posedge CLK); b_7_for_lock=1; // setting combination 1
@(posedge CLK); b_7_for_lock=0;

@(posedge CLK); b_8_for_lock=1; // setting combination 2
@(posedge CLK); b_8_for_lock=0;

@(posedge CLK); b_9_for_lock=1; // setting combination 3
@(posedge CLK); b_9_for_lock=0;

@(posedge CLK); b_9_for_lock=1; // setting combination 4
@(posedge CLK); b_9_for_lock=0;

@(posedge CLK); OK=1;
@(posedge CLK); OK=0;

//entering correct combination to unlock
@(posedge CLK); b_7_for_lock=1; // setting combination 1
@(posedge CLK); b_7_for_lock=0;

@(posedge CLK); b_8_for_lock=1; // setting combination 2
@(posedge CLK); b_8_for_lock=0;

@(posedge CLK); b_9_for_lock=1; // setting combination 3
@(posedge CLK); b_9_for_lock=0;

@(posedge CLK); b_0_for_lock=1; // setting combination 4
@(posedge CLK); b_0_for_lock=0;

@(posedge CLK); OK=1;
@(posedge CLK); OK=0;

@(posedge CLK);door_is_open=1;
@(posedge CLK);door_is_open=0;

end
// end of lock

// begin Dishwasher
wire clocl_for_dishwasher=Top_Module_For_Dishwasher00.pulse_1m;
reg POWER, START,RST_For_Dishwasher; // power and start button generates impulses
reg b_1_for_dishwasher,b_2_for_dishwasher,b_3_for_dishwasher,b_4_for_dishwasher,b_5_for_dishwasher,b_6_for_dishwasher,b_7_for_dishwasher,b_8_for_dishwasher,b_9_for_dishwasher,b_0_for_dishwasher;
wire [3:0] dishwasher_10hours,dishwasher_hours,dishwasher_10minutes,dishwasher_minutes;
wire [6:0] dishwasher_10hours_display,dishwasher_hours_display,dishwasher_10minutes_display,dishwasher_minutes_display;

Top_Module_For_Dishwasher Top_Module_For_Dishwasher00(.clocl_for_dishwasher(CLK),.POWER(POWER),.START(START),.RST_For_Dishwasher(RST_For_Dishwasher),
.b_1_for_dishwasher(b_1_for_dishwasher),.b_2_for_dishwasher(b_2_for_dishwasher),.b_3_for_dishwasher(b_3_for_dishwasher),
.b_4_for_dishwasher(b_4_for_dishwasher),.b_5_for_dishwasher(b_5_for_dishwasher),
.b_6_for_dishwasher(b_6_for_dishwasher),.b_7_for_dishwasher(b_7_for_dishwasher),
.b_8_for_dishwasher(b_8_for_dishwasher),.b_9_for_dishwasher(b_9_for_dishwasher),.b_0_for_dishwasher(b_0_for_dishwasher),
.dishwasher_10hours(dishwasher_10hours),.dishwasher_hours(dishwasher_hours),.dishwasher_10minutes(dishwasher_10minutes),.dishwasher_minutes(dishwasher_minutes),
.dishwasher_10hours_display(dishwasher_10hours_display),.dishwasher_hours_display(dishwasher_hours_display),
.dishwasher_10minutes_display(dishwasher_10minutes_display),.dishwasher_minutes_display(dishwasher_minutes_display));

wire pulse_dish=Top_Module_For_Dishwasher00.pulse;
wire power_on_dish=Top_Module_For_Dishwasher00.power_on;
wire start_begin_dish=Top_Module_For_Dishwasher00.start_begin; // if poweron is 1 - device is turned on, if start_begin is 1, the device xdoes its job
wire [2:0] position_of_digit_dish=Top_Module_For_Dishwasher00.position_of_digit;
wire [3:0] timer_value_dish=Top_Module_For_Dishwasher00.timer_value;
wire finish = Top_Module_For_Dishwasher00.finish;
initial begin
RST_For_Dishwasher = 1; // reset dishwasher
@(posedge clocl_for_dishwasher);RST_For_Dishwasher=0;

@(posedge CLK);POWER=1; // press power button
@(posedge CLK);POWER=0;

@(posedge CLK);b_1_for_dishwasher=1; // press 1
@(posedge CLK);b_1_for_dishwasher=0; // 

@(posedge CLK);b_0_for_dishwasher=1; // press 0
@(posedge CLK);b_0_for_dishwasher=0; // 

@(posedge CLK);b_0_for_dishwasher=1; // press 0
@(posedge CLK);b_0_for_dishwasher=0; // 

@(posedge CLK);b_0_for_dishwasher=1; // press 0
@(posedge CLK);b_0_for_dishwasher=0; // 

@(posedge CLK);START=1; // press start
@(posedge CLK);START=0;
@(posedge CLK);@(posedge CLK);

end
//end dishwasher-gascooker

//begin garage
wire garage_clock;
assign garage_clock=CLK;
reg open_close,smart_mode_pulse,RST_For_Garage;// open_clos push opens or closes the door, smartmode_pulse activates smart mode, 
reg Is_object; // 1 when something is inf front of the door
wire open_the_Door;

wire enable_smart_mode=Top_Module_Garage_Door00.enable_smart_mode; // enables smart mode
//wire Garage_open_the_Door=Top_Module_Garage_Door00.Garage_open_the_Door;
wire [1:0] state=Top_Module_Garage_Door00.state;

Top_Module_Garage_Door Top_Module_Garage_Door00(.open_close(open_close),.smart_mode_pulse(smart_mode_pulse),.RST_For_Garage(RST_For_Garage),.garage_clock(CLK),
.Is_object(Is_object),.open_the_Door(open_the_Door));


initial begin
RST_For_Garage=1;Is_object=0; // reset everythin
@(posedge CLK);RST_For_Garage=0;

@(posedge CLK);open_close=1; // press open-close butoon - open the door
@(posedge CLK);open_close=0;

@(posedge CLK);open_close=1; // press open-close butoon - close the door
@(posedge CLK);open_close=0;

@(posedge CLK);open_close=1; // press open-close butoon - open the door
@(posedge CLK);open_close=0;

@(posedge CLK);smart_mode_pulse=1; // activate smart mode
@(posedge CLK);smart_mode_pulse=0;

@(posedge CLK);Is_object=0; //testing state 0  - stay
@(posedge CLK);Is_object=1; //advance the state

@(posedge CLK);Is_object=1;//testing state 1 - stay
@(posedge CLK);Is_object=0; //advance the state

@(posedge CLK);Is_object=0;//testing state 2 - stay
@(posedge CLK);Is_object=1; //advance the state

@(posedge CLK);Is_object=1;//testing state 3 - stay
@(posedge CLK);Is_object=0;//advance the state


// pressing open-close button deactivates smartmode
@(posedge CLK);@(posedge CLK);@(posedge CLK);
@(posedge CLK);smart_mode_pulse=1; // activate smart mode
@(posedge CLK);smart_mode_pulse=0;

@(posedge CLK);open_close=1; // press open-close butoon - open the door
@(posedge CLK);open_close=0;

end
endmodule

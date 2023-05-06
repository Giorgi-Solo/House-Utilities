`timescale 1ns / 1ps

// this is module for lighting up LED for weekday
// SUN - 0; M - 1; T - 2; W - 3; TH - 4; F - 5; SAT - 6
module Clock_digit_display_weekday(
input [2:0] day_to_display,
output reg [19:0] display_I_letter,
output reg [9:0] display_II_letter,display_III_letter);

// for the first letter
always @(*) begin
case(day_to_display)
//                        abcdefghijklmnopqrst
0: display_I_letter = 20'b11001000010000010111; // S
1: display_I_letter = 20'b00101000000110110000; // M
2: display_I_letter = 20'b11000001000001000000; // T
3: display_I_letter = 20'b00010110110000001000; // W
4: display_I_letter = 20'b11000001000001000000; // T
5: display_I_letter = 20'b11000000000100010110; // F
6: display_I_letter = 20'b11001000010000010111; // S
default: display_I_letter=0;
endcase
end

//// for the second letter
//SUN TH SAT
always @(*) begin
case(day_to_display)
//                         abcdefghij
0: display_II_letter = 10'b1111100000; //U
4: display_II_letter = 10'b1110100001; //H
6: display_II_letter = 10'b0000011111; //A
default: display_II_letter=0;
endcase
end
// SUN - 0; M - 1; T - 2; W - 3; TH - 4; F - 5; SAT - 6

//// for the third letter
//SUN SAT
always @(*) begin
case(day_to_display)
//                          abcdefghij
0: display_III_letter = 10'b1001110101; // N
6: display_III_letter = 10'b0110001010; // T
default: display_III_letter=0;
endcase
end
endmodule

`timescale 1ns / 1ps

module Clock_digit_display #(parameter Second_Digit = 0)(
input [3:0] digit_to_display,
input ny_countdown,RST,
output reg [6:0] display);
// abcdefg


always @(*) begin
if(RST) display=7'b1111110;
else if(ny_countdown==0) begin // usual day
case(digit_to_display)
0: display = 7'b1111110;
1: display = 7'b0110000;
2: display = 7'b1101101;
3: display = 7'b1111001;
4: display = 7'b0110011;
5: display = 7'b1011011;
6: display = 7'b0111101;
7: display = 7'b1110000;
8: display = 7'b1111111;
9: display = 7'b1110011;
endcase
end //else if
else if(ny_countdown&&Second_Digit) begin // ten minutes before NY and second digit
case(10-digit_to_display)
0: display = 7'b1111110;
1: display = 7'b0110000;
2: display = 7'b1101101;
3: display = 7'b1111001;
4: display = 7'b0110011;
5: display = 7'b1011011;
6: display = 7'b0111101;
7: display = 7'b1110000;
8: display = 7'b1111111;
9: display = 7'b1110011;
endcase
end // esle if
else begin // ten minutes before NY and not second digit
display=0;
end//else
end //  always
endmodule

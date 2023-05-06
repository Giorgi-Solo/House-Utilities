`timescale 1ns / 1ps


// counts seconds, minutes, hours
module clock_counter(
input clck_for_counter,RST,
output reg [3:0] counted_val);

always @(posedge clck_for_counter)begin
if(RST) begin // reset clock 
counted_val=0;
end//if
else if(counted_val<9) begin
counted_val=counted_val+1;
end//else if
else begin// after 10s
counted_val=0;
end//else
end // always
endmodule

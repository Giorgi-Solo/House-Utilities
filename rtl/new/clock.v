`timescale 1ns / 1ps

// This module takes clock with frequency that equals to the frequency of power supply
// it has parameter that specifies how many seconds should be the period of new clock
//(counter + 1)*2*clk_in_period this formula calculates period of output clock
//for 1s period, max_val of counter is 25-1
// for 10s period, max_val of counter is 250-1
// counter = 25*period - 1
module clock #(parameter period = 1)(input clk_in,
output clk_out);
reg [10:0] counter = 0; // when counter reaches max value, new clock signal will be toggled 
reg tmp = 0; // this will assign to new clock 
always @(posedge clk_in) begin
if(counter == (25*period - 1)) begin // when counter reaches that number, half period is over
counter = 0; // reset counter
tmp = ~tmp; // toggle tmp which will be output clock
end
else begin
counter = counter+1; // increment counter
end
end
assign clk_out=tmp; // tmp is output clock

endmodule

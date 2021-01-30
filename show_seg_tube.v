/*
*	Name: show_seg_tube.v
*	Date: 2020-11-23
*	Function: 根据按键显示不同数字
*	Input: 按键信号key,时钟信号clk
*	Output: 数码管显示信号seg
*/

module show_seg_tube(key, clk, seg);

	input [6:0] key;
	input clk;
	output reg [7:0]seg;
	
	always@(clk)
	begin
	if(key[0] == 1) begin seg <= 8'b0000_0110; end //显示1
	else if(key[1] == 1) begin seg <= 8'b0101_1011; end //显示2
	else if(key[2] == 1) begin seg <= 8'b0100_1111; end //显示3
	else if(key[3] == 1) begin seg <= 8'b0110_0110; end //显示4
	else if(key[4] == 1) begin seg <= 8'b0110_1101; end //显示5
	else if(key[5] == 1) begin seg <= 8'b0111_1101; end //显示6
	else if(key[6] == 1) begin seg <= 8'b0000_0111; end //显示7
	else begin seg <= 8'b0000_0000; end
	end
	
endmodule

/*
*	Name: division.v
*	Author: LIN Guocheng
*	Date: 2020-11-22
*	Function: 时钟分频,对时钟信号进行分频，输出信号为输入信号频率的1/2DIV_NUM倍
*	Input: 时钟信号clk
*	Output: 分频后的信号clk_out
*/
module division(clk, clk_out);
	
	parameter DIV_NUM = 1; //对时钟进行分频
	
	input clk;
	output reg clk_out;
	reg [19:0]count;
	
	always@(posedge clk)
	begin
		if(count == DIV_NUM)
		begin
			clk_out <= !clk_out;
			count <= 0;
		end
		else
			count <= count + 1;
	end
	
endmodule

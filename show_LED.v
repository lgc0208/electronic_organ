/*
*	Name: show_LED.v
*	Author: LIN Guocheng
*	Date: 2020-11-21
*	Function:在点阵列上显示不同颜色
*	Input: 时钟信号clk，颜色显示切换[2:0]SW,按键信号key
*	Output: 控制点阵的行信号row，红色列信号col_r，绿色列信号col_g
*
*	Update: 2020-11-22
*	Author: LIN Guocheng
*	Function: 按下按键后，对应列灭。
*/

module show_LED(clk, SW, key, row,col_r, col_g);
	input clk;
	input [2:0]SW;
	input [6:0]key;
	output reg [7:0]row,col_r, col_g;
	reg [2:0] count;

	wire clk_3r, clk_1g;
	reg [2:0] count_r, count_g;
	
	//分频，红绿光占空比1:3，显示黄色
	division #(1/8) d1r(.clk(clk), .clk_out(clk_3r));
	division #(3/8) d2g(.clk(clk), .clk_out(clk_1g));
	
	//模8计数器
	always @(posedge clk)
	begin
		if(count == 3'b111)
			count <= 3'b000;
		else
			count <= count + 1'b1;
	end
	
	always @(posedge clk_3r)
	begin
		if(count_r == 3'b111)
			count_r <= 3'b000;
		else
			count_r <= count_r + 1'b1;
	end
	always @(posedge clk_1g)
	begin
		if(count_g == 3'b111)
			count_g <= 3'b000;
		else
			count_g <= count_g + 1'b1;
	end
	
	
	
		//点阵显示部分 
	always@(count or count_r or count_g)
	begin
		//高音部分，显示黄色
		if(SW == 3'b001)
		begin
						
			case(count_r)
			3'b000:begin row <= 8'b1111_1111; col_r <= 8'b0000_0000; end
			3'b001:begin row <= 8'b1011_1111; col_r <= 8'b0100_0000; end
			3'b010:begin row <= 8'b1101_1111; col_r <= 8'b0110_0000; end
			3'b011:begin row <= 8'b1110_1111; col_r <= 8'b0111_0000; end
			3'b100:begin row <= 8'b1111_0111; col_r <= 8'b0111_1000; end
			3'b101:begin row <= 8'b1111_1011; col_r <= 8'b0111_1100; end
			3'b110:begin row <= 8'b1111_1101; col_r <= 8'b0111_1110; end
			3'b111:begin row <= 8'b1111_1110; col_r <= 8'b0111_1111; end
			endcase
			case(count_g)
			3'b000:begin row <= 8'b1111_1111; col_g <= 8'b0000_0000; end
			3'b001:begin row <= 8'b1011_1111; col_g <= 8'b0100_0000; end
			3'b010:begin row <= 8'b1101_1111; col_g <= 8'b0110_0000; end
			3'b011:begin row <= 8'b1110_1111; col_g <= 8'b0111_0000; end
			3'b100:begin row <= 8'b1111_0111; col_g <= 8'b0111_1000; end
			3'b101:begin row <= 8'b1111_1011; col_g <= 8'b0111_1100; end
			3'b110:begin row <= 8'b1111_1101; col_g <= 8'b0111_1110; end
			3'b111:begin row <= 8'b1111_1110; col_g <= 8'b0111_1111; end
			endcase
			
		end
		//中音部分，显示红色
		else if(SW == 3'b010)
		begin
			case(count)
			3'b000:begin row <= 8'b1111_1111; col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
			3'b001:begin row <= 8'b1011_1111; col_r <= 8'b0100_0000; col_g <= 8'b0000_0000; end
			3'b010:begin row <= 8'b1101_1111; col_r <= 8'b0110_0000; col_g <= 8'b0000_0000; end
			3'b011:begin row <= 8'b1110_1111; col_r <= 8'b0111_0000; col_g <= 8'b0000_0000; end
			3'b100:begin row <= 8'b1111_0111; col_r <= 8'b0111_1000; col_g <= 8'b0000_0000; end
			3'b101:begin row <= 8'b1111_1011; col_r <= 8'b0111_1100; col_g <= 8'b0000_0000; end
			3'b110:begin row <= 8'b1111_1101; col_r <= 8'b0111_1110; col_g <= 8'b0000_0000; end
			3'b111:begin row <= 8'b1111_1110; col_r <= 8'b0111_1111; col_g <= 8'b0000_0000; end
			endcase
		end
		//低音部分，显示绿色
		else if(SW == 3'b100)
		begin
			case(count)
			3'b000:begin row <= 8'b1111_1111; col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
			3'b001:begin row <= 8'b1011_1111; col_r <= 8'b0000_0000; col_g <= 8'b0100_0000; end
			3'b010:begin row <= 8'b1101_1111; col_r <= 8'b0000_0000; col_g <= 8'b0110_0000; end
			3'b011:begin row <= 8'b1110_1111; col_r <= 8'b0000_0000; col_g <= 8'b0111_0000; end
			3'b100:begin row <= 8'b1111_0111; col_r <= 8'b0000_0000; col_g <= 8'b0111_1000; end
			3'b101:begin row <= 8'b1111_1011; col_r <= 8'b0000_0000; col_g <= 8'b0111_1100; end
			3'b110:begin row <= 8'b1111_1101; col_r <= 8'b0000_0000; col_g <= 8'b0111_1110; end
			3'b111:begin row <= 8'b1111_1110; col_r <= 8'b0000_0000; col_g <= 8'b0111_1111; end
			endcase
		end
		else
		begin
			case(count)
			3'b000:begin row <= 8'b0000_0000; col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
			3'b001:begin row <= 8'b0000_0000; col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
			3'b010:begin row <= 8'b0000_0000; col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
			3'b011:begin row <= 8'b0000_0000; col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
			3'b100:begin row <= 8'b0000_0000; col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
			3'b101:begin row <= 8'b0000_0000; col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
			3'b110:begin row <= 8'b0000_0000; col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
			3'b111:begin row <= 8'b0000_0000; col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
			endcase
		end
		
		if(key[0] == 1) begin col_r[0] <= 0; col_g[0] <= 0; end
		if(key[1] == 1) begin col_r[1] <= 0; col_g[1] <= 0; end
		if(key[2] == 1) begin col_r[2] <= 0; col_g[2] <= 0; end
		if(key[3] == 1) begin col_r[3] <= 0; col_g[3] <= 0; end
		if(key[4] == 1) begin col_r[4] <= 0; col_g[4] <= 0; end
		if(key[5] == 1) begin col_r[5] <= 0; col_g[5] <= 0; end
		if(key[6] == 1) begin col_r[6] <= 0; col_g[6] <= 0; end
		
	end	
endmodule

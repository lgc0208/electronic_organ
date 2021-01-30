/*
*	Name: electronic_organ.v
*	Author:LIN Guocheng
*	Date:2020-12-08
*	Function:
*	1.用 8×8 点阵显示“1 2 3 4 5 6 7”七个音符构成的电子琴键盘。其中点阵的第一列
*	  用一个 LED 点亮表示音符“1”，第二列用二个 LED 点亮表示音符“2”，依此类推，
*	  如图 1 所示。当音符为低音 1~7 时，点阵显示为绿色；当音符为中音 1~7 时，点阵
*	  显示为红色；当音符为高音 1~7 时，点阵显示为黄色；
*	2.用 BTN7～BTN1 七个按键模拟电子琴手动演奏时的“1 2 3 4 5 6 7”七个音符。当
*	  某个按键按下时，数码管 DISP7 显示相应的音符，点阵上与之对应的音符显示列全
*	  灭，同时蜂鸣器演奏相应的声音；当按键放开时数码管显示的音符灭掉，点阵显示
*	  恢复，蜂鸣器停止声音的输出。图 2 为演奏中音 3（BTN5 按下）时点阵的显示情
*	  况。
*	3.由拨码开关SW7,SW6,SW5切换选择高、中、低音，点阵颜色进行相应变化
*	4.可通过一个拨码开关进行手动/自动演奏的切换，自动演奏时，点阵根据乐曲进行颜
*	  色和亮灭的变化。
*/

//电子琴顶层模块
module electronic_organ(clk, auto_sw, SW, BTN,
								beep, row, col_r, col_g, seg, CAT);					
	input [2:0]SW;
	input [6:0]BTN;
	input clk, auto_sw;
	output beep; //蜂鸣器初始化
	output [7:0]row, col_r, col_g, seg;
	output reg [7:0]CAT = 7'b0111_1111; //仅7号数码管亮				
	
	//输出音调
	play p1(.clk(clk), 
			  .auto_sw(auto_sw),
			  .key(BTN), 
			  .SW(SW),
			  .beep(beep),
			  .row(row),
		     .col_r(col_r), 
			  .col_g(col_g),
			  .seg(seg));
			  

endmodule

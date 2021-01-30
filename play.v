/*
*	Name: play.v
*	Date: 2020-11-29
*	Function: 根据按键演奏不同音符
*	Input: 时钟信号clk，自动播放信号auto_sw, 按键信号key, 音域切换信号SW
*	Output: 蜂鸣器信号beep, 点阵列行信号row, 点阵列列信号col_r, col_g，数码管显示信号seg
*/


module play(clk, auto_sw, key, SW, beep, row, col_r, col_g, seg);

	input clk; //输入时钟1MHZ
	input [6:0] key; 
	input [2:0] SW; 
	input auto_sw; //自动演奏开关
	output reg beep = 0; //蜂鸣器
	output [7:0]row, col_r, col_g; //点阵控制信号
	output [7:0]seg; //数码管显示信号
	wire [6:0] high, middle, low; //定义低中高音
	
	reg [2:0] pitch; //定义音高
	reg [6:0] tone; //定义音调
	
	//调用分频模块
	//低音1~7(分别为low[0]~low[7])
	division #(3882/2) d_l1(.clk(clk), 
								 .clk_out(low[0]));
	division #(3405/2) d_l2(.clk(clk), 
								 .clk_out(low[1]));
	division #(3033/2) d_l3(.clk(clk), 
								 .clk_out(low[2]));
	division #(2863/2) d_l4(.clk(clk), 
								 .clk_out(low[3]));
	division #(2551/2) d_l5(.clk(clk), 
								 .clk_out(low[4]));
	division #(2272/2) d_l6(.clk(clk), 
								 .clk_out(low[5]));
	division #(2025/2) d_l7(.clk(clk), 
								 .clk_out(low[6]));
					  
	//中音1~7(分别为middle[0]~middle[7])
	division #(1911/2) d_m1(.clk(clk), 
								 .clk_out(middle[0]));
	division #(1702/2) d_m2(.clk(clk), 
								 .clk_out(middle[1]));
	division #(1516/2) d_m3(.clk(clk), 
								 .clk_out(middle[2]));
	division #(1431/2) d_m4(.clk(clk), 
								 .clk_out(middle[3]));
	division #(1275/2) d_m5(.clk(clk), 
								 .clk_out(middle[4]));
	division #(1136/2) d_m6(.clk(clk), 
								 .clk_out(middle[5]));
	division #(1012/2) d_m7(.clk(clk), 
								 .clk_out(middle[6]));
					  				  
	//高音1~7(分别为high[0]~high[7])
	division #(956/2) d_h1(.clk(clk), 
								 .clk_out(high[0]));
	division #(851/2) d_h2(.clk(clk), 
								 .clk_out(high[1]));
	division #(758/2) d_h3(.clk(clk), 
								 .clk_out(high[2]));
	division #(715/2) d_h4(.clk(clk), 
								 .clk_out(high[3]));
	division #(637/2) d_h5(.clk(clk), 
								 .clk_out(high[4]));
	division #(568/2) d_h6(.clk(clk), 
								 .clk_out(high[5]));
	division #(506/2) d_h7(.clk(clk), 
								 .clk_out(high[6]));
	
	//4HZ分频,用于自动演奏
	division #(250000/2) d_4hz(.clk(clk), 
									   .clk_out(clk_4HZ));
	//《天空之城》选用 126 个音符，需要7位2进制数表示
	reg [6:0]count; //用于轮流播放不同音符	
	
	//开始计数
	always@(posedge clk_4HZ)
	begin
		//若按键按下，则开启自动播放计数，否则不工作
		if(auto_sw)
		begin
			//计数器
			if(count == 130)
				count <= 0;
			else
				count <= count + 1'b1;
		end
	end
	
	//开始演奏
	always@(posedge clk)
	begin
	
		//手动演奏
		if(!auto_sw) 
		begin
			pitch <= SW;
			tone <= key;
		end
			
		//自动演奏 天空之城
		else
		begin
				case(count)
				1: begin pitch<=3'b100; tone<=7'b010_0000; end //低音6 
				2: begin pitch<=3'b100; tone<=7'b100_0000; end //低音7
				3: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				4: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				5: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				6: begin pitch<=3'b100; tone<=7'b100_0000; end //低音7
				7: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				8: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				9: begin pitch<=3'b010; tone<=7'b000_0100; end //中音3
				10: begin pitch<=3'b010; tone<=7'b000_0100; end //延音
				11: begin pitch<=3'b100; tone<=7'b100_0000; end //低音7
				12: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				13: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				14: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				15: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				16: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				17: begin pitch<=3'b100; tone<=7'b000_0100; end //低音3
				18: begin pitch<=3'b100; tone<=7'b000_0100; end //延音
				19: begin pitch<=3'b100; tone<=7'b010_0000; end //低音6 
				20: begin pitch<=3'b100; tone<=7'b010_0000; end //延音
				21: begin pitch<=3'b100; tone<=7'b010_0000; end //延音
				22: begin pitch<=3'b100; tone<=7'b001_0000; end //低音5
				23: begin pitch<=3'b100; tone<=7'b010_0000; end //低音6 
				24: begin pitch<=3'b100; tone<=7'b010_0000; end //延音
				25: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				26: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				27: begin pitch<=3'b100; tone<=7'b001_0000; end //低音5
				28: begin pitch<=3'b100; tone<=7'b001_0000; end //延音
				29: begin pitch<=3'b100; tone<=7'b001_0000; end //延音
				30: begin pitch<=3'b100; tone<=7'b001_0000; end //延音
				31: begin pitch<=3'b100; tone<=7'b001_0000; end //延音
				32: begin pitch<=3'b100; tone<=7'b001_0000; end //延音
				33: begin pitch<=3'b100; tone<=7'b000_0100; end //低音3
				34: begin pitch<=3'b100; tone<=7'b000_0100; end //延音
				35: begin pitch<=3'b100; tone<=7'b000_1000; end //低音4
				36: begin pitch<=3'b100; tone<=7'b000_1000; end //延音
				37: begin pitch<=3'b100; tone<=7'b000_1000; end //延音
				38: begin pitch<=3'b100; tone<=7'b000_0100; end //低音3
				39: begin pitch<=3'b100; tone<=7'b000_1000; end //低音4
				40: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				41: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				42: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				43: begin pitch<=3'b100; tone<=7'b000_0100; end //低音3
				44: begin pitch<=3'b100; tone<=7'b000_0100; end //延音
				45: begin pitch<=3'b100; tone<=7'b000_0100; end //延音
				46: begin pitch<=3'b100; tone<=7'b000_0100; end //延音
				47: begin pitch<=3'b100; tone<=7'b000_0100; end //延音
				48: begin pitch<=3'b100; tone<=7'b000_0100; end //延音
				49: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				50: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				51: begin pitch<=3'b100; tone<=7'b100_0000; end //低音7
				52: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				53: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				54: begin pitch<=3'b100; tone<=7'b000_1000; end //低音4
				55: begin pitch<=3'b100; tone<=7'b000_1000; end //延音
				56: begin pitch<=3'b100; tone<=7'b000_1000; end //延音
				57: begin pitch<=3'b100; tone<=7'b000_1000; end //低音4
				58: begin pitch<=3'b100; tone<=7'b100_0000; end //低音7
				59: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				60: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				61: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				62: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				63: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				64: begin pitch<=3'b000; tone<=7'b000_0000; end //休止符
				65: begin pitch<=3'b000; tone<=7'b000_0000; end //休止符
				66: begin pitch<=3'b100; tone<=7'b010_0000; end //低音6 
				67: begin pitch<=3'b100; tone<=7'b100_0000; end //低音7
				68: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				69: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				70: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				71: begin pitch<=3'b100; tone<=7'b100_0000; end //低音7
				72: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				73: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				74: begin pitch<=3'b010; tone<=7'b000_0100; end //中音3
				75: begin pitch<=3'b010; tone<=7'b000_0100; end //延音
				76: begin pitch<=3'b100; tone<=7'b100_0000; end //低音7
				77: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				78: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				79: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				80: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				81: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				82: begin pitch<=3'b100; tone<=7'b000_0100; end //低音3
				83: begin pitch<=3'b100; tone<=7'b000_0100; end //延音
				84: begin pitch<=3'b100; tone<=7'b010_0000; end //低音6 
				85: begin pitch<=3'b100; tone<=7'b010_0000; end //延音
				86: begin pitch<=3'b100; tone<=7'b010_0000; end //延音
				87: begin pitch<=3'b100; tone<=7'b001_0000; end //低音5
				88: begin pitch<=3'b100; tone<=7'b010_0000; end //低音6 
				89: begin pitch<=3'b100; tone<=7'b010_0000; end //延音
				90: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				91: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				92: begin pitch<=3'b100; tone<=7'b001_0000; end //低音5
				93: begin pitch<=3'b100; tone<=7'b001_0000; end //延音
				94: begin pitch<=3'b100; tone<=7'b001_0000; end //延音
				95: begin pitch<=3'b100; tone<=7'b001_0000; end //延音
				96: begin pitch<=3'b100; tone<=7'b001_0000; end //延音
				97: begin pitch<=3'b100; tone<=7'b001_0000; end //延音
				98: begin pitch<=3'b100; tone<=7'b000_0100; end //低音3
				99: begin pitch<=3'b100; tone<=7'b000_1000; end //低音4
				100: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				101: begin pitch<=3'b100; tone<=7'b100_0000; end //低音7
				102: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				103: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				104: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				105: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				106: begin pitch<=3'b010; tone<=7'b000_0010; end //中音2
				107: begin pitch<=3'b010; tone<=7'b000_0010; end //延音
				108: begin pitch<=3'b010; tone<=7'b000_0100; end //中音3
				109: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				110: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				111: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				112: begin pitch<=3'b010; tone<=7'b000_0001; end //延音
				113: begin pitch<=3'b000; tone<=7'b000_0000; end //休止符
				114: begin pitch<=3'b010; tone<=7'b000_0001; end //中音1
				115: begin pitch<=3'b100; tone<=7'b100_0000; end //低音7
				116: begin pitch<=3'b100; tone<=7'b010_0000; end //低音6 
				117: begin pitch<=3'b100; tone<=7'b010_0000; end //延音
				118: begin pitch<=3'b100; tone<=7'b100_0000; end //低音7
				119: begin pitch<=3'b100; tone<=7'b100_0000; end //延音
				120: begin pitch<=3'b100; tone<=7'b001_0000; end //低音5
				121: begin pitch<=3'b100; tone<=7'b001_0000; end //延音
				122: begin pitch<=3'b100; tone<=7'b010_0000; end //低音6 
				123: begin pitch<=3'b100; tone<=7'b010_0000; end //延音
				124: begin pitch<=3'b100; tone<=7'b010_0000; end //延音
				125: begin pitch<=3'b100; tone<=7'b010_0000; end //延音
				126: begin pitch<=3'b000; tone<=7'b000_0000; end //休止符
				
				endcase
		end
		
		
	   //高音部分
		if(pitch == 3'b001)	
			begin
			case(tone)
			7'b000_0000:begin beep<=0; end
			7'b000_0001:begin beep<=high[0]; end
			7'b000_0010:begin beep<=high[1]; end
			7'b000_0100:begin beep<=high[2]; end
			7'b000_1000:begin beep<=high[3]; end
			7'b001_0000:begin beep<=high[4]; end
			7'b010_0000:begin beep<=high[5]; end
			7'b100_0000:begin beep<=high[6]; end
			endcase
			end
		
		//中音部分
		else if(pitch == 3'b010)
			begin
			case(tone)
			7'b000_0000:begin beep<=0; end
			7'b000_0001:begin beep<=middle[0]; end
			7'b000_0010:begin beep<=middle[1]; end
			7'b000_0100:begin beep<=middle[2]; end
			7'b000_1000:begin beep<=middle[3]; end
			7'b001_0000:begin beep<=middle[4]; end
			7'b010_0000:begin beep<=middle[5]; end
			7'b100_0000:begin beep<=middle[6]; end
			endcase
			end
		
		//低音部分
		else if(pitch == 3'b100)
			begin
			case(tone)
			7'b000_0000:begin beep<=0; end
			7'b000_0001:begin beep<=low[0]; end
			7'b000_0010:begin beep<=low[1]; end
			7'b000_0100:begin beep<=low[2]; end
			7'b000_1000:begin beep<=low[3]; end
			7'b001_0000:begin beep<=low[4]; end
			7'b010_0000:begin beep<=low[5]; end
			7'b100_0000:begin beep<=low[6]; end
			endcase
			end
			
	end
	
	
	
	
	//显示点阵
	show_LED sL1(.clk(clk),
					.SW(pitch),
					.key(tone),
					.row(row),
					.col_r(col_r), 
					.col_g(col_g));
					
	//数码管显示
	show_seg_tube(.key(tone), 
					  .clk(clk), 
					  .seg(seg));
endmodule

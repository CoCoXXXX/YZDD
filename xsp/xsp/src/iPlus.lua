require "public"

function init_ios_iPlus()
	
	local t = {}
	
	t["答题界面"] = "0|0|0xffcf18,-7|49|0xffcf18,142|1|0xffcf18,385|0|0xffcf18,476|39|0xffcf18,478|-6|0xffcf18,328|6|0xffcf18,161|12|0xffcf18,87|-1|0xffcf18"
	
	t["选项出现"] = "0|0|0xfff8e3,-8|101|0xfff8e3,778|1|0xfff8e3,781|104|0xfff8e3,-2|165|0xfff8e3,-7|267|0xfff8e3,765|169|0xfff8e3,757|274|0xfff8e3,65|137|0x1d7aac,48|306|0x1e80b1"
	
	--双人
	t["选项出现2"] = "0|0|0xaac2d8,-7|109|0xaac2d8,761|6|0xaac2d8,760|106|0xaac2d8,4|169|0xaac2d8,-8|279|0xaac2d8,748|176|0xaac2d8,728|275|0xaac2d8,75|141|0x1e7bad,71|303|0x1c78aa"
	
	t["OCR边界"] =
	{
		["yOffset"] = 615, --开始切图的y
		["y1"] = 615 - 615, -- 题目上方y
		["y2"] = 1323 - 615, -- 选项上方
		["x1"] = 185, -- 选项左
		["x2"] = 1044, -- 选项右
		["y3"] = 1185 -  615,  -- 得分上方y
		["y4"] = 1986 - 615,   --选项下方y
	}
	--爱心位置
	t["选项坐标"] = 
	{
		{268,1403},
		{269,1569},
		{267,1734},
		{272,1901}
	}
	--选项文字上方，迎来检测是不是正确答案颜色
	t["探测正确答案坐标"] = 
	{
		{{618,1359,0x44f28a}},
		{{617,1525,0x44f28a}},
		{{620,1693,0x44f28a}},
		{{623,1855,0x44f28a}}
	}
	
	t["探测正确答案坐标2"] = 
	{
		{{618,1359,0x56bfb0}},
		{{618,1525,0x56bfb0}},
		{{618,1693,0x56bfb0}},
		{{618,1855,0x56bfb0}}
	}
	
	t["正确答案颜色"] = "0|0|0x7df095,-16|-46|0x7df095,-24|38|0x7df095,69|43|0x7bf095,156|46|0x7df095,222|29|0x7df095,252|44|0x7bf095,298|38|0x7df095,371|35|0x7df095,493|39|0x7df095,525|-46|0x7df095,391|-52|0x7df095,286|-47|0x7df095"
	
	t["正确答案颜色2"] = "0|0|0x72bdb0,-11|61|0x72bdb0,74|60|0x72bdb0,204|60|0x72bdb0,309|64|0x72bdb0,543|64|0x72bdb0,649|61|0x72bdb0,687|-46|0x72bdb0,511|-44|0x72bdb0,327|-45|0x72bdb0,176|-45|0x72bdb0"
	
	t["提示字体和高度"] =  
	{
		["txtSize"] = 40,
		["bgHight"] = 120,
		["txtBgOffset"] = 80
	}
	
	return t
end
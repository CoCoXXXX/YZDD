require "public"
-- 828*1792 dpi:326
--使用findcolor取色
function init_ios_iXR()
	
	local t = {}
	--头像下黄色标题背景
	t["答题界面"] = "0|0|0xffcf18,165|4|0xffcf18,199|4|0xffcf18,236|2|0xffcf18,-38|10|0xffcf18,-81|8|0xffcf18,-82|33|0xffcf18"
	--只取上面两个选项
	t["选项出现"] = "0|0|0xfff8e3,-16|75|0xfff8e3,191|87|0xfff8e3,318|89|0xfff8e3,520|87|0xfff8e3,680|85|0xfff8e3,669|-1|0xfff8e3,402|-5|0xfff8e3,325|-4|0xfff8e3,11|118|0x1e7daf,-12|143|0xfff8e3,-32|235|0xfff8e3,80|235|0xfff8e3,172|147|0xfff8e3,182|236|0xfff8e3,304|237|0xfff8e3,587|237|0xfff8e3,678|237|0xfff8e3,643|150|0xfff8e3,246|-151|0x2283b6"
	
	t["选项出现2"] = "0|0|0xaac2d8,-10|75|0xaac2d8,635|82|0xaac2d8,647|-1|0xaac2d8,526|-4|0xaac2d8,348|-9|0xaac2d8,227|-7|0xaac2d8,29|86|0xaac2d8,160|84|0xaac2d8,251|89|0xaac2d8,20|115|0x1d79ab,-15|139|0xaac2d8,-25|234|0xaac2d8,49|236|0xaac2d8,169|236|0xaac2d8,291|241|0xaac2d8,352|236|0xaac2d8,439|234|0xaac2d8,633|235|0xaac2d8,243|-152|0x2382b5"
	
	t["OCR边界"] =
	{
		["yOffset"] = 772, --开始切图的y
		["y1"] = 772 - 772, -- 题目上方y
		["y2"] = 1433 - 772, -- 选项上方
		["x1"] = 181, -- 选项左
		["x2"] = 943, -- 选项右
		["y3"] = 1194 -  772,  -- 得分上方y
		["y4"] = 2009 - 772   --选项下方y
	}
	
	t["选项坐标"] = 
	{
		{253,1489},
		{256,1640},
		{259,1792},
		{262,1944}
	}
	
	t["探测正确答案坐标"] = 
	{
		{{565,1446,0x44f28a}},
		{{552,1598,0x44f28a}},
		{{554,1750,0x44f28a}},
		{{557,1901,0x44f28a}}
	}
	
	t["探测正确答案坐标2"] = 
	{
		{{565,1446,0x56bfb0}},
		{{552,1598,0x56bfb0}},
		{{554,1750,0x56bfb0}},
		{{557,1901,0x56bfb0}}
	}
	
	t["正确答案颜色"] = "0|0|0x44f28a,-2|94|0x44f28a,52|97|0x44f28a,99|96|0x44f28a,273|101|0x44f28a,613|94|0x44f28a,612|0|0x44f28a,439|2|0x44f28a,314|1|0x44f28a,305|95|0x44f28a"
	
	t["正确答案颜色2"] = "0|0|0x56bfb0,-7|85|0x56bfb0,41|89|0x56bfb0,74|89|0x56bfb0,140|92|0x56bfb0,239|90|0x56bfb0,402|86|0x56bfb0,532|88|0x56bfb0,569|-2|0x56bfb0,485|-1|0x56bfb0,386|3|0x56bfb0,287|-4|0x56bfb0,217|-3|0x56bfb0,147|0|0x56bfb0,103|5|0x56bfb0"
	
	t["提示字体和高度"] =  
	{
		["txtSize"] = 40,
		["bgHight"] = 140,
		["txtBgOffset"] = 100
	}
	
	return t
end
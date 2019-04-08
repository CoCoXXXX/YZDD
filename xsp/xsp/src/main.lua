require "i5"
require "i6"
require "iPlus"
require "iX"

init("0", 0)
local bb = require("badboy")
local h = require("http")

bb.loadluasocket()
local json = bb.getJSON()

local originalWidth
local originalHigth

-- title tip HUD
local HUD_ID = -1

--取色集合
local t

local txtSize = 28
local bgHight = 70;
local txtBgOffset = 60

local tipSize = 80;
local tipWidth = 100;

local optionPos = {}

function findPic(param,precision,hdir,vdir)
	
	hdir = hdir or 0
	vdir = vdir or 0
	precision = precision or 90
	
	local x, y = findColor({0, 0, originalWidth - 1, originalHigth - 1}, 
		param,
		precision, 0, 0, 1)
	
	--	myLog("param == " .. param .. " \n precision == " .. precision )
	return x,y
end

function isFindPic(param,precision,hdir,vdir)
	hdir = hdir or 0
	vdir = vdir or 0
	precision = precision or 90
	
	local x, y = findColor({0, 0, originalWidth - 1, originalHigth - 1}, 
		param,
		precision, 0, 0, 1)
	
	--	myLog("param == " .. param .. " \n precision == " .. precision )
	if x == -1 or y == -1 then
		return false
	else 
		return true
	end
end

local heartHudId = -1;
--寻找显示正确答案的位置
function hideHeartHud()
	if heartHudId ~= nil  and heartHudId ~= -1 then
		hideHUD(heartHudId)
		heartHudId = -1
	end
end

--type == 1 请求答案
--type == 2 把答案返给服务器
function SendScreenShot()
	
	--下面获取屏幕的宽和高
	local width,height = getScreenSize()
	
	local x1
	local x2
	local y1
	local y2
	local y3
	local y4
	
	 x1 = math.ceil(t["OCR边界"].x1)
	 x2 = math.ceil(t["OCR边界"].x2)
	 y1 = math.ceil(t["OCR边界"].y1)
	 y2 = math.ceil(t["OCR边界"].y2)
	 y3 = math.ceil(t["OCR边界"].y3)
	 y4 = math.ceil(t["OCR边界"].y4)
	
	--下面执行截图
	local cutY = t["OCR边界"].yOffset
	local cutHeight = y4 + cutY
	
	myLog("cutY == " .. cutY)
	myLog("cutHeight == " .. y4)
	--	local testHud = createHUD()
	--	showHUD(testHud,"",12,"0xffff0000","0xffffffff",0,0,cutY,width,y4/factorHigth)      --显示HUD内容
	
	snapshot('[public]'.."Image.jpg",0,cutY,width,cutHeight,0.05)
	
	local file = io.open('[public]'.."Image.jpg", "rb")
	local files = file:read("*a");
	myLog("图片大小 ==".. #files)
	file:close()
	
	myLog("OCR边界     x1 =="..x1.. "  x2 == "..x2.."  y1 =="..y1.."  y2 ==" .. y2.."  y3 ==" .. y3.."  y4 ==" .. y4)
	
	local  response_body =	h.getOCr(files,x1,x2,y1,y2,y3,y4)
	
	return response_body
end

function getAnswerIndex(_y)
	myLog("getAnswerIndex _y ==" .. _y)
	
	local optionPosY = {}
	local distance = {}
	
	for var = 1, #optionPos do
		table.insert(optionPosY,var,optionPos[var][2])
	end
	
	for var = 1, #optionPosY do
		myLog("optionPosY[var] == " .. optionPosY[var])
		local dis = math.abs(optionPosY[var] - _y)
		table.insert(distance,var , dis)
	end
	
	myLog("distance 长度 == " .. #distance)
	
	local answerIndex = -1
	local temp = 10000;
	for var = 1, #distance do
		if distance[var] < temp then
			temp =  distance[var];
			answerIndex = var;
		end
	end
	
	return answerIndex;
end

function sendAnswerToServer( answer_y,question,answer)
	
	myLog("answer_y ==" .. answer_y)
	local answerIndex = getAnswerIndex(answer_y)
	myLog("正确答案是 == " .. answerIndex)
	
	if question == nil or #question == 0 then
		myLog("question is null");
		return;
	end
	
	myLog("#answer is   " .. #answer)
	if answer == nil or #answer == 0 then
		myLog("answer is null");
		return;
	end
	
	if answerIndex < 1 or answerIndex > #answer then
		myLog("answerIndex is error");
		return
	end
	
	rightAnswer = answer[answerIndex];
	
	if rightAnswer == nil then
		myLog("rightAnswer is null");
		return;
	end
	
	h.sendAnswer(question,rightAnswer)
end

function sendScreenShotAndShowHeartHud( isTapAnswer )
	
	local res = SendScreenShot();
	myLog("res  ==" .. res)
	if res == nil then 
		dialog("脚本发生错误请重新启动脚本")
		lua_exit();
		return;
	end
	
	local resJson = json.decode(res)
	local answerType = resJson.type
	local question = resJson.question
	local options = resJson.options
	local optionIndex = resJson.optionIndex
	local isNeedToSendAnswer = answerType == 1;
	
	heartHudId = createHUD();
	
	if(optionIndex ~= nil and optionIndex >= 0 and optionIndex <= 3) then  --找到了题目
		
		local width, height = getScreenSize()
		
		local x =  optionPos[optionIndex + 1][1]
		local y =  optionPos[optionIndex + 1][2]
		
		myLog("getTipPos x = ".. x.."getTipPos y =".. y);
		
		if x~= -1 and y~= -1 then
			showGameGuideTxt(true,"找到答案，用❥标记")
			showHUD(heartHudId,"❥",tipSize,"0xffff0000","0x001f3fff",0,x + 40 ,y - tipWidth/2,tipWidth,tipWidth);
		else
			myLog("没找到显示❥ 的h位置")
			showGameGuideTxt(true,"没找到题")
		end
		
		if isTapAnswer then
			tap(x,y)
		end
	else
		showGameGuideTxt(true,"没找到题")
		isNeedToSendAnswer = true;
		myLog("没找到题")
		
		if isTapAnswer then
			local x =  optionPos[1][1]
			local y =  optionPos[1][2]
			tap(x,y)
		end
	end
	
	-- 检测是否显示了正确答案 只有找到正确答案才会跳出循环
	
	-- 计数器。超过次数跳出循环
	local counter = 0;
	
	while(true) do
		keepScreen(true)
		
		for var  = 1 , #t["探测正确答案坐标"] do
			if cmpColorEx(t["探测正确答案坐标"][var]) then
				local answerPosY = t["探测正确答案坐标"][var][1][2]
				myLog("探测正确答案坐标 Y  =" .. answerPosY)
				hideHeartHud()
				if isNeedToSendAnswer then
					sendAnswerToServer(answerPosY,question,options)
				end
			
				return
			end
		end
		
		for var  = 1 , #t["探测正确答案坐标2"] do
			if cmpColorEx(t["探测正确答案坐标2"][var]) then
				local answerPosY = t["探测正确答案坐标2"][var][1][2]
				myLog("探测正确答案坐标2 Y  =" .. answerPosY)
				hideHeartHud()
				if isNeedToSendAnswer then
					sendAnswerToServer(answerPosY,question,options)
				end
			
				return
			end
		end
		
		if isFindPic(t["正确答案颜色"]) then
		
			local answerPosX ,answerPosY = findPic(t["正确答案颜色"]);
			hideHeartHud()
			if isNeedToSendAnswer then
				sendAnswerToServer(answerPosY,question,options)
			end
			
			break
			
		elseif isFindPic(t["正确答案颜色2"]) then
		
			local answerPosX ,answerPosY = findPic(t["正确答案颜色2"]);
			hideHeartHud()
			if isNeedToSendAnswer then
				sendAnswerToServer(answerPosY,question,options)
			end
			
			break
		end
		
		keepScreen(false)
		counter = counter + 1
		
		--超时
		if counter >= 120 then
			myLog("没找到正确答案超时")
			hideHeartHud()
			break
		end
		
		mSleep("100");
	end
	
	keepScreen(false)
end

function showGameGuideTxt(isSHow,txt)
	
	txtSize = t["提示字体和高度"]["txtSize"]
	bgHight = t["提示字体和高度"]["bgHight"]
	txtBgOffset = t["提示字体和高度"]["txtBgOffset"]
	
	if isSHow then
		if HUD_ID == -1 then
			HUD_ID = createHUD()
		end
	else
		if HUD_ID ~= -1 then
			hideHUD(HUD_ID) 
			HUD_ID = -1
		end
		return
	end
	
	local width, height = getScreenSize()
	y = -height/2 + bgHight;
	bgWidth = #txt/3 * txtSize + txtBgOffset;
	--	myLog("txtSize " ..txtSize .. " bgHight "..bgHight.."  txtBgOffset  "..txtBgOffset)
	showHUD(HUD_ID,txt,txtSize,"0xffffffff","0xffec7aae",3,width/2 - bgWidth/2 ,-height/2 + bgHight +20,bgWidth,bgHight)      --显示HUD内容
end

function ShowTitleTips()
	
	while (true) do
		keepScreen(true)
		local x,y = findPic(t["答题界面"])
		if x ~= -1 and y ~= -1  then
			myLog("答题界面")
			hideHeartHud()
			showGameGuideTxt(true,"等待题目显示")
			break
		end
		
		keepScreen(false)
		mSleep("2000");
	end
	keepScreen(false)
	
	myLog("等待题目显示")
	
	local tryTimes = 0
	while (true) do
		keepScreen(true)
		
		if  isFindPic(t["选项出现"]) or isFindPic(t["选项出现2"]) then
			hideHeartHud()
			showGameGuideTxt(true,"正在玩命找答案...")
			myLog("正在玩命找答案...")
			break
		end
		
		keepScreen(false)
		mSleep("100");
	end
	keepScreen(false)
end

function YZDD()
	
	ShowTitleTips()
	
	if tonumber(result.GameType) == 0 then
		sendScreenShotAndShowHeartHud(false);
	elseif tonumber(result.GameType) == 1 then
		sendScreenShotAndShowHeartHud(true);
	end
	
end

function startGame()

	while(true) do
		keepScreen(true)
		
		YZDD()
		
		myLog("一次大循环结束>>>>>>>>>>>>>")
		mSleep(4000)
		keepScreen(false)
	end
	keepScreen(false)
	
end

function InitGame()
	
	local width, height = getScreenSize()
	originalWidth = width
	originalHigth = height
	optionPos = t["选项坐标"]
	
	myLog("原始宽: " .. originalWidth.. "   原始高: " ..originalHigth)

	if isFindPic(t["选项出现"]) or isFindPic(t["选项出现2"]) then
		return
	end
	
	showGameGuideTxt(true,"请手动进入 【一战到底】")
end

function  isSupport()
	
	local width, height = getScreenSize()
	--IOS
	myLog(width..height)
	if (width == 640 and height == 1136)then
		t = init_ios_i5()
	elseif width == 750 and height == 1334 then
		t = init_ios_i6()
	elseif width == 1242 and height == 2208 then
		t = init_ios_iPlus()
	elseif width == 1125 and height == 2436 then
		t = init_ios_iX()
	elseif width == 828 and height == 1792 then
		t = init_ios_iXR()
		
		--安卓
	elseif width == 1080 and height == 1920 then
--				t = init_android_1080(gameIndex)
	elseif width == 720 and height == 1280 then
--				t = init_android_720(gameIndex)
	else
		dialog("不支持此机型,脚本退出", 5)
		lua_exit()
	end
end

function startRun()
	isSupport()
	InitGame()
	startGame()
end

function main()
	
	local w,h = getScreenSize();
	content = getUIContent("ui.json")   --获得文件ui.json的内容
	lua_value = json.decode(content)   --对获取到的json字符串解码
	lua_value.width = w * 0.8     
	lua_value.height = h * 0.9  
	
	ret , result = showUI(json.encode(lua_value))     --重新编码json字符串，窗口将按照新设定的尺寸显示
	
	if ret == 0 then
		--如果获取到的ret的值是0  
		lua_exit()
	elseif ret == 1 then
		startRun()
	end
	
end

-- lua异常捕捉
function error(msg)
	local errorMsg = "[Lua error]"..msg
	myLog(errorMsg)    
end

xpcall(main, error)
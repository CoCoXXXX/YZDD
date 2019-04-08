--公共库
local isRelease = false

local print = sysLog
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next

myLog = function (...)
	if isRelease then
		do return end
	end
	local params = {...}
	local str = nil
	for k,v in pairs(params) do
		if not str then
			str = tostring(v)
		else
			str = str .. ", " .. tostring(v)
		end
	end
    sysLog("[调试信息]>>>>  "..str)
end

-- 格式化输出table（力荐）
printTable = function (root, notPrint, params)
	if isRelease then
		do return end
	end
	local rootType = type(root)
	if rootType == "table" then
		local tag = params and params.tag or "Table detail:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		local cache = {  [root] = "." }
		local isHead = false
		local function _dump(t, space, name)
			local temp = {}
			if not isHead then
				temp = {tag}
				isHead = true
			end
			for k,v in pairs(t) do
				local key = tostring(k)
				if cache[v] then
					tinsert(temp, "+" .. key .. " {" .. cache[v] .. "}")
				elseif type(v) == "table" then
					local new_key = name .. "." .. key
					cache[v] = new_key
					tinsert(temp, "+" .. key .. _dump(v, space .. (next(t, k) and "|" or " " ) .. srep(" ", #key), new_key))
				else
					tinsert(temp, "+" .. key .. " [" .. tostring(v) .. "]")
				end
			end
			return tconcat(temp, "\n" .. space)
		end
		if not notPrint then
			print(_dump(root, "", ""))
			print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
		else
			return _dump(root, "", "")
		end
	else
		print("[printr error]: not support type")
	end
end

--table 的拷贝
function clone(object)  
    local lookup_table = {}  
    local function _copy(object)  
        if type(object) ~= "table" then  
            return object  
        elseif lookup_table[object] then  
            return lookup_table[object]  
        end  
        local newObject = {}  
        lookup_table[object] = newObject  
        for key, value in pairs(object) do  
            newObject[_copy(key)] = _copy(value)  
        end  
        return setmetatable(newObject, getmetatable(object))  
    end  
    return _copy(object)  
end 

function cmpColorEx(array,s)
	s = s or 90
	s = math.floor(0xff*(100-s)*0.01)
	for var = 1, #array do
		local lr,lg,lb = getColorRGB(array[var][1],array[var][2])
		
--		myLog("x = " ..array[var][1] .. "   lr = " ..lr.. "   lg =".. lg.. "  lb="..lb)
		local rgb = array[var][3]

		local r = math.floor(rgb/0x10000)
		local g = math.floor(rgb%0x10000/0x100)
		local b = math.floor(rgb%0x100)
		if math.abs(lr-r) > s or math.abs(lg-g) > s or math.abs(lb-b) > s then
			return false
		end
	end
--	myLog("==============")
	return true
end


--对比多色保持
function cmpColorExKeep(array,s)
	s = s or 90
	s = math.floor(0xff*(100-s)*0.01)
	keepScreen(true)
	for var = 1, #array do
		local lr,lg,lb = getColorRGB(array[var][1],array[var][2])
		local rgb = array[var][3]

		local r = math.floor(rgb/0x10000)
		local g = math.floor(rgb%0x10000/0x100)
		local b = math.floor(rgb%0x100)
		if math.abs(lr-r) > s or math.abs(lg-g) > s or math.abs(lb-b) > s then
			keepScreen(false)
			return false
		end
	end
	keepScreen(false)
	return true
end

----找色
--function findColor(t)
--	return findColorInRegionFuzzy(t[1], t[2], t[3], t[4], t[5], t[6]); 
--end

--找多色
function findMultiColor(t)
	return findMultiColorInRegionFuzzy(t[1],t[2], t[3], t[4], t[5], t[6], t[7])
end

--点击
function tap(x, y)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))  --设置随机数种子
	local index = math.random(1,5)
	x = x+math.random(-2,2)
	y = y+math.random(-2,2)
	touchDown(index,x, y)
	mSleep(math.random(60,80))
	touchUp(index, x, y)
	mSleep(20)
end

--滑动
-- function swip(x1, y1, x2, y2)
-- 	touchDown(1,x1, y1)
-- 	mSleep(50)
-- 	touchMove(1,x2, y2)
-- 	mSleep(50)
-- 	touchUp(1, x2, y2)
-- 	mSleep(50)
-- end


function swip(x1,y1,x2,y2)
	local Step,x,y = 20,x1,y1
	touchDown(1,x,y)
	local function v(z,c) if z > c then return (-1 * Step) else return Step end end
	while (math.abs(x-x2)>=Step) or (math.abs(y-y2)>=Step) do
			if math.abs(x-x2)>=Step then x = x + v(x1,x2) end
			if math.abs(y-y2)>=Step then y = y + v(y1,y2) end
			touchMove(1, x, y)
			mSleep(20)
	end
	touchMove(1, x2, y2)
	mSleep(30)
	touchUp(1,x2,y2)
end

local function encodeBase64(source_str)  
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'  
    local s64 = ''  
    local str = source_str  

    while #str > 0 do  
        local bytes_num = 0  
        local buf = 0  

        for byte_cnt=1,3 do  
            buf = (buf * 256)  
            if #str > 0 then  
                buf = buf + string.byte(str, 1, 1)  
                str = string.sub(str, 2)  
                bytes_num = bytes_num + 1  
            end  
        end  

        for group_cnt=1,(bytes_num+1) do  
            local b64char = math.fmod(math.floor(buf/262144), 64) + 1  
            s64 = s64 .. string.sub(b64chars, b64char, b64char)  
            buf = buf * 64  
        end  

        for fill_cnt=1,(3-bytes_num) do  
            s64 = s64 .. '='  
        end  
    end  

    return s64  
end  


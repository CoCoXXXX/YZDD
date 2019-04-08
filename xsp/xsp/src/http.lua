local http = {}

local isRelease = true

local releaseOCRUrl = "http://118.25.38.19:8080/Question/ocr.do"
local releasetestReportUrl = "http://118.25.38.19:8080/Question/record.do"

--119.23.63.164
local debugOCRUrl = "http://119.23.63.164:8080/Question/ocr.do"
local debugtestReportUrl = "http://119.23.63.164:8080/Question/record.do"

http.getOCr = function (file,x1,x2,y1,y2,y3,y4)
	
	local bb = require("badboy")
	bb.loadluasocket()
	local mime = bb.mime
	local ltn12 = bb.ltn12
	local http = bb.http
	local smtp = bb.smtp
	local response_body = {}
	local ocrUrl
	
	if isRelease == true then
		ocrUrl = releaseOCRUrl
	else
		ocrUrl = debugOCRUrl
	end
	
	local headers = 
	{
		["Content-Type"] = "multipart/form-data; boundary=---------------------------7de3a916a0ab0",
		["Content-Length"] = #file,
		["Pos"] =  x1..','..x2..','..y1..','..y2..','..y3..','..y4
	}
	
	--type = 0答案来自数据库  type = 1 答案来自网络
	--{"left":123,"top":123,"type":0,"question":"asd","options": ["aaaa","bbbb","ccccc","ddddd"],"optionIndex": 1}
	local rep , code = http.request{
		url = ocrUrl,
		method = "POST",
		headers = headers  ,
		source = ltn12.source.string(file),
		sink = ltn12.sink.table(response_body),
	}
	http.response =  response_body[1]
	return http.response
end

http.sendAnswer = function (question,answer)
	
	local bb = require("badboy") 
	bb.loadluasocket()
	local json = bb.getJSON()
	local mime = bb.mime
	local ltn12 = bb.ltn12
	local http = bb.http
	local smtp = bb.smtp
	local response_body = {}
	local testReportUrl
	
	if isRelease == true then
		testReportUrl = releasetestReportUrl
	else
		testReportUrl = debugtestReportUrl
	end

	local dataTable = 
	{
		["question"] = question,
		["answer"] = answer
	}
	
	local data = json.encode(dataTable);
	myLog(" sendAnswer data == " .. data) 
	
	local headers = 
	{
		["Content-Type"] = "application/json; ",
		["Content-Length"] = #data,
	}
	
	local rep , code = http.request{
		url = releasetestReportUrl,
		method = "POST",
		headers = headers  ,
		source = ltn12.source.string(data),
		sink = ltn12.sink.table(response_body),
	}
	http.response =  response_body[1]
	return http.response
	
end

return http
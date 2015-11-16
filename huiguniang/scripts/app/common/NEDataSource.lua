--
-- Author: sddz_yuxiaohua@corp.netease.com
-- Date: 2014-04-29 15:18:43
--

local sqlite = import(".dao");
local charinfo = import(".ChapterInfoDecoder")

local NEDataSource = {}

-- @brief 	获取汉字信息，如汉字、单字音频文件路径、词语及词语音频文件路径等信息
-- @return 	table类型
function NEDataSource:getCharacterInfoTable()
	-- 数据来源，来自网易识字还是本地内置数据
	local mDataType = 1 < 0 and true or false

	if mDataType then
		-- 数据来自网易识字
		return self:getCharacterInfoDataFromConfigFileWithChapterID()
	else
		-- 数据来自内置数据
		return self:getCharacterInfoDataFromSQLiteWithChapterID()
	end

	return {}
end

-- @brief 	获取问题及答案数据
-- @return 	table类型
function NEDataSource:getQuestionTable()
	-- 数据来源，来自网易识字还是本地内置数据
	local mDataType = 1 < 0 and true or false
	
	if mDataType then
		-- 数据来自网易识字
		return self:getQuestionDataFromConfigFileWithChapterID()
	else
		-- 数据来自内置数据
		return self:getQuestionDataFromSQLiteWithChapterID()
	end

	return {}
end

--[[ -------------------------------------------------------------------------
-- param mark
-- param mark 处理Config配置文件
--]] -------------------------------------------------------------------------

-- @brief	从网易识字传递过来的配置文件获取需要学习的汉字信息及数据
-- @return 	返回汉字信息Table
function NEDataSource:getCharacterInfoDataFromConfigFileWithChapterID()
	-- 当前章节ID
	local mCurrentChapterID = app.currentChapterID or 1

	local datasource = charinfo.initWithChapterID(mCurrentChapterID)

	if not datasource then
		return {}
	end

	local t = {}

	for i = 1, #datasource["charstolearn"] do
		local m_id 				= datasource["charstolearn"][i]["id"]								-- ID
		local m_char_chinese 	= datasource["charstolearn"][i]["char_chinese"]						-- 汉字
		local m_char_sound 		= datasource["charstolearn"][i]["char_sound"]						-- 单字音频文件路径
		local m_char_phrase		= datasource["charstolearn"][i]["char_phrase"]						-- 词语
		local m_phrase_sound	= datasource["charstolearn"][i]["phrase_sound"]						-- 词语音频文件路径

		m_char_sound 			= device.writablePath .. string.sub(m_char_sound, 2, m_char_sound.length)
		m_phrase_sound 			= device.writablePath .. string.sub(m_phrase_sound, 2, m_phrase_sound.length)
		
		table.insert(t, {
					id 				= m_id,
					char_chinese 	= m_char_chinese,
					char_sound 		= m_char_sound,
					char_phrase 	= m_char_phrase,
					phrase_sound 	= m_phrase_sound
				})
	end

	return t
end

-- @brief	从网易识字传递过来的配置文件获取问题及答案数据
-- @return 	返回问题Table，问题信息包含4条答案数据
function NEDataSource:getQuestionDataFromConfigFileWithChapterID()
	-- 当前章节ID
	local mCurrentChapterID = app.currentChapterID or 1
	local datasource = charinfo.initWithChapterID(mCurrentChapterID)
		
	if not datasource then
		return {}
	end

	local questiontable = datasource["answers"]

	local t = {}

    for i = 1, #questiontable do
    	local item = {}
        for j = 1, #questiontable[i]["question"] do
        	local m_Path = questiontable[i]["question"][j]["char_sound"]

            table.insert(item, {
		            				id 		= questiontable[i]["question"][j]["id"],						-- 汉字ID
		            				char 	= questiontable[i]["question"][j]["char_chinese"],				-- 汉字
		            				sound 	= device.writablePath .. string.sub(m_Path, 2, m_Path.length),	-- 汉字音频文件绝对路径
		            				isAnswer= j == 1 and 1 or 0 											-- 是否为答案
        						})
        end
        table.insert(t, item)
    end

    return t
end

--[[ -------------------------------------------------------------------------
-- param mark
-- param mark 处理SQLite数据库文件
--]] -------------------------------------------------------------------------

-- @brief	从SQLite数据库获取需要学习的汉字信息及数据
-- @return 	返回汉字信息Table
function NEDataSource:getCharacterInfoDataFromSQLiteWithChapterID()
	local answersdata = sqlite:getAllCharsFromDB()

	if not answersdata then
		return {}
	end
	
	local t = {}

	for i = 1, #answersdata do
		local m_id 				= answersdata[i][1]["id"]											-- ID
		local m_char_chinese 	= answersdata[i][1]["char"]											-- 汉字
		local m_char_sound 		= string.format("chars/%s/char.mp3", m_id)							-- 单字音频文件路径
		local m_char_phrase		= answersdata[i][1]["phrase"]
		local m_phrase_table 	= split(m_char_phrase, "|")
		local m_phraseid 		= math.random(1, #m_phrase_table)
		m_char_phrase 			= m_phrase_table[m_phraseid]										-- 词语
		local m_phrase_sound	= string.format("chars/%s/phrase_%s.mp3", m_id, m_phraseid)			-- 词语音频文件路径

		-- print(m_id,m_char_chinese,m_char_sound,m_char_phrase,m_phrase_sound)

		table.insert(t, {
				id 				= m_id,
				char_chinese 	= m_char_chinese,
				char_sound 		= m_char_sound,
				char_phrase 	= m_char_phrase,
				phrase_sound 	= m_phrase_sound
			})
	end

	return t
end

-- @brief	从SQLite数据库获取问题及答案数据
-- @return 	返回问题Table，问题信息包含4条答案数据
function NEDataSource:getQuestionDataFromSQLiteWithChapterID()
	local answersdata = sqlite:getAllCharsFromDB()

	if not answersdata then
		return {}
	end

	local t = {}

    for i = 1, #answersdata do
    	local item = {}
        for j = 1, #answersdata[i] do
        	local m_id 				= answersdata[i][j]["id"]										-- 汉字ID
        	local m_char_chinese 	= answersdata[i][j]["char"]										-- 汉字
        	local m_char_sound 		= string.format("chars/%s/char.mp3", m_id)						-- 汉字音频文件绝对路径
        	local m_isAnswer 		= j == 1 and 1 or 0 											-- 是否为答案
        	-- print(m_id,m_char_chinese,m_char_sound)

            table.insert(item, {
		            				id 		= m_id,
		            				char 	= m_char_chinese,
		            				sound 	= m_char_sound,
		            				isAnswer= m_isAnswer
        						})
        end
        table.insert(t, item)
    end

	return t
end

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

return NEDataSource
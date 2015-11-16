local datasource = import("..common.NEDataSource")

local PhraseFindLostCharacter = {};

function PhraseFindLostCharacter:init(parent, callback_right, callback_wrong)
    print "Init Phrase Find Lost Character Game."

    self.phrasesoundpath = ""

    -- 绑定父节点
    self.parent = parent

    -- 问题回答正确回调方法
    self.callback_right = callback_right

    -- 问题错误正确回调方法
    self.callback_wrong = callback_wrong

	self.nativefont = "DFYuanW7-GB";

	self.charposition_x_1 	= 58 + 0 * 65;
	self.charposition_x_2 	= 58 + 1 * 65;
	self.charposition_x_3 	= 58 + 2 * 65;
	self.charposition_x_4 	= 58 + 3 * 65;

    self.charposition_x_2_1 = 126 + 0 * 65;
    self.charposition_x_2_2 = 126 + 1 * 65;

    self.charposition_x_3_1 = 94 + 0 * 65;
    self.charposition_x_3_2 = 94 + 1 * 65;
    self.charposition_x_3_3 = 94 + 2 * 65;

	self.charposition_y 	= 140;
	self.charfontsize		= 64;
	self.charcolor 			= ccc3(0, 0, 0);

	self.answerposition_x_1 = display.cx - 330
    self.answerposition_x_2 = display.cx - 110
    self.answerposition_x_3 = display.cx + 110
    self.answerposition_x_4 = display.cx + 330
	
	self.answerposition_y 	= 110;

	self.answerfontsize 	= 80;
	self.answercolor		= ccc3(0, 0, 0);
    self.currentroundid     = 0;

	-- 加载图集
	display.addSpriteFramesWithFile(GAME_PLAY_DATA_FILENAME,GAME_PLAY_IMAGE_FILENAME);

	-- 游戏Layer
	self.gamelayer = display.newLayer();

	-- 词语背景云
	local cloudsprite = display.newSprite("#G_yun.png", display.cx, display.cy + 250);
	self.gamelayer:addChild(cloudsprite);

	-- 第一个汉字及位置初始化
	self.chinesechar_1 = ui.newTTFLabel({
		text = "网",
		font = self.nativefont,
		size = 64,
		color = self.charcolor,
		align = ui.TEXT_ALIGN_CENTER
		});
	self.chinesechar_1:setPosition(self.charposition_x_1, self.charposition_y);
	cloudsprite:addChild(self.chinesechar_1);

	-- 第二个汉字及位置初始化
	self.chinesechar_2 = ui.newTTFLabel({
		text = "易",
		font = self.nativefont,
		size = 64,
		color = self.charcolor,
		align = ui.TEXT_ALIGN_CENTER
		});
	self.chinesechar_2:setPosition(self.charposition_x_2, self.charposition_y);
	cloudsprite:addChild(self.chinesechar_2);

	-- 第三个汉字及位置初始化
	self.chinesechar_3 = ui.newTTFLabel({
		text = "",
		font = self.nativefont,
		size = 64,
		color = self.charcolor,
		align = ui.TEXT_ALIGN_CENTER
		});
	self.chinesechar_3:setPosition(self.charposition_x_3, self.charposition_y);
	cloudsprite:addChild(self.chinesechar_3);

	-- 第四个汉字及位置初始化
	self.chinesechar_4 = ui.newTTFLabel({
		text = "字",
		font = self.nativefont,
		size = 64,
		color = self.charcolor,
		align = ui.TEXT_ALIGN_CENTER
		});
	self.chinesechar_4:setPosition(self.charposition_x_4, self.charposition_y);
	cloudsprite:addChild(self.chinesechar_4);

	-- 音符及位置初始化
	self.notesprite = display.newSprite(
		"#E_shenyin.png",
		self.charposition_x_3,
		self.charposition_y
		);
	cloudsprite:addChild(self.notesprite);

	-- 答案1/2/3/4田字格图片
	self.answer_1 = display.newSprite(
		"#G_tianzige.png",
		self.answerposition_x_1,
		self.answerposition_y
		);
	self.gamelayer:addChild(self.answer_1);
    answerButtonAddTouchDelegateMethod(self.answer_1,self,1);

	self.answer_2 = display.newSprite(
		"#G_tianzige.png",
		self.answerposition_x_2,
		self.answerposition_y
		);
	self.gamelayer:addChild(self.answer_2);
    answerButtonAddTouchDelegateMethod(self.answer_2,self,2);

	self.answer_3 = display.newSprite(
		"#G_tianzige.png",
		self.answerposition_x_3,
		self.answerposition_y
		);
	self.gamelayer:addChild(self.answer_3);
    answerButtonAddTouchDelegateMethod(self.answer_3,self,3);

	self.answer_4 = display.newSprite(
		"#G_tianzige.png",
		self.answerposition_x_4,
		self.answerposition_y
		);
	self.gamelayer:addChild(self.answer_4);
    answerButtonAddTouchDelegateMethod(self.answer_4,self,4);

	parent:addChild(self.gamelayer);

	-- 云彩按钮效果
	cloudsprite:setTouchEnabled(true);
    cloudsprite:addTouchEventListener(function(event, x, y)
        if event == "began" then
            BourceEffectCommon(cloudsprite,function()
               self:OnNoteButtonClick("test");
            end);
            return true 
        end
    end);

    print "Game UI Init Over";
    self.answerButtonTouchable = true

     -- 加载游戏数据
    self:initData();
end

function answerButtonAddTouchDelegateMethod(target, parent, index)
    target:setTouchEnabled(true);
    target:addTouchEventListener(function (event, x, y)
        if event == "began" then
            BourceEffectCommon(target, function ()
                parent:OnAnswerButtonClick(target,index);
            end);

            return true;
        end
    end);
end

-- 刷新词语UI
function PhraseFindLostCharacter:initQuestion()
    local char          = self.questiontable["char_chinese"];
    local char_phrase   = self.questiontable["char_phrase"];

    local char_index, char_end = string.find(char_phrase, char);
    local char_length   = char_end - char_index + 1;
    local index         = math.floor(char_index/char_length) + 1;
    local char_count    = string.len(char_phrase)/char_length;
    -- print ("Phrase Length:", char_count);

    local posx_1, posx_2, posx_3, posx_4;

    if char_count == 2 then
        posx_1 = self.charposition_x_2_1;
        posx_2 = self.charposition_x_2_2;
    elseif char_count == 3 then
        posx_1 = self.charposition_x_3_1;
        posx_2 = self.charposition_x_3_2;
        posx_3 = self.charposition_x_3_3;
    else
        posx_1 = self.charposition_x_1;
        posx_2 = self.charposition_x_2;
        posx_3 = self.charposition_x_3;
        posx_4 = self.charposition_x_4;
    end

    if 1 <= char_count then
        if index ~= 1 then
            local start = 1 + 0 * char_length;
            local len = start + char_length - 1;
            local text = string.sub(char_phrase, start, len);
            -- print ("Text1:", text);
            self.chinesechar_1:setString(text);
            self.chinesechar_1:setPosition(posx_1, self.charposition_y);
        else
            self.chinesechar_1:setString("");
            self.notesprite:setPosition(posx_1, self.charposition_y);
        end
    end

    if (2 <= char_count) then
        if index ~= 2 then
            local start = 1 + 1 * char_length;
            local len = start + char_length - 1;
            local text = string.sub(char_phrase, start, len);
            -- print ("Text2:", text);
            self.chinesechar_2:setString(text);
            self.chinesechar_2:setPosition(posx_2, self.charposition_y);
        else
            self.chinesechar_2:setString("");
            self.notesprite:setPosition(posx_2, self.charposition_y);
        end
    end

    if (3 <= char_count) then
        if index ~= 3 then
            local start = 1 + 2 * char_length;
            local len = start + char_length - 1;
            local text = string.sub(char_phrase, start, len);
            -- print ("Text3:", text);
            self.chinesechar_3:setString(text);
            self.chinesechar_3:setPosition(posx_3, self.charposition_y);
        else
            self.chinesechar_3:setString("");
            self.notesprite:setPosition(posx_3, self.charposition_y);
        end
    else
        self.chinesechar_3:setString("");
    end

    if (4 <= char_count) then
        if index ~= 4 then
            local start = 1 + 3 * char_length;
            local len = start + char_length - 1;
            local text = string.sub(char_phrase, start, len);
            -- print ("Text4:", text);
            self.chinesechar_4:setString(text);
            self.chinesechar_4:setPosition(posx_4, self.charposition_y);
        else
            self.chinesechar_4:setString("");
            self.notesprite:setPosition(posx_4, self.charposition_y);
        end
    else
        self.chinesechar_4:setString("");
    end
end

-- 刷新田字格UI
function PhraseFindLostCharacter:initAnswers()
    local pos_x = 70;
    local pos_y = 75;

    self.answer_1:removeAllChildrenWithCleanup(true);
    self.answerlabel_1 = ui.newTTFLabel({
        text = self.answers[1]["char"],
        font = self.nativefont,
        size = self.answerfontsize,
        color = self.answercolor,
        align = ui.TEXT_ALIGN_CENTER
        });
    self.answerlabel_1:setPosition(pos_x, pos_y);
    self.answer_1:addChild(self.answerlabel_1);

    self.answer_2:removeAllChildrenWithCleanup(true);
    self.answerlabel_2 = ui.newTTFLabel({
        text = self.answers[2]["char"],
        font = self.nativefont,
        size = self.answerfontsize,
        color = self.answercolor,
        align = ui.TEXT_ALIGN_CENTER
        });
    self.answerlabel_2:setPosition(pos_x, pos_y);
    self.answer_2:addChild(self.answerlabel_2);

    self.answer_3:removeAllChildrenWithCleanup(true);
    self.answerlabel_3 = ui.newTTFLabel({
        text = self.answers[3]["char"],
        font = self.nativefont,
        size = self.answerfontsize,
        color = self.answercolor,
        align = ui.TEXT_ALIGN_CENTER
        });
    self.answerlabel_3:setPosition(pos_x, pos_y);
    self.answer_3:addChild(self.answerlabel_3);

    self.answer_4:removeAllChildrenWithCleanup(true);
    self.answerlabel_4 = ui.newTTFLabel({
        text = self.answers[4]["char"],
        font = self.nativefont,
        size = self.answerfontsize,
        color = self.answercolor,
        align = ui.TEXT_ALIGN_CENTER
        });
    self.answerlabel_4:setPosition(pos_x, pos_y);
    self.answer_4:addChild(self.answerlabel_4);
end

-- 加载游戏第几轮
function PhraseFindLostCharacter:loadGameWithRoundId(id)
    if id < 1 then
        id = 1;
        self.currentroundid = id;
    end

    if id > #self.answersdata then
        id = #self.answersdata;
        self.currentroundid = id;
    end

    -- 问题Table
    self.questiontable = self.questiondata[id]
    -- 答案Table
    self.answers = discreteAnswers(self.answersdata[id])

    self:initQuestion();
    self:initAnswers();

    -- 词语音频文件路径
    self.phrasesoundpath = self.questiontable["phrase_sound"]
    audio.playMusic(self.phrasesoundpath, false)
end

-- 初始化游戏数据
function PhraseFindLostCharacter:initData()
    self.questiondata   = datasource:getCharacterInfoTable()
    self.answersdata    = datasource:getQuestionTable()

    self:loadGameWithRoundId(self.currentroundid);
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

-- 初始化游戏第一轮的数据
-- @参数游戏第几轮，整数类型
function PhraseFindLostCharacter:initQuestionWithRoundIndex(index)
	local chinesechar = self.answers[index][0][char];
	local question = self.answers[index][0][phrase];

end	

-- 离散答案的顺序
-- @参数为table类型
-- @table为一个二维数组
function discreteAnswers(answerstable)
	m_answers = {};

	for i = 1, #answerstable do
		table.insert(m_answers, answerstable[i]);
	end

	count = #m_answers;

	for i = 1, count do
		rand = math.random(1, 10000);
		index = rand%(count - i + 1) + i;

		if index ~= i then
			tmp = m_answers[i];
			m_answers[i] = m_answers[index];
			m_answers[index] = tmp;
		end
	end

	return m_answers;
end

-- 词语点击时播放词语音频文件
function PhraseFindLostCharacter:OnNoteButtonClick(tag)
	print "Play Phrase Sound.";
    audio.playMusic(self.phrasesoundpath, false)
end

-- 点击田字格时播放当前汉字的读音及正确与否动画
function PhraseFindLostCharacter:OnAnswerButtonClick(sender, index)
    if self.answerButtonTouchable ~= true then
        return
    end

    self.answerButtonTouchable = false

	-- print ("Answer Button Index:", index);
	if self.answers[index]["isAnswer"] == 1 then
		local righttag = display.newSprite("#G_dui.png", 122, 18);
		sender:addChild(righttag);

        self.parent:performWithDelay(function()
            -- print ("Current Round ID:", self.currentroundid);

            if self.currentroundid%(#self.answersdata) == 0 then
                self:gameOver();
            end

            -- 回答正确
            if self.callback_right ~= nil then
                self.callback_right(self.currentroundid)
            end

            self.parent:performWithDelay(function()
                if self.currentroundid%(#self.answersdata) == 0 then
                    -- do nothing
                else
                    self.currentroundid = self.currentroundid + 1;
                    self:loadGameWithRoundId(self.currentroundid);
                end

                self.answerButtonTouchable = true
            end, 1)
        end,0)
	else
		local wrongtag = display.newSprite("#G_cha.png", 122, 18);
		sender:addChild(wrongtag);

        if self.callback_wrong ~= nil then
            self.callback_wrong()
        end

        self.answerButtonTouchable = true
	end
end

-- 按钮效果
function BourceEffectCommon(button,cb)
    local function zoom1(offset, time, onComplete)
        local x, y = button:getPosition()
        local size = button:getContentSize()

        local scaleX = button:getScaleX() * (size.width + offset) / size.width
        local scaleY = button:getScaleY() * (size.height - offset) / size.height

        transition.moveTo(button, {y = y - offset, time = time})
        transition.scaleTo(button, {
            scaleX     = scaleX,
            scaleY     = scaleY,
            time       = time,
            onComplete = onComplete,
        })
    end

    local function zoom2(offset, time, onComplete)
            local x, y = button:getPosition()
            local size = button:getContentSize()

            transition.moveTo(button, {y = y + offset, time = time / 2})
            transition.scaleTo(button, {
                scaleX     = 1.0,
                scaleY     = 1.0,
                time       = time,
                onComplete = onComplete,
            })
    end
    zoom2(0,0.2,function() 
        zoom1(10,0.2,function()
            zoom2(10,0.2,function()
            	cb();
            end)
        end)
    end);
end

function PhraseFindLostCharacter:gameOver()
    if self.gamelayer ~= nil then
        self.gamelayer:removeFromParentAndCleanup(true)
        print "Release Game Layer."
    end
end



return PhraseFindLostCharacter;


-- ChineseFindPyin.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-10

local ChineseFindPyin = {}
local datasource = import("..common.NEDataSource")
local effect = import("..common.ButtonEffect");
local objeffect = import("..common.NEObjectActionEffect")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

function ChineseFindPyin:init(parent, callback_right, callback_wrong)
    -- 父结点
	self.parent 			= parent;

    -- 问题回答正确回调方法
    self.callback_right     = callback_right

    -- 问题错误正确回调方法
    self.callback_wrong     = callback_wrong

    -- 自定义字体
	self.nativefont 		= "DFYuanW7-GB";
	self.charfontsize		= 64;
	self.charcolor 			= ccc3(0, 0, 0);
	self.charposition_x 	= 94 + 1 * 65;
	self.charposition_y 	= 140;

	self.answerposition_x_1 = display.cx - 330
    self.answerposition_x_2 = display.cx - 110
    self.answerposition_x_3 = display.cx + 110
    self.answerposition_x_4 = display.cx + 330
	self.answerposition_y 	= 110;

	self.currentroundid     = 0;

    -- 自动播放提示语音相关配置信息
    self.coroutineEnabled   = false
    self.autoplaypyinsound  = false
    self.currentpyinaudio   = ""
    self.currentpyinindex   = 0
    self.PyinSoundHandler   = nil
    self.PyinScheduleHandler= nil

    -- 存放语音路径信息
    self.phrasetable        = {}

	-- 加载图集
	display.addSpriteFramesWithFile(GAME_PLAY_DATA_FILENAME,GAME_PLAY_IMAGE_FILENAME);

	-- 游戏Layer
	self.gamelayer = display.newLayer();

	-- 词语背景云
	local cloudsprite = display.newSprite("#G_yun.png", display.cx, display.cy + 200);
	self.gamelayer:addChild(cloudsprite);

	-- Question
	self.chineselable = ui.newTTFLabel({
		text = "字",
		font = self.nativefont,
		size = self.charfontsize,
		color = self.charcolor,
		align = ui.TEXT_ALIGN_CENTER
		});
	self.chineselable:setPosition(self.charposition_x, self.charposition_y);
	cloudsprite:addChild(self.chineselable);

	-- 答案1/2/3/4田字格图片
	self.answer_1 = display.newSprite(
		"#G_yinfu1.png",
		self.answerposition_x_1,
		self.answerposition_y
		);
	self.gamelayer:addChild(self.answer_1);
    answerButtonAddTouchDelegateMethod(self.answer_1,self,1);

	self.answer_2 = display.newSprite(
		"#G_yinfu2.png",
		self.answerposition_x_2,
		self.answerposition_y
		);
	self.gamelayer:addChild(self.answer_2);
    answerButtonAddTouchDelegateMethod(self.answer_2,self,2);

	self.answer_3 = display.newSprite(
		"#G_yinfu3.png",
		self.answerposition_x_3,
		self.answerposition_y
		);
	self.gamelayer:addChild(self.answer_3);
    answerButtonAddTouchDelegateMethod(self.answer_3,self,3);

	self.answer_4 = display.newSprite(
		"#G_yinfu4.png",
		self.answerposition_x_4,
		self.answerposition_y
		);
	self.gamelayer:addChild(self.answer_4);
    answerButtonAddTouchDelegateMethod(self.answer_4,self,4);

	self.parent:addChild(self.gamelayer);

	print "Chinese Find Pyin Init Over.";

	 -- 加载游戏数据
    self:initData();
end

-- 加载游戏第几轮
function ChineseFindPyin:loadGameWithRoundId(id)
    if id < 1 then
        id = 1;
        self.currentroundid = id;
    end

    if id > #self.answersdata then
        id = #self.answersdata;
        self.currentroundid = id;
    end

    self.questiontable = self.questiondata[id];
    self.answers = discreteAnswers(self.answersdata[id]);
    self:initQuestion();
    self:initAnswers();

    for k in pairs (self.phrasetable) do
        self.phrasetable[k] = nil
    end

    for i = 1, #self.answers do
        local audiofile = self.answers[i]["sound"]
        print(audiofile)
        table.insert(self.phrasetable, audiofile)
    end

    if self.PyinSoundHandler == nil then
        self.coroutineEnabled = true
        self.PyinSoundHandler = self:initAutoPlaySoundCoroutine()
    end

    local function onInterval(dt)
        self.autoplaypyinsound = true
        coroutine.resume(self.PyinSoundHandler)
    end

    self.parent:performWithDelay(function()
        self.currentpyinindex = 0
        self.currentpyinaudio = self.phrasetable[1]
        onInterval(0)
    end, 1)

    if type(self.PyinScheduleHandler) == "number" then
        scheduler.unscheduleGlobal(self.PyinScheduleHandler)
        self.PyinScheduleHandler = nil
    end

    self.PyinScheduleHandler = scheduler.scheduleGlobal(onInterval, 10)

    print "Load Next Game Round Over."
end

-- 刷新Question
function ChineseFindPyin:initQuestion()
	self.chineselable:setString(self.questiontable["char_chinese"]);
end

-- 刷新Answers
function ChineseFindPyin:initAnswers()
	self.answer_1:removeAllChildrenWithCleanup(true);
	self.answer_2:removeAllChildrenWithCleanup(true);
	self.answer_3:removeAllChildrenWithCleanup(true);
	self.answer_4:removeAllChildrenWithCleanup(true);
end

-- 初始化游戏数据
function ChineseFindPyin:initData()
    self.questiondata   = datasource:getCharacterInfoTable()
    self.answersdata    = datasource:getQuestionTable()

    self:loadGameWithRoundId(self.currentroundid);
    
    print "Game Data Init Over.";
end

function ChineseFindPyin:initAutoPlaySoundCoroutine()
    local m_coroutine = coroutine.create(function(listener)
        while true do
            if self.autoplaypyinsound == true then
                self.currentpyinindex = self.currentpyinindex + 1
                self.currentpyinaudio = self.phrasetable[self.currentpyinindex]

                audio.playSound(self.currentpyinaudio)

                self:playButtonAnimation(self.currentpyinindex)

                if listener ~= nil then
                    listener()
                end
            elseif self.autoplaypyinsound == false then
                if type(self.PyinScheduleHandler) == "number" then
                    scheduler.unscheduleGlobal(self.PyinScheduleHandler)
                    self.PyinScheduleHandler = nil
                end
            end

            coroutine.yield()
        end
    end)

    local m_callback = function()
        self.parent:performWithDelay(function()
            if self.currentpyinindex >= 4 then
                self.currentpyinindex = 0
                self.autoplaypyinsound = false
            end

            if self.autoplaypyinsound == true then
                coroutine.resume(m_coroutine)
            end
        end, 1.5)
    end

    self.autoplaypyinsound = false
    coroutine.resume(m_coroutine, m_callback)

    return m_coroutine
end

function ChineseFindPyin:playButtonAnimation(index)
    if index == 1 then
        objeffect:BourceOutIn(self.answer_1, nil)
    elseif index == 2 then
        objeffect:BourceOutIn(self.answer_2, nil)
    elseif index == 3 then
        objeffect:BourceOutIn(self.answer_3, nil)
    elseif index == 4 then
        objeffect:BourceOutIn(self.answer_4, nil)
    end
end

function answerButtonAddTouchDelegateMethod(target, parent, index)
    target:setTouchEnabled(true);
    target:addTouchEventListener(function (event, x, y)
        if event == "began" then
            return true
        end

        local touchInSprite = target:getCascadeBoundingBox():containsPoint(CCPoint(x, y))
        if event == "ended" then
            if touchInSprite then
                effect:BourceEffectCommon(target, function ()
                    parent:OnAnswerButtonClick(target,index);
                end);
            end
        end
    end);
end

-- 点击田字格时播放当前汉字的读音及正确与否动画
function ChineseFindPyin:OnAnswerButtonClick(sender, index)
	print ("Answer Button Index:", index);
	if self.answers[index]["isAnswer"] == 1 then
        self.autoplaypyinsound = false

		local righttag = display.newSprite("#G_dui.png", 122, 18);
		sender:addChild(righttag);

        self.parent:performWithDelay(function()
            -- print ("Current Round ID:", self.currentroundid);

            -- 回答正确
            if self.callback_right ~= nil then
                self.callback_right(self.currentroundid)
            end

            if self.currentroundid%(#self.answersdata) == 0 then
                self:gameOver();
                return
            end

            self.parent:performWithDelay(function()
                if self.currentroundid%(#self.answersdata) == 0 then
                    -- do nothing
                    print "Game OVer."
                else
                    self.currentroundid = self.currentroundid + 1;
                    self:loadGameWithRoundId(self.currentroundid);
                end

                self.answerButtonTouchable = true
            end, 2)
        end, 0)
	else
		local wrongtag = display.newSprite("#G_cha.png", 122, 18);
		sender:addChild(wrongtag);

        if self.callback_wrong ~= nil then
            self.callback_wrong()
        end

        self.answerButtonTouchable = false
	end
end

function ChineseFindPyin:gameOver()
    if self.gamelayer ~= nil then
        self.parent:removeChild(self.gamelayer);
    end

    self:onExit()
end

function ChineseFindPyin:onExit( )
    print "ChineseFindPyin Game Exited."
    if type(self.PyinScheduleHandler) == "number" then
        scheduler.unscheduleGlobal(self.PyinScheduleHandler)
        self.PyinScheduleHandler = nil
    end

    self.autoplaypyinsound = false
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

return ChineseFindPyin
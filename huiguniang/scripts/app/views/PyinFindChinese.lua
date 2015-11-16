-- PyinFindChinese.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-11

local datasource = import("..common.NEDataSource")
local effect = import("..common.ButtonEffect");
local objeffect = import("..common.NEObjectActionEffect")

local PyinFindChinese = {}

function PyinFindChinese:init(parent, callback_right, callback_wrong)
	-- 父结点
	self.parent 			= parent;

    -- 问题回答正确回调方法
    self.callback_right     = callback_right

    -- 问题错误正确回调方法
    self.callback_wrong     = callback_wrong

    -- 自定义字体
	self.nativefont 		= "DFYuanW7-GB"
	self.charfontsize		= 64
	self.charcolor 			= ccc3(0, 0, 0)
	self.charposition_x 	= 94 + 1 * 65
	self.charposition_y 	= 140;

	self.answerposition_x_1 = display.cx - 330
	self.answerposition_x_2 = display.cx - 110
	self.answerposition_x_3 = display.cx + 110
	self.answerposition_x_4 = display.cx + 330
	self.answerposition_y 	= 110

	-- 答案字位置信息
	self.charposition_y 	= 140;
	self.charfontsize		= 64;
	self.charcolor 			= ccc3(0, 0, 0);

	self.answerfontsize 	= 80;
	self.answercolor		= ccc3(0, 0, 0);
    self.currentroundid     = 0;

	-- 当前游戏轮数
	self.currentroundid     = 0

	-- 加载图集
	display.addSpriteFramesWithFile(GAME_PLAY_DATA_FILENAME,GAME_PLAY_IMAGE_FILENAME)

	-- 游戏Layer
	self.gamelayer = display.newLayer()

	-- 拼音背景云
	local cloudsprite = display.newSprite("#G_yun.png", display.cx, display.cy + 200)
	display.newSprite("#G_yinfu.png", 155, 135):addTo(cloudsprite)
	self.gamelayer:addChild(cloudsprite)
	-- 云彩按钮效果
	cloudsprite:setTouchEnabled(true);
    cloudsprite:addTouchEventListener(function(event, x, y)
        if event == "began" then
            objeffect:Bource(cloudsprite,function()
               self:OnNoteButtonClick("test");
            end);
            return true 
        end
    end);

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

	-- print "Game UI Init Over";
    self.answerButtonTouchable = true

	self:initData()
end

-- 初始化游戏数据
function PyinFindChinese:initData()
    self.questiondata   = datasource:getCharacterInfoTable()
    self.answersdata    = datasource:getQuestionTable()

    self:loadGameWithRoundId(self.currentroundid)
end

-- 加载游戏第几轮
function PyinFindChinese:loadGameWithRoundId(id)
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
    self:initAnswers();

    self.phrasesoundpath = self.questiontable["char_sound"]
    -- print("路径:", self.phrasesoundpath)
    audio.playMusic(self.phrasesoundpath, false)
    print "loadGameWithRoundId Over"
end

-- 刷新田字格UI
function PyinFindChinese:initAnswers()
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

    print "Init Answers Over."
    print(self.answers[1]["char"], self.answers[2]["char"], self.answers[3]["char"], self.answers[4]["char"])
end

-- 点击田字格时播放当前汉字的读音及正确与否动画
function PyinFindChinese:OnAnswerButtonClick(sender, index)
	print "Clicked"
    if self.answerButtonTouchable ~= true then
        return
    end

    self.answerButtonTouchable = false

	print ("Answer Button Index:", index);
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

-- 词语点击时播放词语音频文件
function PyinFindChinese:OnNoteButtonClick(tag)
	print "Play Phrase Sound.";
    audio.playMusic(self.phrasesoundpath, false)
end

function PyinFindChinese:gameOver()
    if self.gamelayer ~= nil then
        self.gamelayer:removeFromParentAndCleanup(true)
        print "Release Game Layer."
    end
end

function PyinFindChinese:onExit()
	print "PyinFindChinese Game has Exit."
end

function answerButtonAddTouchDelegateMethod(target, parent, index)
    target:setTouchEnabled(true);
    target:addTouchEventListener(function (event, x, y)
        if event == "began" then
            objeffect:Bource(target, function ()
                parent:OnAnswerButtonClick(target,index);
            end);

            return true;
        end
    end);
end
return PyinFindChinese
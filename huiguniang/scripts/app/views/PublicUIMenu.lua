-- PublicUIMenu.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-01

local uibutton = import("..ui.UIButton")
local successView = import("..views.SuccessView");
local database = import("..common.dao")
local game_1 = import("..views.PyinFindChinese")
local game_2 = import("..views.ChineseFindPyin")
local game_3 = import("..views.PhraseFindLostCharacter")
local uianimationex = import("..ui.UIAnimationEx")
local controlMenuView = require("app.views.ControlMenuView")

local PublicUIMenu = {}

function PublicUIMenu:addUI(configtable)
    local parent = configtable["parent"]
    -- 绑定父节点
    self.parent = parent

    -- 问题回答正确回调方法
    self.callback_right = configtable["listener_right"]

    -- 问题错误正确回调方法
    self.callback_wrong = configtable["listener_wrong"]

    -- 绑定事件委托
	require("framework.api.EventProtocol").extend(self)

    local AssetsPath    = "ChapterMaterial/Ch_%d_%d/%s"
    local m_ch_id       = app.currentChapterID
    local m_ch_index    = app.currentChapterIndex
    local m_story_id    = (m_ch_id - 1) * 4 + m_ch_index

    if m_story_id > 8 then
        m_story_id = 8
    end

    -- 添加自定义图层
	self.layer = display.newLayer()

    -- 添加导航栏
    self.parent:performWithDelay(function()
        controlMenuView:new():addTo(self.layer)
    end, 1)

    -- 添加图集
	display.addSpriteFramesWithFile(PUBLIC_UI_MENU_TEXTURE_PLIST,PUBLIC_UI_MENU_TEXTURE_PNG)

	-- 返回按钮
	self.returnbutton = uibutton:newSpriteButton({
		image       = "#PUIM_Button_Return.png",
        setAlpha    = true,
        x           = display.left + 44,
        y           = display.top - 37,
        listener    = function(tag)
                        self:onExit()
                        app:playStartScene()
                    end		
	}):addTo(self.layer)

	-- 复读按钮
    self.rewindbutton = uibutton:newSpriteButton({
        image       = "#PUIM_Button_Rewind.png",
        setAlpha    = true,
        x           = display.right - 44,
        y           = display.top - 37,
        listener    = function()
                        self:onExit()
                        self:dispatchEvent({ name = "onRewindButtonClicked" })
                        app:rewindCurrentChapterIndex()
                    end
    }):addTo(self.layer)

    -- 加载动画资源
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(
        PUBLIC_UI_MENU_ANIMATION_PNG,
        PUBLIC_UI_MENU_ANIMATION_PLIST,
        PUBLIC_UI_MENU_ANIMATION_XML
    )

    -- 兔子动画
    self.rabbit = CCNodeExtend.extend(CCArmature:create("tuzi"))
    self.rabbit:setPosition(display.cx, display.top - 40)
    uianimationex:playAnim(self.rabbit, "tuzi", true)
    self.rabbit:addTo(self.layer)

    -- 给兔子添加动画点击事件
    uianimationex:animationAddTouchEvent(self.rabbit, function(target)
        self:onRabbitButtonClicked(target)
    end)

    -- 升降字幕背景
    self.captionscreen = display.newSprite("#PUIM_Background_Detail.png", display.cx, display.cy + display.height):addTo(self.layer)

    local m_content = database:getStoryConfig(m_story_id)["content"]
    -- 故事文字内容
    self.storylabel = ui.newTTFLabel({
        text        = m_content,
        font        = "DFYuanW7-GB",
        x           = 100,
        y           = 220,
        size        = 28,
        dimensions  = CCSize(700,450),
        color       = ccc3(86, 14, 0),
    }):addTo(self.captionscreen)

    -- 字幕关闭按钮
    uibutton:newSpriteButton({
        image       = "#PUIM_Button_Close.png",
        setAlpha    = true,
        setScale    = true,
        x           = 860,
        y           = 320,
        listener    = function () self:onRabbitButtonClicked(self.rabbit) end,
    }):addTo(self.captionscreen)

    -- 将自定义图层添加到父节点
	parent:addChild(self.layer)

    -- 播放故事音频文件
    parent:performWithDelay(function()
        -- audio.playMusic(string.format(AssetsPath, m_ch_id, m_ch_index, "Sound/Story.MP3"), false)
    end, 0.2)
end

function PublicUIMenu:setTouchEnabled(state)
    if state ~= true then
        state = false
    end

    -- self.returnbutton:setTouchEnabled(state)
    self.rewindbutton:setTouchEnabled(state)
    self.rabbit:setTouchEnabled(state)
end

function PublicUIMenu:onAnswerRightCallback(index)
    if index < 4 then
        print ("Right Index:", index)
        self.callback_right(index)
    elseif index >= 4 then
        local m_ch_id = app.currentChapterID
        local m_ch_index = app.currentChapterIndex
        local m_story_id = (m_ch_id - 1) * 4 + m_ch_index
        local AssetsPath  = "ChapterMaterial/Ch_%d_%d/%s"
        audio.playMusic(string.format(AssetsPath, m_ch_id, m_ch_index, "Sound/Win.MP3"), false)
        successView:showSuccess(self.parent, function()
            self:onExit()
        end)
    end
end

function PublicUIMenu:onAnswerWrongCallback()
    self.callback_wrong()
end

function PublicUIMenu:displayQuestionButton(position)
    position = position or CCPoint(display.cx, display.cy)

    -- 问题按钮点击事件
    local function onQuestionButtonClicked()
        local m_ch_id = app.currentChapterID
        local m_ch_index = app.currentChapterIndex
        local m_story_id = (m_ch_id - 1) * 4 + m_ch_index
        local AssetsPath  = "ChapterMaterial/Ch_%d_%d/%s"
        audio.playMusic(string.format(AssetsPath, m_ch_id, m_ch_index, "Sound/Question.MP3"), false)

        self:dispatchEvent({ name = "onQuestionButtonClicked" })
        self:setTouchEnabled(false)
        self.m_questionButton:removeFromParentAndCleanup(true)

        self.parent:performWithDelay(function()
            self:playGame()
        end, 4)
    end

    -- Question Button
    self.m_questionButton = uibutton:newSpriteButton({
        image       = "#PUIM_Button_Question.png",
        setAlpha    = true,
        setScale    = true,
        x           = position.x,
        y           = position.y,
        listener    = onQuestionButtonClicked,
    }):addTo(self.layer)
end

function PublicUIMenu:playGame()
    -- 拼音找汉字游戏
        if app.currentChapterIndex == 1 then
            game_1:init(
                self.parent,
                function(index)
                    self:onAnswerRightCallback(index)
                end,
                function()
                    self:onAnswerWrongCallback()
                end
            )

            return
        end

        -- 汉字找拼音游戏
        if app.currentChapterIndex == 2 then
            game_2:init(
                self.parent,
                function(index)
                    self:onAnswerRightCallback(index)
                end,
                function()
                    self:onAnswerWrongCallback()
                end
            )

            return
        end

        -- 词语找汉字游戏
        if app.currentChapterIndex == 3 then
            game_3:init(
                self.parent,
                function(index)
                    self:onAnswerRightCallback(index)
                end,
                function()
                    self:onAnswerWrongCallback()
                end
            )

            return
        else
            -- 彩蛋
            game_3:init(
                self.parent,
                function(index)
                    self:onAnswerRightCallback(index)
                end,
                function()
                    self:onAnswerWrongCallback()
                end
            )

            return
        end
end

-- 方法名称:播放动画
-- 参数：
-- @animobj     动画对象
-- @animname    要播放的动画名字
-- @duration    动画持续时间
-- @loop        是否重复播放动画，默认为false
function PublicUIMenu:playAnimation(animobj, animname, duration, loop)
    self.parent:performWithDelay(function()
        if animobj == nil then return end

        local animation = animobj:getAnimation()
        if animation ~= nil then
            animation:setAnimationScale(24 / 60)
            animation:play(animname)
        end

        if loop == true then
            self:playAnimation(animobj, animname, duration, loop)
        end
    end, duration)
end

-- 兔子动画及字幕关闭按钮点击事件
function PublicUIMenu:onRabbitButtonClicked(target)
    local pos_y = target:getPositionY()
    local m_speed_1 = 150.0/1.0
    local m_speed_2 = 400.0/1.0

    if pos_y <= display.top - 40 then
        local m_target_pos_y = display.top + 110
        local m_screen_pos_y = display.cy + 150
        
        local duration = (m_target_pos_y - pos_y)/m_speed_1
        transition.moveTo(target, {y = m_target_pos_y, time = duration})

        duration = (self.captionscreen:getPositionY() - m_screen_pos_y)/m_speed_2
        transition.moveTo(self.captionscreen, {y = m_screen_pos_y, time = duration})
    else
        local m_target_pos_y = display.top - 40
        local m_screen_pos_y = display.cy + display.height
        
        local duration = (pos_y - m_target_pos_y)/m_speed_1
        transition.moveTo(target, {y = m_target_pos_y, time = duration})

        duration = (m_screen_pos_y - self.captionscreen:getPositionY())/m_speed_2
        transition.moveTo(self.captionscreen, {y = m_screen_pos_y, time = duration})
    end
end

-- 添加监听事件
function PublicUIMenu:addEventListener(eventname, func_pointer)
	self:addEventListener(eventname, func_pointer)
end

function PublicUIMenu:showScreenCurtain(layer)
    local m_sprite = app.currentChapterIndex == 1 and "ChapterMaterial/Universal/ScreenCurtain_Yellow.png" or "ChapterMaterial/Universal/ScreenCurtain_Purple.png"
    local curtain = display.newSprite(m_sprite,display.cx,display.cy):addTo(layer)
    
    curtain:setTouchEnabled(true)
    curtain:addTouchEventListener(function(event, x, y)
        if event == "began" then
            return true
        end
    end)

    local x, y = curtain:getPosition()
    transition.moveTo(curtain, {y = y + display.height * 3 / 2, time = 3})

    self.parent:performWithDelay(function()
        curtain:removeFromParentAndCleanup(true)
    end,3.5)
end

-- 对象退出时移除所有监听事件
function PublicUIMenu:onExit()
	print "All Event Listeners has been Removed!"
    
    audio.stopMusic()
	self:removeAllEventListeners()
    game_1:onExit()
end

return PublicUIMenu
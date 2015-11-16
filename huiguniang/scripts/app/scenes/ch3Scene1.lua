-- ch3Scene1.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-03

local objecteffect = import("..common.NEObjectActionEffect")
local publicmenu = import("..views.PublicUIMenu")
local uianimationex = import("..ui.UIAnimationEx")
local uispriteex = import("..ui.UISpriteEx")

local ch3Scene1 = class("ch3Scene1", function()
    return display.newScene("ch3Scene1")
end)


function ch3Scene1:ctor()
    local ch_id       = 3
    local ch_index    = 1
    local AssetsPath  = string.format("ChapterMaterial/Ch_%d_%d/", ch_id, ch_index) .. "%s"
    local SoundPath   = string.format("ChapterMaterial/Ch_%d_%d/Sound/", ch_id, ch_index) .. "%s"

    local Anim_Png    = string.format("ChapterMaterial/Ch_%d_%d/Animation/AnimData.png", ch_id, ch_index)
    local Anim_Plist  = string.format("ChapterMaterial/Ch_%d_%d/Animation/AnimData.plist", ch_id, ch_index)
    local Anim_Xml    = string.format("ChapterMaterial/Ch_%d_%d/Animation/AnimData.xml", ch_id, ch_index)

    -- 加载动画数据文件
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(Anim_Png, Anim_Plist, Anim_Xml)

    -- 自定义图层
    self.layer = display.newLayer()

    local uisprite = uispriteex:Init(self.layer, ch_id, ch_index)

    -- 背景图片
    uisprite:newSprite("Background.jpg")

    -- 桌子1
    self.desk_1 = uisprite:newSprite("Desk.png", display.left + 200, display.cy, true)

    -- 钟表
    self.clock = uisprite:newSprite("Clock.png", display.cx, display.cy + 30, true)

    -- 桌子2
    self.desk_2 = uisprite:newSprite("Candle.png", display.right - 230, display.cy + 37, true)

    -- 后妈
    self.stepmother = uisprite:newSprite("houma.png", display.left + 100, display.cy - 20, true)

    -- 大姐
    self.sister_1 = uisprite:newSprite("Sister_1.png", display.right - 220, display.cy - 10, true)

    -- 二姐
    self.sister_2 = uisprite:newSprite("Sister_2.png", display.right - 100, display.cy - 80, true)

    -- 服务员
    self.waiter = uisprite:newSprite("Waiter.png", display.right - 130, display.cy - 237, true)

    -- 灰姑娘
    self.cinderella = uianimationex:createAnimationWithArmature("huiguniang_1", CCPoint(display.cx - 200, display.bottom + 20), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.cinderella, function()
        self:playAnimationWithDelay(self.cinderella, "dongzuo1")
        audio.playMusic(string.format(SoundPath, "Cinderella_1.MP3"), false)
        self.cinderella.clicked = true
    end)

    -- 王子
    self.prince = uianimationex:createAnimationWithArmature("wangzi_1", CCPoint(display.cx, display.bottom + 20), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.prince, function()
        self:playAnimationWithDelay(self.prince, "wangzi")
        audio.playMusic(string.format(SoundPath, "Prince_1.MP3"), false)
        self.prince.clicked = true
    end)

    -- 小提琴
    self.violin = uianimationex:createAnimationWithArmature("xiaozhu_1", CCPoint(display.left - 220, display.bottom + 210), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.violin, function()
        self:playAnimationWithDelay(self.violin, "xiaozhu")
        -- audio.playMusic(string.format(SoundPath, "Prince_1.MP3"), false)
        self.violin.clicked = true
    end)

    -- 窗帘
    uisprite:newSprite("Curtain_2.png", display.left + 65, display.cy + 100)
    uisprite:newSprite("Curtain_2.png", display.right - 65, display.cy + 100):setFlipX(true)

    uisprite:newSprite("Curtain_1.png", display.cx, display.top - 45)



    self:addChild(self.layer)

    -- UI Menu Buttons
    publicmenu:addUI({
        parent = self,
        listener_right  = function(index)
                                if index == 1 then
                                    local romantic = uianimationex:createAnimationWithArmature("datidongzuo", CCPoint(display.cx, display.cy - 100), self.layer)
                                    self:playAnimationWithLoops(romantic, "dongzuo1", 0.8, 3)
                                elseif index == 2 then
                                    transition.moveTo(self.violin, {x = display.left + 20, y = display.bottom + 110, time = 1.5})
                                    self:playAnimationWithDelay(self.violin, "xiaozhu")
                                elseif index == 3 then
                                    local yinfu = uianimationex:createAnimationWithArmature("yinfu", CCPoint(self.violin:getPositionX() + 120, self.violin:getPositionY() + 260), self.layer)
                                    self:playAnimationWithLoops(yinfu, "yinfu", 1.3, 3)
                                    self:playAnimationWithLoops(self.violin, "xiaozhu", 1.3, 3, false)

                                    self.cinderella:setScale(0)
                                    self.prince:setScale(0)

                                    local huaerzi  = uianimationex:createAnimationWithArmature("huaerzi", CCPoint(display.cx - 200, display.bottom + 10), self.layer)
                                    self:playAnimationWithDelay(huaerzi, "dongzuo3")
                                else
                                    -- do nothing
                                end
                            end,
        listener_wrong  = function()
                                audio.playMusic(string.format(SoundPath, "Cinderella_5.MP3"), false)
                                self:playAnimationWithDelay(self.prince, "yaotou")
                            end
        })

    publicmenu:addEventListener("onRewindButtonClicked", function(event) self:onRewindButtonClicked(event) end)
    publicmenu:addEventListener("onQuestionButtonClicked", function(event) self:onQuestionButtonClicked(event) end)

    self.updateable = true
    self.schedule_selector = function(dt)
        self:onEnterFrame(dt)
    end
    self:schedule(self.schedule_selector, 3)
end

function ch3Scene1:onEnterFrame(dt)
    if self.prince.clicked ~= true then
        -- 提示点击仙女
        return
    end

    if self.cinderella.clicked ~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.prince.clicked == true and self.cinderella.clicked == true and self.updateable == true then
        publicmenu:displayQuestionButton(CCPoint(300, 220))
        self.updateable = false
        return
    end
end

function ch3Scene1:onEnter()
    -- 幕布
    publicmenu:showScreenCurtain(self)
end

function ch3Scene1:playAnimationWithLoops(parent, animname, duration, loops, clearup)
    local prod = coroutine.create(function()
        while true do
            local animation = parent:getAnimation()
            if animation ~= nil then
                animation:setAnimationScale(24 / 60) -- Flash fps is 24, cocos2d-x is 60
                animation:play(animname)
                coroutine.yield()
            end
        end
    end)
    
    for i = 1, loops do
        self:performWithDelay(function () coroutine.resume(prod) end, duration * (i - 1))
    end

    if clearup ~= false then
        self:performWithDelay(function () parent:removeFromParentAndCleanup(true) end, duration * loops)
    end
end

function ch3Scene1:playAnimationWithDelay(target, animname, delay)
    delay = delay or 0
    local animation = target:getAnimation()
    if animation ~= nil then
        animation:setAnimationScale(24 / 60) -- Flash fps is 24, cocos2d-x is 60
        self:performWithDelay(function () animation:play(animname) end, delay)
    end
end

function ch3Scene1:onQuestionButtonClicked(event)
    print "禁用本层点击事件"
    self.clock:setTouchEnabled(false)
    self.desk_1:setTouchEnabled(false)
    self.desk_2:setTouchEnabled(false)
    self.cinderella:setTouchEnabled(false)
    self.prince:setTouchEnabled(false)
end

function ch3Scene1:onRewindButtonClicked(event)
    print "Rewind Button Clicked."
end

function ch3Scene1:onExit()

end

return ch3Scene1;
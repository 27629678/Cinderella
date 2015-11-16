-- ch3Scene3.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-08

local objecteffect = import("..common.NEObjectActionEffect")
local publicmenu = import("..views.PublicUIMenu")
local uianimationex = import("..ui.UIAnimationEx")
local uispriteex = import("..ui.UISpriteEx")

local ch3Scene3 = class("ch3Scene3", function()
    return display.newScene("ch3Scene3")
end)


function ch3Scene3:ctor()
    local ch_id       = 3
    local ch_index    = 3
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

    -- 房子_2
    uisprite:newSprite("House_2.png", display.right - 280, display.cy - 30, true)

    -- 房子_1
    uisprite:newSprite("House_1.png", display.right - 100, display.cy, true)

    -- 刺猬
    uisprite:newSprite("Hedgehog.png", display.cx, display.cy - 150, true)

    -- 小鸡
    uisprite:newSprite("Chick.png", display.cx + 120, display.cy - 180, true)

    -- 小牛
    uisprite:newSprite("Calf.png", display.cx - 120, display.cy - 240, true)

    -- 鼹鼠
    uisprite:newSprite("Mole.png", display.cx + 250, display.cy - 130, true)

    -- 鼹鼠一家
    uisprite:newSprite("MoleFamily.png", display.cx + 460, display.cy - 260, true)

    -- 动画图层
    -- 公告板
    self.postboard = uianimationex:createAnimationWithArmature("banzi", CCPoint(display.cx - 450, display.cy - 110), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.postboard, function()
        audio.playMusic(string.format(SoundPath, "PostBoard.MP3"), false)
    end)

    -- 光效
    self.lighteffect = uianimationex:createAnimationWithArmature("guang", CCPoint(display.cx - 345, display.cy + 20), self.layer)

    -- 灰姑娘_1
    self.cinderella_1 = uianimationex:createAnimationWithArmature("dongzuo_1", CCPoint(display.cx - 344, display.cy + 14), self.layer)

    -- 灰姑娘_2
    self.cinderella_2 = uianimationex:createAnimationWithArmature("dongzuo_2", CCPoint(display.cx - 345, display.cy + 14), self.layer)

    -- 灰姑娘_3
    self.cinderella_3 = uianimationex:createAnimationWithArmature("dongzuo_3", CCPoint(display.cx - 344, display.cy + 11), self.layer)

    -- 守卫
    self.guard = uianimationex:createAnimationWithArmature("xiaogou_1", CCPoint(display.cx - 280, display.cy -150), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.guard, function()
        self:playAnimationWithDelay(self.guard, "dongzuo2")
        audio.playMusic(string.format(SoundPath, "Guard_1.MP3"), false)
        self.guard.clicked = true
    end)

    -- 小白兔
    self.rabbit = uianimationex:createAnimationWithArmature("weiguanzhe", CCPoint(display.cx - 420, display.cy - 340), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.rabbit, function()
        self:playAnimationWithDelay(self.rabbit, "weiguanzhe")
        audio.playMusic(string.format(SoundPath, "Rabbit.MP3"), false)
        self.rabbit.clicked = true
    end)

    -- 鼹鼠
    self.mole = uianimationex:createAnimationWithArmature("dishu", CCPoint(display.cx + 250, display.cy - 280), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.mole, function()
        self:playAnimationWithDelay(self.mole, "dishu")
    end)

    self:addChild(self.layer)

    -- UI Menu Buttons
    publicmenu:addUI({
        parent = self,
        listener_right  = function(index)
                                if index == 1 then
                                    self:playAnimationWithDelay(self.cinderella_1, "dongzuo1")
                                    self:playAnimationWithDelay(self.guard, "dongzuo1")
                                elseif index == 2 then
                                    self:playAnimationWithDelay(self.cinderella_2, "dongzuo2")
                                    self:playAnimationWithDelay(self.guard, "dongzuo1")
                                elseif index == 3 then
                                    self:playAnimationWithDelay(self.lighteffect, "guang")
                                    self:playAnimationWithLoops(self.lighteffect,"guang", 1,6,true)
                                    self:playAnimationWithDelay(self.cinderella_3, "dongzuo3")
                                    self:playAnimationWithDelay(self.guard, "dongzuo1")
                                else
                                    -- do nothing
                                end
                            end,
        listener_wrong  = function()
                                self:playAnimationWithDelay(self.guard, "dongzuo3")
                            end
        })

    self.updateable = true
    self.schedule_selector = function(dt)
        self:onEnterFrame(dt)
    end
    self:schedule(self.schedule_selector, 3)

    self:performWithDelay(function()
        audio.playMusic(string.format(SoundPath, "Guard_2.MP3"), false)
        self:playAnimationWithDelay(self.guard, "dongzuo1")
    end, 47)
end

function ch3Scene3:onEnterFrame(dt)
    if self.guard.clicked ~= true then
        -- 提示点击仙女
        return
    end

    if self.rabbit.clicked ~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.guard.clicked == true and self.rabbit.clicked == true and self.updateable == true then
        publicmenu:displayQuestionButton(CCPoint(display.cx + 100, display.bottom + 100))
        self.updateable = false
        return
    end
end

function ch3Scene3:onEnter()
    print "注册回调事件"
    publicmenu:addEventListener("onRewindButtonClicked", function(event) self:onRewindButtonClicked(event) end)
    publicmenu:addEventListener("onQuestionButtonClicked", function(event) self:onQuestionButtonClicked(event) end)

    -- 幕布
    publicmenu:showScreenCurtain(self)
end

function ch3Scene3:playAnimationWithLoops(parent, animname, duration, loops, clearup)
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

function ch3Scene3:playAnimationWithDelay(target, animname, delay)
    delay = delay or 0
    local animation = target:getAnimation()
    if animation ~= nil then
        animation:setAnimationScale(24 / 60) -- Flash fps is 24, cocos2d-x is 60
        self:performWithDelay(function () animation:play(animname) end, delay)
    end
end

function ch3Scene3:onQuestionButtonClicked(event)
    print "禁用角色触摸事件"
    -- self.cinderella_2:setTouchEnabled(false)
    -- self.prince_2:setTouchEnabled(false)
end

function ch3Scene3:onRewindButtonClicked(event)
    print "Rewind Button Clicked."
end

return ch3Scene3
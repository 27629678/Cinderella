-- ch3Scene2.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-04

local objecteffect = import("..common.NEObjectActionEffect")
local publicmenu = import("..views.PublicUIMenu")
local uianimationex = import("..ui.UIAnimationEx")
local uispriteex = import("..ui.UISpriteEx")

local ch3Scene2 = class("ch3Scene2", function()
    return display.newScene("ch3Scene2")
end)


function ch3Scene2:ctor()
    local ch_id       = 3
    local ch_index    = 2
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

    -- 月亮
    self.moon = uianimationex:createAnimationWithArmature("yueliang_1", CCPoint(display.cx - 300, display.top - 200), self.layer)

    -- 月亮之心
    self.moonheart = uianimationex:createAnimationWithArmature("yuelaing_2", CCPoint(display.cx - 300, display.top - 50), self.layer)

    -- 王子图层
    self.princelayer = display.newLayer():addTo(self.layer)

    -- 树_1
    uisprite:addSpriteWithLayer("Tree.png", display.cx + 90, display.cy + 30, self.princelayer, true)

    -- 树_2
    uisprite:addSpriteWithLayer("Tree.png", display.cx - 360, display.cy + 30, self.princelayer, true)

    -- 楼梯
    self.stairs = uisprite:addSpriteWithLayer("Stairs.png", display.right - 500, display.cy - 120, self.princelayer)

    -- 水晶鞋
    self.slipper = uisprite:addSpriteWithLayer("Slipper.png", 130, 80, self.stairs, true)
    self.slipper:setScale(0)

    -- 王子_1
    self.prince_1 = uianimationex:createAnimationWithArmature("wangzi_1", CCPoint(200, 130), self.stairs)
    self.prince_1:setScale(0)

    -- 王子房子
    local House_1 = uisprite:addSpriteWithLayer("House_1.png", display.right - 197, display.top - 347, self.princelayer)

    -- 王子_2
    self.prince_2 = uianimationex:createAnimationWithArmature("wangzi_2", CCPoint(House_1:getPositionX() - 70, House_1:getPositionY() - 190), self.princelayer)
    self.prince_2:setScale(0)
    uianimationex:roleAnimationAddTouchEvent(self.prince_2, function()
        self:playAnimationWithDelay(self.prince_2, "wangzi2")
        audio.playMusic(string.format(SoundPath, "Prince_1.MP3"), false)
        self.prince_2.clicked = true
    end)

    -- 灯笼
    uisprite:newSpriteWithPendulumEffect("Lantern.png", display.right - 185, display.top - 40, self.princelayer)

    -- 栏杆
    uisprite:addSpriteWithLayer("Handrail.png", House_1:getPositionX() + 3, House_1:getPositionY() - 150, self.princelayer)

    -- 灰姑娘图层
    self.cinderellalayer = display.newLayer():addTo(self.layer)
    self.cinderellalayer:setScale(0)

    -- 栅栏
    uisprite:addSpriteWithLayer("Lattice.png", display.left + 300, display.cy - 244, self.cinderellalayer)

    -- 灰姑娘的房子
    uisprite:addSpriteWithLayer("House_2.png", display.left + 164, display.bottom + 322, self.cinderellalayer)

    -- 灰姑娘_2
    self.cinderella_2 = uianimationex:createAnimationWithArmature("huiguniang_2", CCPoint(display.left + 93, display.bottom + 92), self.cinderellalayer)
    uianimationex:roleAnimationAddTouchEvent(self.cinderella_2, function()
        self:playAnimationWithDelay(self.cinderella_2, "dongzuo1")
        audio.playMusic(string.format(SoundPath, "Cinderella_1.MP3"), false)
        self.cinderella_2.clicked = true
    end)

    -- 灰姑娘_1
    self.cinderella_1 = uianimationex:createAnimationWithArmature("huiguniang_1", CCPoint(display.cx - 120, display.cy - 220), self.layer)
    self.cinderella_1:setScale(0)

    -- 无节操分隔线
    self.line = uisprite:newSprite("Line.png")
    self.line:setScale(0)

    -- 草-2
    display.newSprite("ChapterMaterial/Ch_3_2/Grass_2_1.png", display.left + 167,   display.bottom + 52):addTo(self.layer)
    display.newSprite("ChapterMaterial/Ch_3_2/Grass_2_2.png", display.right - 216,  display.bottom + 56):addTo(self.layer)

    self:addChild(self.layer)

    local function playLoveHeartAnimation(obj,name,duration)
        local loveheart_1 = uianimationex:createAnimationWithArmature("aixin", CCPoint(self.cinderella_2:getPositionX() + 55, self.cinderella_2:getPositionY() + 260), self.layer)
        local loveheart_2 = uianimationex:createAnimationWithArmature("aixin", CCPoint(self.prince_2:getPositionX() + 55, self.prince_2:getPositionY() + 300), self.layer)
        self:playAnimationWithLoops(loveheart_1, "aixin", 1.2, 2)
        self:playAnimationWithLoops(loveheart_2, "aixin", 1.2, 2)
        self:playAnimationWithLoops(obj, name, duration, 1, false)
    end

    -- UI Menu Buttons
    publicmenu:addUI({
        parent = self,
        listener_right  = function(index)
                                if index == 1 then
                                    playLoveHeartAnimation(self.moon, "dongzuo1", 21.0/24)
                                elseif index == 2 then
                                    playLoveHeartAnimation(self.moon, "dongzuo2", 29.0/24)
                                elseif index == 3 then
                                    self.moon:setScale(0)
                                    self.moonheart:setScale(1)
                                    playLoveHeartAnimation(self.moonheart, "dongzuo3", 39.0/24)
                                else
                                    -- do nothing
                                end
                            end,
        listener_wrong  = function()
                                self.moonheart:setScale(0)
                                self.moon:setScale(1)
                                -- audio.playMusic(string.format(SoundPath, "Cinderella_5.MP3"), false)
                                self:playAnimationWithLoops(self.moon, "dongzuo4", 35.0/24, 1, false)
                            end
        })
    
    self.updateable = true
    self.schedule_selector = function(dt)
        self:onEnterFrame(dt)
    end
    self:schedule(self.schedule_selector, 3)

    print "场景初始化完成"
end

function ch3Scene2:onEnterFrame(dt)
    if self.prince_2.clicked ~= true then
        -- 提示点击仙女
        return
    end

    if self.cinderella_2.clicked ~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.prince_2.clicked == true and self.cinderella_2.clicked == true and self.updateable == true then
        publicmenu:displayQuestionButton(CCPoint(420, 220))
        self.updateable = false
        return
    end
end

function ch3Scene2:onEnter()
    print "注册回调事件"
    publicmenu:addEventListener("onRewindButtonClicked", function(event) self:onRewindButtonClicked(event) end)
    publicmenu:addEventListener("onQuestionButtonClicked", function(event) self:onQuestionButtonClicked(event) end)

	-- 幕布
    publicmenu:showScreenCurtain(self)

    self:performWithDelay(function()
        transition.scaleTo(self.slipper, {scale = 1, time = 0.2})
        transition.scaleTo(self.cinderella_1, {scale = 1, time = 0.2})
        transition.scaleTo(self.prince_1, {scale = 1, time = 0.2})

        self:performWithDelay(function()
            self:playAnimationWithLoops(self.cinderella_1, "taopao", 20.0/24, 10)
            transition.moveTo(self.princelayer, {x = self.princelayer:getPositionX() + 400, time = 4})
            self:performWithDelay(function()
                transition.moveTo(self.cinderella_1, {x = self.cinderella_1:getPositionX() - 1200, time = 6})
            end, 3.6)
        end, 1)
    end, 16)

    self:performWithDelay(function()
        self.line:setScale(1)

        self.princelayer:setScale(0)
        self.princelayer:setPosition(0,0)
        self.stairs:setScale(0)
        self.prince_2:setScale(1)

        local sequence_1 = transition.sequence({
            CCScaleTo:create(1, 1),
            CCFadeOut:create(1)
        })
        self.cinderellalayer:runAction(sequence_1)

        local sequence_2 = transition.sequence({
            CCScaleTo:create(1, 1),
            CCFadeOut:create(1)
        })
        self.princelayer:runAction(sequence_2)
    end, 40)
end

function ch3Scene2:playAnimationWithLoops(parent, animname, duration, loops, clearup)
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

function ch3Scene2:playAnimationWithDelay(target, animname, delay)
    delay = delay or 0
    local animation = target:getAnimation()
    if animation ~= nil then
        animation:setAnimationScale(24 / 60) -- Flash fps is 24, cocos2d-x is 60
        self:performWithDelay(function () animation:play(animname) end, delay)
    end
end

function ch3Scene2:onQuestionButtonClicked(event)
    print "禁用角色触摸事件"
    self.cinderella_2:setTouchEnabled(false)
    self.prince_2:setTouchEnabled(false)
end

function ch3Scene2:onRewindButtonClicked(event)
    print "Rewind Button Clicked."
end

function ch3Scene2:onExit()

end

return ch3Scene2;
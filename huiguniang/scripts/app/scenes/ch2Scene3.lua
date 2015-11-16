-- ch2Scene3.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-03

local objecteffect = import("..common.NEObjectActionEffect")
local publicmenu = import("..views.PublicUIMenu")
local uianimationex = import("..ui.UIAnimationEx")

local ch2Scene3 = class("ch2Scene3", function()
    return display.newScene("ch2Scene3")
end)


function ch2Scene3:ctor()
    local ch_id       = 2
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

    self.rotatelayer = display.newLayer()
    self.rotatelayer:setAnchorPoint(CCPoint(0.5, 0.5))
    self.rotatelayer:setPosition(display.left + 10, display.bottom - 1080)

    self.rotatelayer_1 = display.newLayer()
    self.rotatelayer_1:setAnchorPoint(CCPoint(0.5, 0.5))
    self.rotatelayer_1:setPosition(display.left + 10, display.bottom - 1270)

    -- 背景图片
    local background_1 = display.newSprite(string.format(AssetsPath,"Background_1.jpg"), display.cx, display.top - 265):addTo(self.layer)
    
    -- 星光
    -- self.starlight = uianimationex:createAnimationWithArmature("xingguang", CCPoint(0, display.cy), self.layer)

    -- 城堡
    self.castle = display.newSprite(string.format(AssetsPath, "Castle.png"), display.left - 190, display.cy - 200):addTo(self.layer)
    objecteffect:Shake(self.castle, nil)
    self.castle:setScale(0)

    self.rotatelayer:addTo(self.layer)
    -- 旋转

    function createCircle(index, angle, sprite, layer)
        self.circle_1 = display.newSprite(string.format(AssetsPath, sprite), display.cx, display.cy):addTo(layer)
        self.circle_1:setAnchorPoint(CCPoint(0.5, 0))
        self.circle_1:setRotation(index * angle)
    end

    for i = 0 , 17 do
        createCircle(i, 20, "Circle_1.png", self.rotatelayer)

        createCircle(i, 20, "Circle_2.png", self.rotatelayer_1)
    end

    

    -- 中景图片
    display.newSprite(string.format(AssetsPath,"Background_2.jpg"), display.cx, background_1:getPositionY() - 330):addTo(self.layer)
    
    -- 旋转
    self.rotatelayer_1:addTo(self.layer)

    -- 前景
    display.newSprite(string.format(AssetsPath,"Grass_1.png"), display.cx, display.bottom + 62):addTo(self.layer)

    self:addChild(self.layer)

    -- 仙女
    self.wing = uianimationex:createAnimationWithArmature("chibang", CCPoint(display.right-260, display.cy), self.layer)
    self.fairy = uianimationex:createAnimationWithArmature("xiannv_1", CCPoint(display.right-220, display.cy-40), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.fairy, function()
        self:playAnimationWithDelay(self.fairy, "xiannv_1")
        audio.playMusic(string.format(SoundPath, "Fairy_1.MP3"), false)
        self.fairy.clicked = true
    end)

    self.carlayer = display.newLayer()
    self.carlayer:setPosition(self.carlayer:getPositionX(), self.carlayer:getPositionY() + 20)
    self.layer:addChild(self.carlayer)
    self.carupdateable = false

    -- 马蹄
    self.househoof_2 = uianimationex:createAnimationWithArmature("mati", CCPoint(display.cx-270, 195), self.carlayer)
    self.househoof_1 = uianimationex:createAnimationWithArmature("mati", CCPoint(display.cx-320, 180), self.carlayer)

    -- 南瓜车
    self.pumpkincar = uianimationex:createAnimationWithArmature("nanguache", CCPoint(display.cx-360, display.cy-200), self.carlayer)

    -- 灰姑娘
    self.cinderella = uianimationex:createAnimationWithArmature("huiguniang", CCPoint(display.cx+100, display.cy-100), self.carlayer)
    uianimationex:roleAnimationAddTouchEvent(self.cinderella, function()
        self:playAnimationWithDelay(self.cinderella, "zhaoshou")
        audio.playMusic(string.format(SoundPath, "Cinderella_1.MP3"), false)
        self.cinderella.clicked = true
    end)

    self.pumpkincar_speed = 30
    -- 车夫
    self.driver = uianimationex:createAnimationWithArmature("machefu", CCPoint(display.cx-90, display.cy-90), self.carlayer)

    -- UI Menu Buttons
    publicmenu:addUI({
        parent = self,
        listener_right  = function(index)
                                if index == 1 then
                                    self:playAnimationWithDelay(self.fairy, "xiannv_3")

                                    self:playAnimation(self.househoof_1, "mati", 0.25 * 2, true)
                                    self:playAnimation(self.househoof_2, "mati", 0.25 * 2, true)

                                    self:playAnimation(self.pumpkincar, "nanguache", 0.25, true)
                                    self.carupdateable = true

                                    self:rotateMyLayer(self.rotatelayer, 30)
                                    self:rotateMyLayer(self.rotatelayer_1, 30)
                                elseif index == 2 then

                                    transition.stopTarget(self.rotatelayer)
                                    self:rotateMyLayer(self.rotatelayer, 10)
                                    
                                    transition.stopTarget(self.rotatelayer_1)
                                    self:rotateMyLayer(self.rotatelayer_1, 10)

                                    self:playAnimationWithDelay(self.driver, "machefu")
                                elseif index == 3 then
                                    transition.scaleTo(self.castle, {scale = 1, time = 3})
                                    transition.moveTo(self.castle, {x = display.left + 190, y = display.cy - 60, time = 3})
                                else
                                    -- do nothing
                                end
                            end,
        listener_wrong  = function()
                                self:playAnimationWithDelay(self.driver, "dacuoti")
                                -- audio.playMusic(string.format(SoundPath, "Cinderella_5.MP3"), false)
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

function ch2Scene3:onEnterFrame(dt)
    if self.fairy.clicked ~= true then
        -- 提示点击仙女
        return
    end

    if self.cinderella.clicked ~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.fairy.clicked == true and self.cinderella.clicked == true and self.updateable == true then
        publicmenu:displayQuestionButton(CCPoint(display.cx, 200))
        self.updateable = false
        return
    end
end

function ch2Scene3:onEnter()
    -- 幕布
    publicmenu:showScreenCurtain(self)
end

function ch2Scene3:playAnimation(target, animname, duration, loop)
    loop = loop or false

    delay = duration or 0
    local animation = target:getAnimation()
    if animation ~= nil then
        animation:setAnimationScale(24 / 60) -- Flash fps is 24, cocos2d-x is 60
        animation:play(animname)

        if loop == true then
            self:performWithDelay(function () self:playAnimation(target, animname, duration, loop) end, delay)
        end
    end
end

function ch2Scene3:rotateMyLayer(obj, duration)
    duration = duration or 30

    transition.execute(obj, CCRotateBy:create(duration, 180), {
        onComplete = function()
            transition.rotateTo(obj, {rotate = 360, time = duration})
            self:performWithDelay(function()
                self:rotateMyLayer(obj, duration)
            end, duration)
        end,
    })
end

function ch2Scene3:onQuestionButtonClicked(event)
    -- 禁用本层点击事件
    self.cinderella:setTouchEnabled(false)
    self.fairy:setTouchEnabled(false)
end

function ch2Scene3:onRewindButtonClicked(event)
    print "Rewind Button Clicked."
end

function ch2Scene3:playAnimationWithDelay(target, animname, delay)
    delay = delay or 0
    local animation = target:getAnimation()
    if animation ~= nil then
        animation:setAnimationScale(24 / 60) -- Flash fps is 24, cocos2d-x is 60
        self:performWithDelay(function () animation:play(animname) end, delay)
    end
end

function ch2Scene3:playFairyAnima(offset, duration)
    self:performWithDelay(function()
        self:playAnimationWithDelay(self.wing, "chibang", duration)
        transition.moveTo(self.wing, {y = self.wing:getPositionY() + offset, time = duration})
        transition.moveTo(self.fairy, {y = self.fairy:getPositionY() + offset, time = duration})

        if self.carupdateable == true then
            local m_offset = offset > 0 and 15 or -15
            transition.moveTo(self.carlayer, {y = self.carlayer:getPositionY() - m_offset, time = duration})
        end

        self:playFairyAnima(-offset, duration)
    end, duration)
end

function ch2Scene3:onExit()
    publicmenu:onExit()
end

return ch2Scene3
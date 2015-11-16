-- ch4Scene2.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-08

local objecteffect = import("..common.NEObjectActionEffect")
local publicmenu = import("..views.PublicUIMenu")
local uianimationex = import("..ui.UIAnimationEx")
local uispriteex = import("..ui.UISpriteEx")

local ch4Scene2 = class("ch4Scene2", function()
    return display.newScene("ch4Scene2")
end)

function ch4Scene2:ctor()
    local ch_id       = 4
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

    -- 蜡烛左
    uisprite:newSpriteWithPendulumEffect("Candle.png", display.cx - 370, display.cy + 130, nil, CCPoint(0.5, 0))

    -- 蜡烛右
    uisprite:newSpriteWithPendulumEffect("Candle.png", display.cx + 440, display.cy + 30, nil, CCPoint(0.5, 0))

    -- 窗户左
    uisprite:newSprite("Window_Left.png", display.cx - 170, display.cy + 200)

    -- 窗户右
    uisprite:newSprite("Window_Right.png", display.cx + 170, display.cy + 200)

    -- 相框圆
    uisprite:newSpriteWithPendulumEffect("Frame_1.png", display.cx, display.cy + 160)

    -- 相框方
    uisprite:newSpriteWithPendulumEffect("Frame_2.png", display.cx + 340, display.cy + 260)

    -- 化妆台
    uisprite:newSprite("Dressers.png", display.left + 80, display.cy - 40, true)

    -- 沙发
    uisprite:newSprite("Sofa.png", display.right - 200, display.cy - 40, true)

    -- 坐垫
    self.cushion = uisprite:newSprite("Cushion.png", display.cx - 40, display.cy - 200)

    -- 动画图层
    -- 大姐
    self.sister_1 = uianimationex:createAnimationWithArmature("dajie_shixie", CCPoint(display.cx - 260, display.cy - 140), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.sister_1, function()
        uianimationex:playAnimationWithDelay(self, self.sister_1, "dajie_shixie")
        audio.playMusic(string.format(SoundPath, "Sister_1.MP3"), false)
        self.sister_1.clicked = true
    end)

    -- 二姐
    self.sister_2 = uianimationex:createAnimationWithArmature("erjie_shixie", CCPoint(display.cx - 380, display.cy - 200), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.sister_2, function()
        uianimationex:playAnimationWithDelay(self, self.sister_2, "erjie")
        audio.playMusic(string.format(SoundPath, "Sister_2.MP3"), false)
        self.sister_2.clicked = true
    end)

    -- 后妈
    self.stepmother = uianimationex:createAnimationWithArmature("houma_touxiao", CCPoint(display.cx + 280, display.cy - 200), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.stepmother, function()
        uianimationex:playAnimationWithDelay(self, self.stepmother, "touxiao")
        audio.playMusic(string.format(SoundPath, "StepMother_1.MP3"), false)
        self.stepmother.clicked = true
    end)

    -- 官员
    self.guard = uianimationex:createAnimationWithArmature("xiaogou_1", CCPoint(display.cx + 40, display.cy - 260), self.layer)

    -- 灰姑娘
    self.cinderella = uianimationex:createAnimationWithArmature("huiguniang_shixie", CCPoint(display.left - 100, display.cy - 300), self.layer)

    -- 猫
    local m_cat = uianimationex:createAnimationWithArmature("mao_1", CCPoint(display.cx + 300, display.cy - 360), self.layer)
    local mao_state = false
    uianimationex:roleAnimationAddTouchEvent(m_cat, function()
        if mao_state == true then return end

        mao_state = true
        uianimationex:playAnimationWithDelay(self, m_cat, "maozou")

        self:performWithDelay(function()
            mao_state = false
            uianimationex:playAnimationWithDelay(self, m_cat, "maotang")
        end, 54.0/24)
    end)

    -- 水晶鞋
    self.slipper = uianimationex:createAnimationWithArmature("xie faguang", CCPoint(display.cx - 85, display.cy - 220), self.layer)
    uianimationex:playAnimationWithDelay(self, self.slipper, "xie faguang")
    uianimationex:roleAnimationAddTouchEvent(self.slipper, function()
        uianimationex:playAnimationWithDelay(self, self.slipper, "xie faguang")
    end)

    -- 鸽子图层
    self.pigeonlayer = display.newLayer():addTo(self.layer)
    self.wing_1 = uianimationex:createAnimationWithArmature("chibang", CCPoint(display.cx-10, display.cy + 5), self.pigeonlayer)
    uianimationex:playAnimaForever({
            scene   = self,
            obj     = self.wing_1,
            name    = "chibang",
            duration= 12.0/24,
        })

    self.pigeon = uisprite:addSpriteWithLayer("Pigeon.png", display.cx, display.cy + 10, self.pigeonlayer)

    self.wing_2 = uianimationex:createAnimationWithArmature("chibang", CCPoint(display.cx - 5, display.cy), self.pigeonlayer)
    uianimationex:playAnimaForever({
            scene   = self,
            obj     = self.wing_2,
            name    = "chibang",
            duration= 12.0/24,
        })
    self.pigeonlayer:setPosition(1360, 880)

    self:addChild(self.layer)

    -- UI Menu Buttons
    publicmenu:addUI({
        parent = self,
        listener_right  = function(index)
                                if index == 1 then
                                    local anim = uianimationex:createAnimationWithArmature("dongzuo_1", CCPoint(display.cx - 85, display.cy - 210), self.layer)
                                    uianimationex:playAnimationWithDelay(self, anim, "dongzuo_1")
                                    self:performWithDelay(function()
                                        anim:removeFromParentAndCleanup(true)
                                    end, 83.0/24)
                                elseif index == 2 then
                                    uianimationex:playAnimationWithDelay(self, self.slipper, "xie faguang")
                                elseif index == 3 then
                                    self.slipper:setScale(0)
                                    local anim = uianimationex:createAnimationWithArmature("dongzuo_3", CCPoint(display.cx - 70, display.cy - 210), self.layer)
                                    uianimationex:playAnimationWithDelay(self, anim, "dongzuo_3")
                                    self:performWithDelay(function()
                                        uianimationex:playAnimationWithDelay(self, self.cinderella, "dongzuo3")

                                        audio.playMusic(string.format(SoundPath, "Right_3.MP3"), false)
                                    end, 20.0/24)

                                    self:performWithDelay(function()
                                        anim:removeFromParentAndCleanup(true)
                                    end, 61.0/24)
                                else
                                    -- do nothing
                                end
                            end,
        listener_wrong  = function()
                                uianimationex:playAnimationWithDelay(self, self.mouse_3, "yaotou")
                                audio.playMusic(string.format(SoundPath, "Wrong.MP3"), false)
                            end
        })

    self.updateable = true
    self.schedule_selector = function(dt)
        self:onEnterFrame(dt)
    end
    self:schedule(self.schedule_selector, 3)

    self:performWithDelay(function()
        uianimationex:playAnimationWithDelay(self, self.guard, "shibing jia")

        audio.playMusic(string.format(SoundPath, "Guard_1.MP3"), false)
        self:performWithDelay(function()
            transition.moveTo(self.pigeonlayer, {x = 60, y = -80, time = 3})
        end, 114.0/24 - 2.5)
    end, 3)
end

function ch4Scene2:onEnterFrame(dt)
    if self.sister_1.clicked ~= true then
        -- 提示点击仙女
        return
    end

    if self.sister_2.clicked ~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.stepmother.clicked ~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.sister_1.clicked == true and self.sister_2.clicked == true and self.stepmother.clicked == true and self.updateable == true then
        publicmenu:displayQuestionButton(CCPoint(display.cx + 100, display.bottom + 100))
        self.updateable = false
        return
    end
end

function ch4Scene2:onEnter()
    print "注册回调事件"
    publicmenu:addEventListener("onRewindButtonClicked", function(event) self:onRewindButtonClicked(event) end)
    publicmenu:addEventListener("onQuestionButtonClicked", function(event) self:onQuestionButtonClicked(event) end)

    -- 幕布
    publicmenu:showScreenCurtain(self)
end

function ch4Scene2:onQuestionButtonClicked(event)
    print "禁用角色触摸事件"
    self.sister_1:setTouchEnabled(false)
    self.sister_2:setTouchEnabled(false)
    self.stepmother:setTouchEnabled(false)
    self.cinderella:setTouchEnabled(false)
end

function ch4Scene2:onRewindButtonClicked(event)
    print "Rewind Button Clicked."
end

return ch4Scene2

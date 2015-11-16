-- ch1Scene1.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-09

local objecteffect = import("..common.NEObjectActionEffect")
local publicmenu = import("..views.PublicUIMenu")
local uianimationex = import("..ui.UIAnimationEx")
local uispriteex = import("..ui.UISpriteEx")

local ch1Scene1 = class("ch1Scene1", function()
    return display.newScene("ch1Scene1")
end)

function ch1Scene1:ctor()
    local ch_id       = 1
    local ch_index    = 1
    local AssetsPath  = string.format("ChapterMaterial/Ch_%d_%d/", ch_id, ch_index) .. "%s"
    local SoundPath   = string.format("ChapterMaterial/Ch_%d_%d/Sound/", ch_id, ch_index) .. "%s"

    local Anim_Png    = string.format("ChapterMaterial/Ch_%d_%d/Animation/AnimData.png", ch_id, ch_index)
    local Anim_Plist  = string.format("ChapterMaterial/Ch_%d_%d/Animation/AnimData.plist", ch_id, ch_index)
    local Anim_Xml    = string.format("ChapterMaterial/Ch_%d_%d/Animation/AnimData.xml", ch_id, ch_index)

    -- 加载动画数据文件
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(Anim_Png, Anim_Plist, Anim_Xml)

    -- 自定义图层
    self.layer = display.newLayer():addTo(self)

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
    local sofa = uisprite:newSprite("Sofa.png", display.right - 200, display.cy - 40, true)

    -- 衣服_1
    self.clothes_1 = uisprite:newSprite("Clothes_1.png", display.cx - 260, display.cy - 200)

    -- 衣服_2
    self.clothes_2 = uisprite:addSpriteWithLayer("Clothes_2.png", 40, 60, sofa)

    -- 杂物_1
    self.debris_1 = uisprite:newSprite("Debris_1.png", display.cx - 120, display.cy - 300)

    -- 大姐
    self.sister_1 = uianimationex:createAnimationWithArmature("dajie_1", CCPoint(display.cx - 50, display.cy - 140), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.sister_1, function()
        uianimationex:playAnimationWithDelay(self, self.sister_1, "dajiedongzuo")
        audio.playMusic(string.format(SoundPath, "Sister_1_1.MP3"), false)
        self.sister_1.clicked = true
    end)

    -- 二姐
    self.sister_2 = uianimationex:createAnimationWithArmature("erjie_1", CCPoint(display.cx - 380, display.cy - 200), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.sister_2, function()
        uianimationex:playAnimationWithDelay(self, self.sister_2, "erjiedongzuo")
        audio.playMusic(string.format(SoundPath, "Sister_2_1.MP3"), false)
        self.sister_2.clicked = true
    end)

    -- 后妈
    self.stepmother = uianimationex:createAnimationWithArmature("houma_1", CCPoint(display.cx + 230, display.cy - 200), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.stepmother, function()
        uianimationex:playAnimationWithDelay(self, self.stepmother, "touxiao")
        audio.playMusic(string.format(SoundPath, "StepMother_1.MP3"), false)
        self.stepmother.clicked = true
    end)

    -- 桌子
    self.desk = uisprite:newSprite("Desk.png", display.cx + 150, display.cy - 220, true)

    -- 杂物_2
    self.debris_2 = uisprite:addSpriteWithLayer("Debris_2.png", 60, 140, self.desk)

    -- 灰姑娘
    self.cinderella = uianimationex:createAnimationWithArmature("huiguniang_1", CCPoint(display.cx - 220, display.cy - 300), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.cinderella, function()
        uianimationex:playAnimationWithDelay(self, self.cinderella, "cahansaodi")
        audio.playMusic(string.format(SoundPath, "Cinderella_1.MP3"), false)
        self.cinderella.clicked = true
    end)

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

    -- UI Menu Buttons
    publicmenu:addUI({
        parent = self,
        listener_right  = function(index)
                                if index == 1 then
                                    uianimationex:playAnim(self.cinderella, "xiao")
                                    audio.playMusic(string.format(SoundPath, "Cinderella_2.MP3"), false)
                                    transition.fadeOut(self.debris_1, {time = 1})
                                elseif index == 2 then
                                    uianimationex:playAnim(self.cinderella, "xiao")
                                    audio.playMusic(string.format(SoundPath, "Cinderella_2.MP3"), false)
                                    transition.fadeOut(self.debris_2, {time = 1})
                                elseif index == 3 then
                                    uianimationex:playAnim(self.cinderella, "xiao")
                                    audio.playMusic(string.format(SoundPath, "Cinderella_3.MP3"), false)
                                    transition.fadeOut(self.clothes_1, {time = 1})
                                    transition.fadeOut(self.clothes_2, {time = 1})
                                else
                                    -- do nothing
                                end
                            end,
        listener_wrong  = function()
                                uianimationex:playAnimationWithDelay(self, self.cinderella, "ku")
                                audio.playMusic(string.format(SoundPath, "Wrong.MP3"), false)
                            end
        })
    
    -- Update事件
    self.updateable = true
    self.schedule_selector = function(dt)
        self:onEnterFrame(dt)
    end
    self:schedule(self.schedule_selector, 3)

    -- 播放叙事对话
    self:performWithDelay(function()
        uianimationex:playAnimationWithDelay(self, self.stepmother, "chayao")

        audio.playMusic(string.format(SoundPath, "StepMother_2.MP3"), false)
    end, 51)
end

function ch1Scene1:onEnterFrame(dt)
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

    if self.cinderella.clicked~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.sister_1.clicked == true and self.sister_2.clicked == true and self.stepmother.clicked == true and self.cinderella.clicked == true and self.updateable == true then
        publicmenu:displayQuestionButton(CCPoint(display.cx + 100, display.bottom + 100))
        self.updateable = false
        return
    end
end

function ch1Scene1:onEnter()
    print "注册回调事件"
    publicmenu:addEventListener("onRewindButtonClicked", function(event) self:onRewindButtonClicked(event) end)
    publicmenu:addEventListener("onQuestionButtonClicked", function(event) self:onQuestionButtonClicked(event) end)

    -- 幕布
    publicmenu:showScreenCurtain(self)
end

function ch1Scene1:onQuestionButtonClicked(event)
    print "禁用角色触摸事件"
    self.sister_1:setTouchEnabled(false)
    self.sister_2:setTouchEnabled(false)
    self.stepmother:setTouchEnabled(false)
    self.cinderella:setTouchEnabled(false)
end

function ch1Scene1:onRewindButtonClicked(event)
    print "Rewind Button Clicked."
end

function ch1Scene1:onExit()

end

return ch1Scene1

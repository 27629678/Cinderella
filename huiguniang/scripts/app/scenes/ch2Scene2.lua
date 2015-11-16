-- ch2Scene2.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-02

local objecteffect = import("..common.NEObjectActionEffect")
local publicmenu = import("..views.PublicUIMenu")
local uianimationex = import("..ui.UIAnimationEx")

local ch2Scene2 = class("ch2Scene2", function()
    return display.newScene("ch2Scene2")
end)


function ch2Scene2:ctor()
    local ch_id       = 2
    local ch_index    = 1
    local AssetsPath  = string.format("ChapterMaterial/Ch_%d_%d/", ch_id, ch_index) .. "%s"
    local SoundPath   = string.format("ChapterMaterial/Ch_%d_%d/Sound/", ch_id, ch_index + 1) .. "%s"

    local Anim_Png    = string.format("ChapterMaterial/Ch_%d_%d/Animation/AnimData.png", ch_id, ch_index)
    local Anim_Plist  = string.format("ChapterMaterial/Ch_%d_%d/Animation/AnimData.plist", ch_id, ch_index)
    local Anim_Xml    = string.format("ChapterMaterial/Ch_%d_%d/Animation/AnimData.xml", ch_id, ch_index)

    -- 加载动画数据文件
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(Anim_Png, Anim_Plist, Anim_Xml)

    -- 自定义图层
    self.layer = display.newLayer()

    -- 背景图片
    display.newSprite("ChapterMaterial/Ch_2_1/Background.jpg", display.cx, display.cy):addTo(self.layer)

    -- 星光
    self.starlight = uianimationex:createAnimationWithArmature("xingguang", CCPoint(0, display.cy), self.layer)

    -- 房子
    self.house = display.newSprite("ChapterMaterial/Ch_2_1/House.png", display.right-160, display.cy-140):addTo(self.layer)
    objecteffect:Shake(self.house, nil)

    -- 树
    self.tree = display.newSprite("ChapterMaterial/Ch_2_1/Tree.png", display.left+120, display.cy-180):addTo(self.layer)
    objecteffect:Shake(self.tree, nil)

    -- 草—1
    local grass_1 = display.newSprite("ChapterMaterial/Ch_2_1/Grass_1.png", self.tree:getPositionX()-70, self.tree:getPositionY()+20):addTo(self.layer)

    -- 南瓜
    self.pumpkin = uianimationex:createAnimationWithArmature("biannangua", CCPoint(display.cx + 20, display.bottom + 200), self.layer)
    
    -- 米老鼠_2
    self.mickeymouse_2 = uianimationex:createAnimationWithArmature("bianmachefu", CCPoint(display.cx - 260, display.bottom + 100), self.layer)

    -- 米老鼠_1
    self.mickeymouse_1 = uianimationex:createAnimationWithArmature("bian laoshu", CCPoint(display.cx - 100, display.bottom + 100), self.layer)

    -- 灰姑娘
    self.cinderella = uianimationex:createAnimationWithArmature("huiguniang_3", CCPoint(display.cx - 200, display.cy-360), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.cinderella, function()
        self:playAnimationWithDelay(self.cinderella, "danyou")
        audio.playMusic(string.format(SoundPath, "Cinderella_1.MP3"), false)
        self.cinderella.clicked = true
    end)

    -- 仙女
    self.wing = uianimationex:createAnimationWithArmature("chibang", CCPoint(display.cx-500, display.cy), self.layer)
    self.fairy = uianimationex:createAnimationWithArmature("xiannv1", CCPoint(display.cx-440, display.cy-60), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.fairy, function()
        self:playAnimationWithDelay(self.fairy, "xiannv_1")
        audio.playMusic(string.format(SoundPath, "Fairy_1.MP3"), false)
        self.fairy.clicked = true
    end)

    self:addChild(self.layer)
    
    -- 草-2
    display.newSprite("ChapterMaterial/Ch_2_1/Grass_2_1.png", display.left + 167,   display.bottom + 52):addTo(self)
    display.newSprite("ChapterMaterial/Ch_2_1/Grass_2_2.png", display.right - 216,  display.bottom + 56):addTo(self)

    -- UI Menu Buttons
    publicmenu:addUI({
        parent = self,
        listener_right  = function(index)
                                if index == 1 then
                                    self:playAnimationWithDelay(self.pumpkin, "biannangua")
                                    audio.playMusic(string.format(SoundPath, "Cinderella_2.MP3"), false)
                                elseif index == 2 then
                                    self:playAnimationWithDelay(self.mickeymouse_2, "bianmachefu")
                                    audio.playMusic(string.format(SoundPath, "Cinderella_3.MP3"), false)
                                elseif index == 3 then
                                    audio.playMusic(string.format(SoundPath, "Cinderella_4.MP3"), false)
                                    self:playAnimationWithDelay(self.mickeymouse_1, "bianlaoshu")
                                else
                                    -- do nothing
                                end
                            end,
        listener_wrong  = function()
                                audio.playMusic(string.format(SoundPath, "Cinderella_5.MP3"), false)
                            end
        })

    publicmenu:addEventListener("onRewindButtonClicked", function(event) self:onRewindButtonClicked(event) end)
    publicmenu:addEventListener("onQuestionButtonClicked", function(event) self:onQuestionButtonClicked(event) end)

    -- self:scheduleUpdate(function(dt) self:onEnterFrame(dt) end)
    self.updateable = true
    self.schedule_selector = function(dt)
        self:onEnterFrame(dt)
    end
    self:schedule(self.schedule_selector, 3)
end

function ch2Scene2:onEnterFrame(dt)
    if self.fairy.clicked ~= true then
        -- 提示点击仙女
        return
    end

    if self.cinderella.clicked ~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.fairy.clicked == true and self.cinderella.clicked == true and self.updateable == true then
        publicmenu:displayQuestionButton(CCPoint(640, 140))
        self.updateable = false
        return
    end
end

function ch2Scene2:onQuestionButtonClicked(event)
    -- 禁用本层点击事件
    self.house:setTouchEnabled(false)
    self.tree:setTouchEnabled(false)
    self.cinderella:setTouchEnabled(false)
    self.fairy:setTouchEnabled(false)
end

function ch2Scene2:onRewindButtonClicked(event)
    print "Rewind Button Clicked."
end

function ch2Scene2:onEnter()
    -- 幕布
    publicmenu:showScreenCurtain(self)
end

function ch2Scene2:playAnimationWithDelay(target, animname, delay)
    delay = delay or 0
    local animation = target:getAnimation()
    if animation ~= nil then
        animation:setAnimationScale(24 / 60) -- Flash fps is 24, cocos2d-x is 60
        self:performWithDelay(function () animation:play(animname) end, delay)
    end
end

function ch2Scene2:playFairyAnima(offset, duration)
    self:performWithDelay(function()
        self:playAnimationWithDelay(self.wing, "chibang", duration)
        self:playAnimationWithDelay(self.starlight, "xingguang", duration)
        transition.moveTo(self.wing, {y = self.wing:getPositionY() + offset, time = duration})
        transition.moveTo(self.fairy, {y = self.fairy:getPositionY() + offset, time = duration})

        self:playFairyAnima(-offset, duration)
    end, duration)
end

function ch2Scene2:onExit()
    publicmenu:onExit()
end

return ch2Scene2
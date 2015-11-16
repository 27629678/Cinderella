-- ch2Scene2.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-01

local objecteffect = import("..common.NEObjectActionEffect")
local publicmenu = import("..views.PublicUIMenu")
local uianimationex = import("..ui.UIAnimationEx")

local ch2Scene1 = class("ch2Scene1", function()
    return display.newScene("ch2Scene1")
end)


function ch2Scene1:ctor()
    require("framework.api.EventProtocol").extend(self)

    local ch_id       = 2
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

    -- 背景图片
    display.newSprite("ChapterMaterial/Ch_2_1/Background.jpg", display.cx, display.cy):addTo(self.layer)

    -- 星光
    self.starlight = createAnimationWithArmature("xingguang", CCPoint(display.cx - 512, display.cy), self.layer)

    -- 房子
    self.house = display.newSprite("ChapterMaterial/Ch_2_1/House.png", display.right-160, display.cy-140):addTo(self.layer)
    objecteffect:Shake(self.house, nil)

    -- 树
    self.tree = display.newSprite("ChapterMaterial/Ch_2_1/Tree.png", display.left+120, display.cy-180):addTo(self.layer)
    objecteffect:Shake(self.tree, nil)

    -- 草—1
    local grass_1 = display.newSprite("ChapterMaterial/Ch_2_1/Grass_1.png", self.tree:getPositionX()-70, self.tree:getPositionY()+20):addTo(self.layer)

    -- 灰姑娘
    self.cinderella = createAnimationWithArmature("huiguniang_1", CCPoint(display.cx-60, display.cy-260), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.cinderella, function()
        self:playAnimationWithDelay(self.cinderella, "xiao")
        audio.playMusic(string.format(SoundPath, "Cinderella_1.MP3"), false)
        self.cinderella.clicked = true
    end)

    -- 仙女
    self.wing = createAnimationWithArmature("chibang", CCPoint(display.cx-400, display.cy), self.layer)
    self.fairy = createAnimationWithArmature("xiannv1", CCPoint(display.cx-340, display.cy-60), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.fairy, function()
        self:playAnimationWithDelay(self.fairy, "xiannv_1")
        audio.playMusic(string.format(SoundPath, "Fairy_1.MP3"), false)
        self.fairy.clicked = true
    end)

    -- 爆炸效果
    -- self.explosion = createAnimationWithArmature("baozha", CCPoint(display.cx, display.cy), self.layer)

    self:addChild(self.layer)

    -- 灯光效果
    self.light = display.newSprite("ChapterMaterial/Ch_2_1/Light.png", display.cx, display.cy):addTo(self)

    -- 草-2
    display.newSprite("ChapterMaterial/Ch_2_1/Grass_2_1.png", display.left + 167,   display.bottom + 52):addTo(self)
    display.newSprite("ChapterMaterial/Ch_2_1/Grass_2_2.png", display.right - 216,  display.bottom + 56):addTo(self)

    -- UI Menu Buttons
    publicmenu:addUI({
        parent = self,
        listener_right  = function(index)
                                if self.cinderella ~= nil then self.cinderella:removeFromParentAndCleanup(true) end
                                if self.explosion ~= nil then self.explosion:removeFromParentAndCleanup(true) end

                                if index == 1 then
                                    self.cinderella = createAnimationWithArmature("huiguniang_2_1", CCPoint(display.cx-60, display.cy-260), self.layer)
                                    self.cinderella:setScale(0)

                                    -- 爆炸效果
                                    self.explosion = createAnimationWithArmature("baozha", CCPoint(display.cx + 80, display.cy), self.layer)
                                    self:playAnimationWithDelay(self.explosion, "baozha")
                                    self.cinderella:setScale(1)
                                elseif index == 2 then
                                    self.cinderella = createAnimationWithArmature("huiguniang_2_2", CCPoint(display.cx-60, display.cy-260), self.layer)
                                    self.cinderella:setScale(0)

                                    -- 爆炸效果
                                    self.explosion = createAnimationWithArmature("baozha", CCPoint(display.cx + 80, display.cy), self.layer)
                                    self:playAnimationWithDelay(self.explosion, "baozha")
                                    self.cinderella:setScale(1)
                                elseif index == 3 then
                                    self.cinderella = createAnimationWithArmature("huiguniang_2_3", CCPoint(display.cx-60, display.cy-260), self.layer)
                                    self.cinderella:setScale(0)

                                    -- 爆炸效果
                                    self.explosion = createAnimationWithArmature("baozha", CCPoint(display.cx + 80, display.cy), self.layer)
                                    self:playAnimationWithDelay(self.explosion, "baozha")
                                    self.cinderella:setScale(1)
                                else
                                    self.cinderella = createAnimationWithArmature("huiguniang_3", CCPoint(display.cx-60, display.cy-260), self.layer)
                                end
                            end,
        listener_wrong  = function()
                                print "Wrong"
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

function ch2Scene1:onEnterFrame(dt)
    if self.fairy.clicked ~= true then
        -- 提示点击仙女
        return
    end

    if self.cinderella.clicked ~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.fairy.clicked == true and self.cinderella.clicked == true and self.updateable == true then
        publicmenu:displayQuestionButton(CCPoint(300, 200))
        self.updateable = false
        return
    end
end

function ch2Scene1:onQuestionButtonClicked(event)
    -- 禁用本层点击事件
    self.house:setTouchEnabled(false)
    self.tree:setTouchEnabled(false)
    self.cinderella:setTouchEnabled(false)
    self.fairy:setTouchEnabled(false)
end

function ch2Scene1:onRewindButtonClicked(event)
    print "Rewind Button Clicked."
end

function ch2Scene1:onEnter()
    -- 幕布
    publicmenu:showScreenCurtain(self)
end

function createAnimationWithArmature(name, pos, parent)
    local anim = CCNodeExtend.extend(CCArmature:create(name))
    anim:setAnchorPoint(CCPoint(0,0))
    anim:setPosition(pos)
    anim:addTo(parent)

    return anim
end

function ch2Scene1:playAnimationWithDelay(target, animname, delay)
    delay = delay or 0
    local animation = target:getAnimation()
    if animation ~= nil then
        animation:setAnimationScale(24 / 60) -- Flash fps is 24, cocos2d-x is 60
        self:performWithDelay(function () animation:play(animname) end, delay)
    end
end

function ch2Scene1:playFairyAnima(offset, duration)
    self:performWithDelay(function()
        self:playAnimationWithDelay(self.wing, "chibang", duration)
        self:playAnimationWithDelay(self.starlight, "xingguang", duration)
        transition.moveTo(self.wing, {y = self.wing:getPositionY() + offset, time = duration})
        transition.moveTo(self.fairy, {y = self.fairy:getPositionY() + offset, time = duration})

        self:playFairyAnima(-offset, duration)
    end, duration)
end

function ch2Scene1:onExit()
    self:unscheduleUpdate()
    publicmenu:onExit()
end

return ch2Scene1
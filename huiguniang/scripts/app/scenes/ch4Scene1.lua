-- ch4Scene1.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-08

local objecteffect = import("..common.NEObjectActionEffect")
local publicmenu = import("..views.PublicUIMenu")
local uianimationex = import("..ui.UIAnimationEx")
local uispriteex = import("..ui.UISpriteEx")

local ch4Scene1 = class("ch4Scene1", function()
    return display.newScene("ch4Scene1")
end)


function ch4Scene1:ctor()
    local ch_id       = 4
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

    -- 蜡烛
    uisprite:newSpriteWithPendulumEffect("Candle.png", display.cx, display.cy + 60, nil, CCPoint(0.5, 0))

    -- 木头堆
    uisprite:newSprite("Wood.png", display.cx-160, display.cy-80, true)

    -- 楼梯
    uisprite:newSprite("Stairs.png", display.cx+202, display.cy-30)

    -- 桌子
    uisprite:newSprite("Desk.png", display.left + 92, display.cy-98, true)

    -- 水桶
    local bucket = uisprite:newSprite("Bucket.png", display.cx-302, display.cy-230)

    self:addChild(self.layer)

    -- 动画图层
    -- 小黄鸟
    self.birdlayer = display.newLayer():addTo(self.layer)
    self.wing_1 = uianimationex:createAnimationWithArmature("chibang", CCPoint(display.cx + 6 - 300, display.cy + 6), self.birdlayer)
    uianimationex:playAnimaForever({
            scene   = self,
            obj     = self.wing_1,
            name    = "chibang",
            duration= 10.0/24,
        })
    self.bird_1 = uianimationex:createAnimationWithArmature("niao_1", CCPoint(display.cx-10 - 300, display.cy-30), self.birdlayer)
    uianimationex:roleAnimationAddTouchEvent(self.bird_1, function()
        uianimationex:playAnimationWithDelay(self, self.bird_1, "niao_1")
    end)
    self.wing_2 = uianimationex:createAnimationWithArmature("chibang", CCPoint(display.cx - 300, display.cy), self.birdlayer)
    uianimationex:playAnimaForever({
            scene   = self,
            obj     = self.wing_2,
            name    = "chibang",
            duration= 10.0/24,
        })
    objecteffect:MoveUpandDown(self, self.birdlayer, 20, 0.6)

    -- 小兰鸟
    self.bird_2 = uianimationex:createAnimationWithArmature("niao_2", CCPoint(30, 70), bucket)
    uianimationex:roleAnimationAddTouchEvent(self.bird_2, function()
        uianimationex:playAnimationWithDelay(self, self.bird_2, "niao_2")
        objecteffect:Bource(bucket,nil)
    end)

    -- 小白鸟
    self.bird_3 = uianimationex:createAnimationWithArmature("niao_3", CCPoint(display.cx - 40, display.cy + 15), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.bird_3, function()
        uianimationex:playAnimationWithDelay(self, self.bird_3, "niao_3")
    end)

    -- 门
    self.door = uianimationex:createAnimationWithArmature("men", CCPoint(display.cx + 155, display.cy + 26), self.layer)

    -- 老鼠甲
    self.mouse_1 = uianimationex:createAnimationWithArmature("laoshu_A", CCPoint(display.cx - 40, display.cy - 236), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.mouse_1, function()
        uianimationex:playAnimationWithDelay(self, self.mouse_1, "laoshu_jia")
        audio.playMusic(string.format(SoundPath, "Mouse_1.MP3"), false)
        self.mouse_1.clicked = true
    end)

    -- 老鼠乙
    self.mouse_2 = uianimationex:createAnimationWithArmature("dongzuo1", CCPoint(display.cx + 146, display.cy - 280), self.layer)

    -- 老鼠学者
    self.mouse_3 = uianimationex:createAnimationWithArmature("laoshu_B", CCPoint(display.cx - 230, display.cy - 280), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.mouse_3, function()
        uianimationex:playAnimationWithDelay(self, self.mouse_3, "laoshu_yi")
        audio.playMusic(string.format(SoundPath, "Mouse_2.MP3"), false)
        self.mouse_3.clicked = true
    end)

    -- UI Menu Buttons
    publicmenu:addUI({
        parent = self,
        listener_right  = function(index)
                                if index == 1 then
                                    uianimationex:playAnimationWithDelay(self, self.mouse_2, "dongzuo1")
                                elseif index == 2 then
                                    self.mouseanim = uianimationex:createAnimationWithArmature("dongzuo2", CCPoint(display.cx - 40, display.cy - 280), self.layer)
                                    if self.mouse_2 ~= nil then self.mouse_2:setScale(0) end
                                    if self.mouse_1 ~= nil then self.mouse_1:setScale(0) end
                                    uianimationex:playAnimationWithDelay(self, self.mouseanim, "dongzuo2")
                                elseif index == 3 then
                                    uianimationex:playAnimationWithDelay(self, self.mouseanim, "dongzuo3")

                                    self:performWithDelay(function()
                                        uianimationex:playAnimationWithDelay(self, self.door, "dongzuo3_men")
                                    end, 69.0/24 * 0.2)

                                    self:performWithDelay(function()
                                        uianimationex:playAnimationWithDelay(self, self.mouse_3, "dongzuo3_B")
                                    end, 69.0/24 * 0.45)
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
        audio.playMusic(string.format(SoundPath, "Mouse_3.MP3"), false)
    end, 47)
end

function ch4Scene1:onEnterFrame(dt)
    if self.mouse_1.clicked ~= true then
        -- 提示点击仙女
        return
    end

    if self.mouse_3.clicked ~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.mouse_1.clicked == true and self.mouse_3.clicked == true and self.updateable == true then
        publicmenu:displayQuestionButton(CCPoint(display.cx + 100, display.bottom + 100))
        self.updateable = false
        return
    end
end

function ch4Scene1:onEnter()
	print "注册回调事件"
    publicmenu:addEventListener("onRewindButtonClicked", function(event) self:onRewindButtonClicked(event) end)
    publicmenu:addEventListener("onQuestionButtonClicked", function(event) self:onQuestionButtonClicked(event) end)

    -- 幕布
    publicmenu:showScreenCurtain(self)
end

function ch4Scene1:onQuestionButtonClicked(event)
    print "禁用角色触摸事件"
    self.mouse_1:setTouchEnabled(false)
    self.mouse_3:setTouchEnabled(false)
end

function ch4Scene1:onRewindButtonClicked(event)
    print "Rewind Button Clicked."
end

return ch4Scene1
-- ch4Scene3.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-09

local objecteffect = import("..common.NEObjectActionEffect")
local publicmenu = import("..views.PublicUIMenu")
local uianimationex = import("..ui.UIAnimationEx")
local uispriteex = import("..ui.UISpriteEx")

local ch4Scene3 = class("ch4Scene3", function()
    return display.newScene("ch4Scene3")
end)


function ch4Scene3:ctor()
    local ch_id       = 4
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

    -- 相框
    uisprite:newSprite("Frame_1.png", display.cx - 300, display.cy + 220)

    -- 桌子
    uisprite:newSprite("Candle.png", display.cx - 300, display.cy + 30, true)

    -- 花瓶
    uisprite:newSprite("Vase.png", display.cx + 260, display.cy + 20, true)

    -- 小兰鸟
    self.bluebird = uianimationex:createAnimationWithArmature("niao_2", CCPoint(display.left - 120, display.cy + 110), self.layer)

    -- 小黄鸟
    self.yellowbird = uianimationex:createAnimationWithArmature("niao_3", CCPoint(display.left - 120, display.cy + 200), self.layer)

    -- 小白鸟
    self.whitebird = uianimationex:createAnimationWithArmature("niao_1", CCPoint(display.right + 60, display.cy + 140), self.layer)
    
    -- 国王
    uisprite:newSprite("King.png", display.left + 90, display.cy - 30, true)

    -- 小猪
    uisprite:newSprite("Pig.png", display.right - 160, display.cy - 50, true)

    -- 官人
    uisprite:newSprite("Guard.png", display.right - 90, display.cy - 60, true)

    -- 灰姑娘
    self.cinderella = uianimationex:createAnimationWithArmature("huiguniang_1", CCPoint(display.cx - 40, display.cy - 235), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.cinderella, function()
        uianimationex:playAnimationWithDelay(self, self.cinderella, "huiguniang_1")
        audio.playMusic(string.format(SoundPath, "Cinderella_2.MP3"), false)
        self.cinderella.clicked = true
    end)

    -- 王子
    self.prince = uianimationex:createAnimationWithArmature("wangzi_1", CCPoint(display.cx - 230, display.cy - 230), self.layer)
    uianimationex:roleAnimationAddTouchEvent(self.prince, function()
        uianimationex:playAnimationWithDelay(self, self.prince, "wangzi_2")
        audio.playMusic(string.format(SoundPath, "Prince_2.MP3"), false)
        self.prince.clicked = true
    end)

    -- 星光
    self.stairs = uianimationex:createAnimationWithArmature("xingguang", CCPoint(display.cx - 400, display.cy - 300), self.layer)
    self.stairs:setScale(0)

    -- 老鼠甲
    self.mouse_1 = uianimationex:createAnimationWithArmature("laoshu_1", CCPoint(display.right + 20, display.cy - 300), self.layer)

    -- 老鼠乙
    self.mouse_2 = uianimationex:createAnimationWithArmature("laoshu_2", CCPoint(display.left - 160, display.cy - 250), self.layer)

    -- 老鼠丙
    self.mouse_3 = uianimationex:createAnimationWithArmature("laoshu_3", CCPoint(display.left - 140, display.cy - 290), self.layer)

    -- 灯光效果
    self.light = uisprite:newSprite("Light.png")
    self.light:setScale(0)

    -- 门帘
    uisprite:newSprite("Curtain_2.png", display.left + 65, display.cy + 100)
    uisprite:newSprite("Curtain_2.png", display.right - 65, display.cy + 100):setFlipX(true)

    uisprite:newSprite("Curtain_1.png", display.cx, display.top - 45)

    self:addChild(self.layer)

    -- UI Menu Buttons
    publicmenu:addUI({
        parent = self,
        listener_right  = function(index)
                                if index == 1 then
                                    -- 小鸟飞来
                                    self:allBirdsEnterScreen()
                                elseif index == 2 then
                                    -- 老鼠跑来
                                    self:allMouseEnterScreen()
                                elseif index == 3 then
                                    -- 王子与灰姑娘跳舞
                                    self:princeAndCinderellaDance()
                                else
                                    -- do nothing
                                end
                            end,
        listener_wrong  = function()
                                uianimationex:playAnimationWithDelay(self, self.cinderella, "dacuo")
                                -- audio.playMusic(string.format(SoundPath, "Wrong.MP3"), false)
                            end
        })

    self.updateable = true
    self.schedule_selector = function(dt)
        self:onEnterFrame(dt)
    end
    self:schedule(self.schedule_selector, 3)

    self:performWithDelay(function()
        uianimationex:playAnimationWithDelay(self, self.prince, "wangzi_1")
        audio.playMusic(string.format(SoundPath, "Prince_1.MP3"), false)

        self:performWithDelay(function()
            uianimationex:playAnimationWithDelay(self, self.cinderella, "huiguniang_1")
            audio.playMusic(string.format(SoundPath, "Cinderella_1.MP3"), false)
        end, 8)
    end, 3)
end

function ch4Scene3:onEnterFrame(dt)
    if self.prince.clicked ~= true then
        -- 提示点击仙女
        return
    end

    if self.cinderella.clicked ~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.cinderella.clicked == true and self.prince.clicked == true and self.updateable == true then
        publicmenu:displayQuestionButton(CCPoint(display.cx + 100, display.bottom + 100))
        self.updateable = false
        return
    end
end

function ch4Scene3:onEnter()
	print "注册回调事件"
    publicmenu:addEventListener("onRewindButtonClicked", function(event) self:onRewindButtonClicked(event) end)
    publicmenu:addEventListener("onQuestionButtonClicked", function(event) self:onQuestionButtonClicked(event) end)

    -- 幕布
    publicmenu:showScreenCurtain(self)
end

function ch4Scene3:allBirdsEnterScreen()
    uianimationex:playAnimationWithDelay(self, self.whitebird, "jinchang_1")    -- 小白鸟
    uianimationex:playAnimationWithDelay(self, self.bluebird, "jinchang_2")     -- 小兰鸟
    uianimationex:playAnimationWithDelay(self, self.yellowbird, "jin_3")        -- 小黄鸟

    self:performWithDelay(function()
        uianimationex:playAnimaForever({
                scene   = self,
                obj     = self.bluebird,
                name    = "fei_2",
                duration= 35.0/24,
            })

        uianimationex:playAnimaForever({
                scene   = self,
                obj     = self.whitebird,
                name    = "fei_2",
                duration= 39.0/24,
            })

        uianimationex:playAnimaForever({
                scene   = self,
                obj     = self.yellowbird,
                name    = "fei_3",
                duration= 36.0/24,
            })
    end, 1)
end

function ch4Scene3:allMouseEnterScreen()
    uianimationex:playAnimationWithDelay(self, self.mouse_1, "dongzuo2")
    uianimationex:playAnimationWithDelay(self, self.mouse_2, "dongzuo2")
    uianimationex:playAnimationWithDelay(self, self.mouse_3, "dongzuo2")
end

function ch4Scene3:princeAndCinderellaDance()
    -- 显示灯光
    self.light:setScale(1)

    -- 星光动画循环播放
    self.stairs:setScale(1)
    uianimationex:playAnimaForever({
                scene   = self,
                obj     = self.stairs,
                name    = "xingguang",
                duration= 32.0/24,
            })

    -- 老鼠们欢呼
    uianimationex:playAnimaForever({
                scene   = self,
                obj     = self.mouse_1,
                name    = "dongzuo3",
                duration= 33.0/24,
            })

    uianimationex:playAnimaForever({
                scene   = self,
                obj     = self.mouse_2,
                name    = "dongzuo3",
                duration= 30.0/24,
            })

    uianimationex:playAnimaForever({
                scene   = self,
                obj     = self.mouse_3,
                name    = "dongzuo3",
                duration= 29.0/24,
            })
end

function ch4Scene3:onQuestionButtonClicked(event)
    print "禁用角色触摸事件"
    self.prince:setTouchEnabled(false)
    self.cinderella:setTouchEnabled(false)
end

function ch4Scene3:onRewindButtonClicked(event)
    print "Rewind Button Clicked."
end

return ch4Scene3
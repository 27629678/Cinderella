-- ch1Scene2.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-09

local objecteffect = import("..common.NEObjectActionEffect")
local publicmenu = import("..views.PublicUIMenu")
local uianimationex = import("..ui.UIAnimationEx")
local uispriteex = import("..ui.UISpriteEx")

local ch1Scene2 = class("ch1Scene2", function()
    return display.newScene("ch1Scene2")
end)

function ch1Scene2:ctor()
    local ch_id       = 1
    local ch_index    = 2
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
    uisprite:newSprite("Background.jpg"):setScale(display.width/1024)

    -- 蜡烛
    self.candle = uisprite:newSpriteWithPendulumEffect("Candle.png", display.cx + 440, display.cy + 30, nil, CCPoint(0.5, 0))

    -- 扫帚
    self.broom = uisprite:newSprite("Broom.png", display.cx, display.cy - 20, true)
    
    -- 自定义动画图层
    self.animlayer = display.newLayer():addTo(self)

    -- 加载动画
    -- 壁炉
    self.fireplace = uianimationex:createAnimationWithArmature("guolu", CCPoint(0, 236), self.animlayer)

    -- 水桶
    self.bucket = uianimationex:createAnimationWithArmature("shuitong", CCPoint(10, 100), self.animlayer)

    -- 蜘蛛
    self.spider = uianimationex:createAnimationWithArmature("zhizhu", CCPoint(200, 600), self.animlayer)

    -- 后妈
    self.stepmother = uianimationex:createAnimationWithArmature("houma_touxiao", CCPoint(700, 150), self.animlayer)
    uianimationex:roleAnimationAddTouchEvent(self.stepmother, function()
        uianimationex:playAnimationWithDelay(self, self.stepmother, "touxiao")
        audio.playMusic(string.format(SoundPath, "StepMother_2.MP3"), false)
        self.stepmother.clicked = true
    end)

    -- 灰姑娘
    self.cinderella = uianimationex:createAnimationWithArmature("huiguniang_1", CCPoint(160, 80), self.animlayer)
    uianimationex:roleAnimationAddTouchEvent(self.cinderella, function()
        uianimationex:playAnimationWithDelay(self, self.cinderella, "tanqi")
        audio.playMusic(string.format(SoundPath, "Cinderella_2.MP3"), false)
        self.cinderella.clicked = true
    end)

    -- 豌豆    
    self.peas = uianimationex:createAnimationWithArmature("tiao wadou", CCPoint(400, 100), self.animlayer)

    -- UI Menu Buttons
    publicmenu:addUI({
        parent = self,
        listener_right  = function(index)
                                if index == 1 then
                                    uianimationex:playAnim(self.cinderella, "xiao")
                                    audio.playMusic(string.format(SoundPath, "Cinderella_3.MP3"), false)
                                    uianimationex:playAnim(self.peas, "dongzuo1")
                                elseif index == 2 then
                                    uianimationex:playAnim(self.cinderella, "xiao")
                                    audio.playMusic(string.format(SoundPath, "Cinderella_3.MP3"), false)
                                    uianimationex:playAnim(self.peas, "dongzuo2")
                                elseif index == 3 then
                                    uianimationex:playAnim(self.cinderella, "xiao")
                                    audio.playMusic(string.format(SoundPath, "Cinderella_3.MP3"), false)
                                    uianimationex:playAnim(self.peas, "dongzuo3")
                                else
                                    -- do nothing
                                end
                            end,
        listener_wrong  = function()
                                uianimationex:playAnim(self.cinderella, "kuqi")
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
        audio.playMusic(string.format(SoundPath, "Cinderella_1.MP3"), false)
        self:performWithDelay(function()
            audio.playMusic(string.format(SoundPath, "StepMother_1.MP3"), false)
        end, 3.5)
    end, 46)
end

function ch1Scene2:onEnterFrame(dt)
    if self.stepmother.clicked ~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.cinderella.clicked~= true then
        -- 提示点击灰姑娘
        return
    end

    if self.stepmother.clicked == true and self.cinderella.clicked == true and self.updateable == true then
        publicmenu:displayQuestionButton(CCPoint(display.cx + 100, display.bottom + 100))
        self.updateable = false
        return
    end
end

function ch1Scene2:onEnter()
    print "注册回调事件"
    publicmenu:addEventListener("onRewindButtonClicked", function(event) self:onRewindButtonClicked(event) end)
    publicmenu:addEventListener("onQuestionButtonClicked", function(event) self:onQuestionButtonClicked(event) end)

    -- 幕布
    publicmenu:showScreenCurtain(self)

    uianimationex:playAnimationWithDelay(self, self.spider, "zhizhu", 2)
    uianimationex:playAnimationWithDelay(self, self.bucket, "shuadi", 4)
    uianimationex:playAnimationWithDelay(self, self.fireplace, "guolu", 8)
end

function ch1Scene2:onQuestionButtonClicked(event)
    print "禁用角色触摸事件"
    self.stepmother:setTouchEnabled(false)
    self.cinderella:setTouchEnabled(false)
end

function ch1Scene2:onRewindButtonClicked(event)
    print "Rewind Button Clicked."
end

return ch1Scene2
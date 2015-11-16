-- ChapterEndScene.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-03-22

local gotoplayground = require("app.views.GoToPlayground")
local commonComponent = import("..views.common");
package.path = package.path .. ";?.lua"

local ChapterEndScene = class("ChapterEndScene", function()
    return display.newScene("ChapterEndScene")
end)

function ChapterEndScene:ctor()
    self.currentChapterID       = app.currentChapterID
    self.currentChapterIndex    = 4

    local m_bIsStudy    = true

    -- 继续、结束按钮的位置
    positiontable = {
        {x = display.cx - 172,  y = 200,                duration = 24},
        {x = display.cx - 212,  y = 240,                duration = 16},
        {x = display.cx,        y = display.cy + 220,   duration = 16},
        {x = display.cx - 212,  y = 260,                duration = 13},
    }

    -- 资源路径
    AssetsPath  = string.format("ChapterMaterial/Ch_%d_%d/", self.currentChapterID, self.currentChapterIndex) .. "%s"
    SoundPath   = string.format(AssetsPath, "Sound/Story.MP3")

    -- 自定义图层
    self.layer = display.newLayer()

    -- 背景图片
    display.newSprite(string.format(AssetsPath, "Background.jpg"), display.cx, display.cy):addTo(self.layer)

    -- 返回按钮
    local button_return = ui.newImageMenuItem({
            image = "ChapterMaterial/Universal/Button_Return.png",
            x = display.left + 44,
            y = display.top - 37,
            listener = function(tag)
                if m_bIsStudy then
                    gotoplayground:new():addTo(self.layer)
                    return
                end

                app:playStartScene()
            end
        })

    -- 复读按钮
    local button_rewind = ui.newImageMenuItem({
            image = "ChapterMaterial/Universal/Button_Rewind.png",
            x = display.right - 44,
            y = display.top - 37,
            listener = function(tag)
                self:rewindStoryAudio()
            end
        })

    -- 继续按钮
    self.button_continue = ui.newImageMenuItem({
            image = "ChapterMaterial/Universal/Button_Continue.png",
            x = positiontable[self.currentChapterID]["x"],
            y = positiontable[self.currentChapterID]["y"],
            listener = function(tag)
                if m_bIsStudy then
                    gotoplayground:new():addTo(self.layer)
                    return
                end

                app:playStartScene()
            end
        })
    self.button_continue:setScale(0)

    -- 结束按钮
    self.button_over = ui.newImageMenuItem({
            image = "ChapterMaterial/Universal/Button_Over.png",
            x = positiontable[self.currentChapterID]["x"],
            y = positiontable[self.currentChapterID]["y"],
            listener = function(tag)
                app:playStartScene()
            end
        })
    self.button_over:setScale(0)

    -- 是否显示结束按钮
    local buttontable = self.currentChapterID == 4 and {button_return, button_rewind, self.button_over} or {button_return, button_rewind, self.button_continue}

    -- UI图层
    self.menu = ui.newMenu(buttontable)
    self.menu:addTo(self.layer)

    -- 自定义图层添加到根视图
    self:addChild(self.layer)
end

-- 复读按钮事件
function ChapterEndScene:rewindStoryAudio()
    if audio.isMusicPlaying() then return end
    self.BackgroundMusic = audio.playMusic(SoundPath, false);
end

function ChapterEndScene:onEnter()
    -- 延时1秒播放故事
    self:performWithDelay(function()
        self.BackgroundMusic = audio.playMusic(SoundPath, false);
    end, 1)

    -- 故事播放完毕后显示继续/结束按钮
    self:performWithDelay(function()
        if self.currentChapterID == 4 then
            self.button_over:setScale(1)
        else
            self.button_continue:setScale(1)
        end
    end, positiontable[self.currentChapterID]["duration"])
end

function ChapterEndScene:onExit()
    -- 退出场景时，停止播放故事语音并释放内存
    audio.stopMusic(true)
end

return ChapterEndScene
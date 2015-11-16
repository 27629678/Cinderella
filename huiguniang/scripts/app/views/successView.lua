local objecteffect = import("..common.NEObjectActionEffect")
local uianimationex = import("..ui.UIAnimationEx")

local SuccessView = {};

function SuccessView:showSuccess(parent, cb)
    local currentChapterID       = app.currentChapterID
    local currentChapterIndex    = app.currentChapterIndex

    local Anim_Png    = string.format("ChapterMaterial/Ch_%d_%d/Animation/SuccessAnimData.png", currentChapterID, currentChapterIndex)
    local Anim_Plist  = string.format("ChapterMaterial/Ch_%d_%d/Animation/SuccessAnimData.plist", currentChapterID, currentChapterIndex)
    local Anim_Xml    = string.format("ChapterMaterial/Ch_%d_%d/Animation/SuccessAnimData.xml", currentChapterID, currentChapterIndex)

    -- 加载动画数据文件
    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(Anim_Png, Anim_Plist, Anim_Xml)

    Anim_Png    = "ChapterMaterial/Universal/Animation/YellowLight/AnimData.png"
    Anim_Plist  = "ChapterMaterial/Universal/Animation/YellowLight/AnimData.plist"
    Anim_Xml    = "ChapterMaterial/Universal/Animation/YellowLight/AnimData.xml"

    CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(Anim_Png, Anim_Plist, Anim_Xml)

    self.layer = display.newLayer():addTo(parent)

    -- 背影图片
    self.bg = display.newScale9Sprite("ChapterMaterial/Universal/Shade_50.png", display.cx, display.cy, CCSize(display.width, display.height)):addTo(self.layer)
    self.bg:setTouchEnabled(true)
    self.bg:addTouchEventListener(function (event, x, y)
        return true
    end)

    -- 旋转的黄光
    local m_light = uianimationex:createAnimationWithArmature("guang", CCPoint(display.cx, display.cy), self.layer)
    uianimationex:playAnim(m_light, "guang")
    objecteffect:rotateForever(m_light, 20)

    -- 小章节结束动画
    local m_animname = string.format("c%d%d", currentChapterID, currentChapterIndex)
    local m_anim = uianimationex:createAnimationWithArmature(m_animname, CCPoint(display.cx, display.cy + 100), self.layer)
    uianimationex:playAnim(m_anim, m_animname)

    local function addContinueButton()
        ui.newMenu({continuebutton}):addTo(parent)
    end    
    
    parent:performWithDelay(function ()
        local continuebutton = ui.newImageMenuItem({
            image = "ChapterMaterial/Universal/Button_Continue.png",
            x = display.cx,
            y = display.bottom + 100,
            listener = function(tag)
                if cb ~= nil then cb() end
                app:playNextChapterIndex()
            end
        })
        ui.newMenu({continuebutton}):addTo(self.layer)
    end,2)
end

return SuccessView
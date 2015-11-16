--
-- Author: sddz_yuxiaohua@corp.netease.com
-- Date: 2014-05-04 10:51:01
--
local uibutton = import("..ui.UIButton")

local ControlMenuView = class("ControlMenuView", function()
	local node = display.newLayer()
	require("framework.api.EventProtocol").extend(node)
	return node
end)

function ControlMenuView:ctor()
	self.view = display.newLayer()
    self:addChild(self.view)

	self.leftButton = uibutton:newSpriteButton({
			image 	= "PublicUIMenu/Button_Left.png",
			setAlpha 	= true,
			x 			= display.left - 30,
			y 			= display.bottom + 60,
			listener 	= function()
							app:playLastChapterIndex()
						  end
		})
	if app.currentChapterIndex > 1 then
		self.leftButton:addTo(self.view)
	end

	self.rightButton = uibutton:newSpriteButton({
			image 	= "PublicUIMenu/Button_Right.png",
			setAlpha 	= true,
			x 			= display.right + 30,
			y 			= display.bottom + 60,
			listener 	= function()
							if app.currentChapterIndex == 4 then

							else
								app:playNextChapterIndex()
							end
						  end
		})
	if app.currentChapterIndex < 4 or true then
		self.rightButton:addTo(self.view)
	end

	self:beganAnimation()
end

function ControlMenuView:beganAnimation()
	local m_bHasRead    = false
    local m_bIsStudy    = false
    local m_duration 	= 0.3

	if m_bHasRead or m_bIsStudy then return end

	transition.moveTo(self.leftButton, {x = self.leftButton:getPositionX() + 70, time = m_duration})
	transition.moveTo(self.rightButton, {x = self.rightButton:getPositionX() - 70, time = m_duration})
end


return ControlMenuView
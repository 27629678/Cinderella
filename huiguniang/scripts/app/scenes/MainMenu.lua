local commonComponent = import("..views.common");
local chapterselectlayer = import("..views.ChapterSelectLayer");
local controlMenuView = require("app.views.ControlMenuView")
local gotoplayground = require("app.views.GoToPlayground")

local MainMenu = class("MainMenu", function ()
	return display.newScene("MainMenu")
end)

function MainMenu:ctor()
	local m_scaleY = display.height/768
	local m_scaleX = display.width/1024
	display.addSpriteFramesWithFile(MAIN_MENU_TEXTURE_PLIST,MAIN_MENU_TEXTURE_PNG);

	self.layer = display.newLayer()

	-- background
	self.background = display.newSprite("MainMenu/bg_ch_01.jpg", display.cx, display.cy):addTo(self.layer)
	self.background:setScaleX(m_scaleX)

	display.newSprite("#StoryTitle.png", display.cx, display.cy + 250):addTo(self.layer)

 	-- 信封
	commonComponent:showXinFeng(self.layer);

	-- UI Buttons
	local morebutton = ui.newImageMenuItem({
		image = "#Button_More.png",
		listener = function(tag)
			print "More Button Clicked."
		end,
		x = display.left + 60,
		y = display.top - 47
		})

	local teambutton = ui.newImageMenuItem({
		image = "#Button_Team.png",
		listener = function(tag)
			app:enterAboutScene()
		end,
		x = display.left +160,
		y = display.top - 47
		})

	local configbutton = ui.newImageMenuItem({
		image = "#Button_Config.png",
		listener = function(tag)
			app:enterCourseConfigScene()
		end,
		x = display.right - 60,
		y = display.top - 47
		})

	local upgradebutton = ui.newImageMenuItem({
		image = "#Button_Upgrade.png",
		listener = function(tag)
			print "Upgrade Button Clicked."
			app:enterStoreScene()
		end,
		x = display.right - 160,
		y = display.top - 47
		})

	self.menu = ui.newMenu({morebutton, teambutton, upgradebutton, configbutton}):addTo(self.layer)

	self.layer:setTouchEnabled(true)
	self:addChild(self.layer)
end

function MainMenu:setBackgroundWithChapterID(index)
	local filename = string.format("MainMenu/bg_ch_%02d.jpg", index);

	local texture = CCTextureCache:sharedTextureCache():addImage(filename);
	if texture ~= nil then
		self.background:setTexture(texture);
	end
end

function MainMenu:onEnter()
	-- 添加章节选择窗口
   chapterselectlayer:create(self)
end

return MainMenu
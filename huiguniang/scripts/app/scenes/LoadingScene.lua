local mainmenu = import(".MainMenu")

local LoadingScene = class("LoadingScene", function ()
	return display.newScene("LoadingScene")
end)

function LoadingScene:ctor()
	self.layer = display.newLayer()

	local background = display.newSprite("logo.png", display.cx, display.cy):addTo(self.layer)
	background:setScale(display.width/1024)

	self:addChild(self.layer)

	self:InitData()
end

function LoadingScene:InitData()
	self:performWithDelay(function ()
		display.replaceScene(mainmenu.new(), "fade", 0.1)
	end, 0.4)
end

return LoadingScene
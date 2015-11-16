--
-- Author: sddz_yuxiaohua@corp.netease.com
-- Date: 2014-05-04 14:19:37
--

local GoToPlayground = class("GoToPlayground", function()
	return display.newLayer()
end)

function GoToPlayground:ctor()
	local title_font 		= "DFYuanW7-GB"
	local title_text 		= "提示"
	local title_fontsize 	= 32
	local title_fontcolor  	= ccc3(45, 15, 10)

	local content_font 		= "DFYuanW7-GB"
	local content_text 		= "今天的故事结束啦，我们去游乐场玩游戏吧"
	local content_fontsize 	= 24
	local content_fontcolor = ccc3(71, 32, 25)

	-- 背景图片
	local bgitem = ui.newImageMenuItem({
			image = "PublicUIMenu/Shade_50.png",
			x = display.cx,
			y = display.cy,
		})

	bgitem:setScaleX(display.width/50)
	bgitem:setScaleY(display.height/50)

	ui.newMenu({bgitem}):addTo(self)

	-- 面板
	local panel = display.newScale9Sprite("PublicUIMenu/Panel_74.png", display.cx+5, display.cy, CCSizeMake(520, 356)):addTo(self)
	panel:setInsetBottom(40)
	panel:setInsetTop(40)
	panel:setInsetLeft(32)
	panel:setInsetRight(32)

	local bgrect 	= panel:getContentSize();

	-- 标题
	local title = ui.newTTFLabel({
			text  = title_text,
		    font  = title_font,
		    size  = title_fontsize,
		    color = title_fontcolor,
		    align = ui.TEXT_ALIGN_CENTER,
		    x	  = bgrect.width/2,
		    y	  = bgrect.height/2 + 120,	
		}):addTo(panel)

	-- 提示文字
	local content = ui.newTTFLabel({
			text  = content_text,
		    font  = content_font,
		    size  = content_fontsize,
		    color = content_fontcolor,
		    align = ui.TEXT_ALIGN_CENTER,
		    dimensions = CCSize(480, 200),
		    x	  = bgrect.width/2,
		    y	  = bgrect.height/2 + 20,
		}):addTo(panel)

	-- 去游乐场按钮
	local gotobutton = ui.newImageMenuItem({
			image 		= "PublicUIMenu/Button_Playground.png",
			x 			= bgrect.width/2,
			y 			= bgrect.height/2 - 110,
			listener 	= function(tag)
							app:playStartScene()
							app:transferMessageToElearnApp()
						  end
		})
	ui.newMenu({gotobutton}):addTo(panel)
end

return GoToPlayground
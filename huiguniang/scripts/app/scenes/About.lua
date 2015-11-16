local About = class("About", function ()
	return display.newScene("About")
end)

function About:ctor()
	display.newSprite("About/Background.jpg", display.cx, display.cy):addTo(self)

	-- left curtain
	display.newSprite("About/Curtain.png", display.left + 139, display.top - 281):addTo(self)

	-- right curtain
	local rightcurtain = display.newSprite("About/Curtain.png", display.right - 139, display.top - 281)
	rightcurtain:setFlipX(true)
	rightcurtain:addTo(self)

	local function onButtonClicked(tag)
		app:enterMainMenuScene()
	end

	local returnbutton = ui.newImageMenuItem({
			image = "About/Button_Return.png",
		    imageSelected = "About/Button_Return.png",
		    listener = onButtonClicked,
		    x = display.left + 51,
		    y = display.top - 41
		})
	local menu = ui.newMenu({returnbutton})
	self:addChild(menu)

	local teammembers = display.newSprite("About/TeamMembers.png")

	local clipview = CCScrollView:create(CCSizeMake(440,570), teammembers)
	clipview:setPosition(display.cx - 220, display.cy - 350)
    clipview:setBounceable(true)
    clipview:setDirection(kCCScrollViewDirectionVertical)
    clipview:setTouchEnabled(false)
    self:addChild(clipview)

    teammembers:setPosition(0, -500)

    transition.execute(teammembers, CCMoveTo:create(4, CCPoint(0, 10)), {
	    delay = 1,
	    onComplete = function()
	        clipview:setTouchEnabled(true)
	    end
	})
end

return About
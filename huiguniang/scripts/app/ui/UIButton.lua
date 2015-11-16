local UIButton = {}

function UIButton:newSpriteButton(buttontable)
	if buttontable == nil then
		print ("按钮信息不完整!")
		return nil
	end

	local imageName = buttontable["image"]		or nil
	local listener 	= buttontable["listener"] 	or nil
	local setAlpha 	= buttontable["setAlpha"]	or false
	local alpha 	= buttontable["alpha"]		or 255 * 0.8
	local setScale  = buttontable["setScale"]   or false
	local scale 	= buttontable["scale"]		or 0.96
    local anchor    = buttontable["anchor"]     or CCPoint(0.5, 0.5)
	local x 		= buttontable["x"] 			or display.cx
	local y  		= buttontable["y"] 			or display.cy

    local m_point = CCPoint(x, y)
    
    local sprite = display.newSprite(imageName, m_point.x, m_point.y)

    if setAlpha == nil then setAlpha = true end

    sprite:setTouchEnabled(true)
    sprite:addTouchEventListener(function(event, x, y)
        if event == "began" then
            if setAlpha then sprite:setOpacity(alpha) end
            if setScale then sprite:setScale(scale) end
            return true
        end

        local touchInSprite = sprite:getCascadeBoundingBox():containsPoint(CCPoint(x, y))
        if event == "moved" then
            if touchInSprite then
                if setAlpha then sprite:setOpacity(alpha) end
                if setScale then sprite:setScale(scale) end
            else
                sprite:setOpacity(255)
                sprite:setScale(1)
            end
        elseif event == "ended" then
            if touchInSprite then listener() end
            sprite:setOpacity(255)
            sprite:setScale(1)
        else
            sprite:setOpacity(255)
            sprite:setScale(1)
        end
    end)

    return sprite
end


return UIButton
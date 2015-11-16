local objecteffect = import("..common.NEObjectActionEffect")

local UISpriteEx = {}

function UISpriteEx:Init(parent, id, index, assetspath)
	self.parent		= parent
	self.id 		= id or app.currentChapterID
	self.index 		= index or app.currentChapterIndex
	self.assetspath = (assetspath == nil and string.format("ChapterMaterial/Ch_%d_%d/", id, index) or (assetspath .. "/")) .. "%s"
	return self
end

function UISpriteEx:create(spritename)
	local sprite = display.newSprite(string.format(self.assetspath, spritename))
	sprite:addTo(self.parent)
	return sprite
end

function UISpriteEx:addSpriteWithLayer(spritename, pos_x, pos_y, layer, touchable)
	pos_x = pos_x or display.cx
	pos_y = pos_y or display.cy

	local sprite = display.newSprite(string.format(self.assetspath, spritename)):addTo(layer)
	
	if touchable == true then
		local m_height = sprite:getContentSize().height
		sprite:setPosition(pos_x, pos_y - m_height/2)
		objecteffect:Shake(sprite, nil)
	else
		sprite:setPosition(pos_x, pos_y)
	end

	return sprite
end

function UISpriteEx:newSprite(spritename, pos_x, pos_y, touchable)
	pos_x = pos_x or display.cx
	pos_y = pos_y or display.cy

	local sprite = self:create(spritename)
	
	if touchable == true then
		local m_height = sprite:getContentSize().height
		sprite:setPosition(pos_x, pos_y - m_height/2)
		objecteffect:Shake(sprite, nil)
	else
		sprite:setPosition(pos_x, pos_y)
	end

	return sprite
end

function UISpriteEx:newSpriteWithPendulumEffect(spritename, pos_x, pos_y, layer, anchorpoint)
	if layer == nil then
		layer = self.parent
	end

	if anchorpoint == nil then
		anchorpoint = CCPoint(0.5, 1)
	end

	pos_x = pos_x or display.cx
	pos_y = pos_y or display.cy

	local sprite = display.newSprite(string.format(self.assetspath, spritename)):addTo(layer)
	
	if touchable ~= true then
		local m_height = sprite:getContentSize().height
		sprite:setPosition(pos_x, pos_y + m_height/2)

		objecteffect:RotateWithParentandAngle(sprite, 30, anchorpoint)
	else
		sprite:setPosition(pos_x, pos_y)
	end

	return sprite
end

return UISpriteEx
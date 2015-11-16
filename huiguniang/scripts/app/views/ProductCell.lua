local ScrollViewCell = import("..ui.ScrollViewCell")
local ProductCell = class("ProductCell", ScrollViewCell)

function ProductCell:ctor(size, sprite, rect)
	local start_pos_x 	= sprite:getContentSize().width/2 + rect.origin.x;
	local start_pos_y 	= rect.origin.y + sprite:getContentSize().height/2;

	sprite:setPosition(start_pos_x, start_pos_y)
	sprite:addTo(self)
end


return ProductCell
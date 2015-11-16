local productcell = import(".ProductCell")
local pagecontrol = import("..ui.PageControl")

local ProductList = class("ProductList", pagecontrol)

function ProductList:ctor(rect)
	ProductList.super.ctor(self, rect, pagecontrol.DIRECTION_HORIZONTAL)
	local database = {
		{
			id 		= 1,
			title 	= "剧场式的故事场景，画面精美",
			image 	= "Store/Cinderella/S_1.jpg",
		},
		{
			id 		= 2,
			title 	= "多达12个练习游戏，让孩子学得扎实",
			image 	= "Store/Cinderella/S_2.jpg",
		},
		{
			id 		= 3,
			title 	= "多角色配音，可与画面元素互动",
			image 	= "Store/Cinderella/S_3.jpg",
		},
		{
			id 		= 4,
			title 	= "汉字学习将由40个汉字升级到100个汉字",
			image 	= "Store/Cinderella/S_4.jpg",
		},
	}

	-- add cells
	local countsPerRow = 1
	local itemCounts = #database
	local numPages = math.ceil(#database/countsPerRow)
	self.pageCount = numPages

	for pageIndex = 1, numPages do

		cols = itemCounts - (pageIndex - 1) * countsPerRow

		if cols > countsPerRow then
			cols = countsPerRow
		end

		local begin = (pageIndex - 1) * countsPerRow + 1
		local length = begin + cols - 1

		local m_cell = productcell.new(rect.size, display.newSprite(database[pageIndex]["image"]), rect)
		self:addCell(m_cell)
	end
end

function ProductList:scrollToCell(index, animated, time)
    ProductList.super.scrollToCell(self, index, animated, time)

    local tag = "null";

    if index == 1 then
    	tag = "left"
    elseif index == self.pageCount then
    	tag = "right"
    else
    	tag = "-1"
    end

    self:dispatchEvent(
		{
			name 	= "ProductSelectViewDidScroll",
			direct 	= tag,
			index = index
		}
	)
end

return ProductList
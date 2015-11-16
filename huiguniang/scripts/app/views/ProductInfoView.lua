local productlist = import("..views.ProductList")

local ProductInfoView = {}

function ProductInfoView:init(parent, productidentifier)
	self.layer = display.newLayer()

	self.detailtable = {"剧场式的故事场景，画面精美",
						"多达12个练习游戏，让孩子学得扎实",
						"多角色配音，可与画面元素互动",
						"汉字学习将由40个汉字升级到100个汉字"	
					}
	-- 背景图片
	local m_background = display.newSprite("Store/WhiteBackground.png", display.cx, display.cy + 54):addTo(parent)

	self.detaillabel = ui.newTTFLabel({
		text = "剧场式的故事场景，画面精美",
		font = "DFYuanW7-GB",
		size = 32,
		align= ui.TEXT_ALIGN_CENTER,
		color= ccc3(58,53,45),
		x	 = m_background:getContentSize().width/2,
		y    = 60
		}):addTo(m_background)

	-- scroll view
	local rect = CCRect(display.cx - 390, display.cy - 100, 768, 376)
	self.list = productlist.new(rect)
	self.list:setTouchEnabled(true)
	self.list:addEventListener("ProductSelectViewDidScroll", handler(self, self.ChapterSelectViewDidScroll));
	self.layer:addChild(self.list)

	self.leftbutton = display.newSprite("Store/Tag_Left.png", display.left + (display.width - 800)/4, display.cy):addTo(self.layer)
	self.leftbutton:setVisible(false)
	self.rightbutton = display.newSprite("Store/Tag_Right.png", display.right - (display.width - 800)/4, display.cy):addTo(self.layer)

	parent:addChild(self.layer)
end

function ProductInfoView:ChapterSelectViewDidScroll(event)
	if event.direct == "left" then
		self.leftbutton:setVisible(false)
		self.rightbutton:setVisible(true)
	elseif event.direct == "right" then
		self.leftbutton:setVisible(true)
		self.rightbutton:setVisible(false)
	else
		self.leftbutton:setVisible(true)
		self.rightbutton:setVisible(true)
	end

	self.detaillabel:setString(self.detailtable[event.index])
end



return ProductInfoView
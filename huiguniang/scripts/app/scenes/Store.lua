-- Store.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-04-14
local productinfoview = import("..views.ProductInfoView")
local uibutton = import("..ui.UIButton")
local uispriteex = import("..ui.UISpriteEx")
local storemanager = require("app.common.NEIAPStoreManager")

local Store = class("Store", function()
	return display.newScene("Store")
end)

function Store:ctor()
	self.busy = false
	self.productID = "GH12S"

	if device.platform == "ios" then
		self.storeHandles = {}
		if app.store ~= nil then
			self.storeHandles["LOAD_PRODUCTS_FINISHED"] 	= app.store:addEventListener("LOAD_PRODUCTS_FINISHED", handler(self, self.onLoadProductsFinished))
			self.storeHandles["LOAD_PRODUCTS_FAILED"]		= app.store:addEventListener("LOAD_PRODUCTS_FAILED", handler(self, self.onLoadProductsFailed))
	    	self.storeHandles["TRANSACTION_PURCHASED"] 		= app.store:addEventListener("TRANSACTION_PURCHASED", handler(self, self.onTransactionPurchased))
	    	self.storeHandles["TRANSACTION_FAILED"] 		= app.store:addEventListener("TRANSACTION_FAILED", handler(self, self.onTransactionFailed))
	    	self.storeHandles["TRANSACTION_UNKNOWN_ERROR"] 	= app.store:addEventListener("TRANSACTION_UNKNOWN_ERROR", handler(self, self.onTransactionFailed))
	    	self.storeHandles["TRANSACTION_RESTORED"]		= app.store:addEventListener("TRANSACTION_RESTORED", handler(self, self.onTransactionRestored))
		end
	end

	self.productdetails = ""
	self.productprice	= ""
	-- Init Store UI

    local AssetsPath  = "Store"

    -- 自定义图层
    self.layer = display.newLayer():addTo(self)

    local uisprite = uispriteex:Init(self.layer, nil, nil, AssetsPath)

    -- 背景图片
    uisprite:newSprite("Background.jpg")

    -- 返回按钮
	self.returnbutton = uibutton:newSpriteButton({
		image       = "Store/Button_Return.png",
        setAlpha    = true,
        x           = display.left + 44,
        y           = display.top - 41,
        listener    = function(tag)
                        app:playStartScene()
                    end		
	}):addTo(self.layer)

	-- 购买按钮
	self.buybutton = uibutton:newSpriteButton({
		image       = "Store/Button_Buy.png",
        setAlpha    = true,
        x           = display.cx + 290,
        y           = display.bottom + 74,
        listener    = function(tag)
        				if GameData.BuyState == "TRUE" then return end
                        self:onPurchaseClicked(self.productID)
                    end		
	}):addTo(self.layer)

	self.productpricelabel = ui.newTTFLabelWithOutline({
			text 	= self.productprice,
			font 	= "DFYuanW7-GB",
			size 	= 40,
			color	= ccc3(150,70,0),
			outlineColor = ccc3(150,70,0),
			align 	= ui.TEXT_ALIGN_CENTER,
		    x = self.buybutton:getContentSize().width/2 - 5,
		    y = self.buybutton:getContentSize().height/2 + 7,
		}):addTo(self.buybutton)
	
	self.buybutton:setVisible(false)
end

function Store:onEnter()
	print "Enter Store Scene."

	if device.platform == "ios" then
		self:onLoadProductsClicked()
	end

	if device.platform ~= "ios" then
		self:performWithDelay(function()
			self:displayValidProducts("经典的格林童话——《灰姑娘》，讲述了一个善良的小女孩，长期受到继母和姐姐们的欺负，后来在仙女的帮助下，冲破继母和姐姐的阻挠，和王子快乐地生活在一起的故事。", tostring(12))
		end, 1)
	end
end

function Store:displayValidProducts(info, price)
	self.productdetails = info
	self.productpricelabel:setString(string.format("￥%s元", price))
	if GameData.BuyState == "TRUE" then
		self.productpricelabel:setString("已购买")
		self.buybutton:setTouchEnabled(false)
	end

	local m_view_width = 462
	local m_fontsize = 22
	local m_linespacing = m_fontsize + 4
	local charcount = string.len(self.productdetails)/3
	local lines = math.ceil(charcount * m_fontsize / m_view_width)
	local charheight = m_linespacing*lines
	-- 商品描述
	self.descriptionlabel = ui.newTTFLabel({
			text 	= self.productdetails,
			font 	= "DFYuanW7-GB",
			size 	= m_fontsize,
			color	= ccc3(58,53,45),
			align 	= ui.TEXT_ALIGN_LEFT,
		    dimensions = CCSize(m_view_width, 100),
		    x = 0,
		    y = charheight/2
		})

	self.scrollpanel = display.newScale9Sprite("Store/Transparent.png",0,0,CCSize(m_view_width, charheight))
	self.descriptionlabel:addTo(self.scrollpanel)
	self.descriptionlabel:setVisible(false)

	self.clipview = CCScrollView:create(CCSizeMake(m_view_width,m_linespacing*4), self.scrollpanel)
	self.clipview:setPosition(display.cx - 410, display.bottom + 30)
    self.clipview:setBounceable(false)
    self.clipview:setDirection(kCCScrollViewDirectionVertical)
    self.clipview:setTouchEnabled(false)
    self:addChild(self.clipview)

    self.scrollpanel:setPosition(0, m_linespacing*4 - charheight)

	self.descriptionlabel:setVisible(true)
	self.buybutton:setVisible(true)
	self.clipview:setTouchEnabled(true)

	productinfoview:init(self, self.productID)
end

function Store:onLoadProductsClicked()
	if self.busy then return end

    if not app.store:canMakePurchases() then
        device.showAlert("提示", "内购被禁止！", {"确定"})
        return
    end

    self.busy = true
    print("REQUEST LOAD PRODUCTS")
    device.showActivityIndicator()
    app.store:loadProducts({"GH12S"})
end

function Store:onLoadProductsFinished(event)
	dump(event.products, "products")
	device.hideActivityIndicator()
	self.busy = false

	-- 更新UI展示
	if #event.products > 0 then
		local y = display.cy + 60 * (#event.products / 2)
		for _, product in ipairs(event.products) do
	        local text = string.format("Buy \"%s\" with \"%s %s\"", product.localizedTitle, product.price, product.priceLocale)
	        print ("Valid Product Info:", text)

	        self:displayValidProducts(product.localizedDescription, tostring(product.price))
	    end
	else
		self:onLoadProductsFailed(nil)
	end
end

function Store:onLoadProductsFailed(event)
	device.hideActivityIndicator()
	self.busy = false

	local function onButtonClicked(event)
	    if event.buttonIndex == 1 then
	        print "重试"
	        self:onLoadProductsClicked()
	    else
	        print "取消"
	        app:playStartScene()
    end
end
	device.showAlert("提示", "无法连接AppStore", {"重试","取消"}, onButtonClicked)
end

function Store:onPurchaseClicked(productId)
	if self.busy then return end

	self.busy = true
    device.showActivityIndicator()
    app.store:purchaseProduct(productId)
    -- game.store:restoreProducts()
end

function Store:onTransactionPurchased(event)
	print "内购完成"
    self.busy = false
    device.hideActivityIndicator()
    self.productpricelabel:setString("已购买")
end

function Store:onTransactionFailed(event)
	print "内购取消"
    self.busy = false
    device.hideActivityIndicator()
end

function Store:onTransactionRestored(event)
	print "恢复完成"
	self.busy = false
    device.hideActivityIndicator()
    print ("产品ID：", event.transaction.productIdentifier)
    if event.transaction.productIdentifier == "GH12S" then
    	self.productpricelabel:setString("已购买")
    end
end

function Store:onExit()
    for eventName, handle in pairs(self.storeHandles) do
    	print(eventName)
        app.store:removeEventListener(eventName, handle)
    end

    device.hideActivityIndicator()
end

return Store
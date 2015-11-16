local BuyingTipsView = {}

function BuyingTipsView:create(parent, callback)
	-- parent.layer:setTouchEnabled(false)
	callback(false)
	self.callback = callback

	display.addSpriteFramesWithFile(BUYING_TIPS_TEXTURE_PLIST, BUYING_TIPS_TEXTURE_PNG);

	self.layer = display.newLayer();
	self.layer:setTouchEnabled(true);

	-- 配置
	local nativefont 		= "DFYuanW7-GB";

	local title_font 		= "DFYuanW7-GB";
	local title_text 		= "该故事需要购买";
	local title_fontsize 	= 32;
	local title_fontcolor  	= ccc3(45, 15, 10);

	local content_font 		= "DFYuanW7-GB";
	local content_text 		= "1、购买后将获得完整版的故事内容\n2、汉字学习将由40个汉字升级到120个汉字";
	local content_fontsize 	= 24;
	local content_fontcolor = ccc3(71, 32, 25);

	-- BoxCollider
	local shade = display.newScale9Sprite(
		"#shade.png",
		display.cx,
		display.cy,
		CCSize(display.width, display.height)
		);
	shade:setOpacity(150);
	-- shade:setTouchEnabled(true);
	-- shade:addTouchEventListener(function(event, x, y) return true end);
	-- self.layer:addChild(shade);
	local BoxCollider = ui.newImageMenuItem({
			image 			= "#shade.png",
		    listener 		= nil,
		});
	BoxCollider:setNormalImage(shade)
	ui.newMenu({BoxCollider}):addTo(self.layer)

	-- 面板
	local background = display.newScale9Sprite(
		"#Background_9_Scale.png",
		display.cx + 5,
		display.cy,
		CCSize(520, 356)
		);
	background:setInsetBottom(40);
	background:setInsetTop(40);
	background:setInsetLeft(32);
	background:setInsetRight(32);

	self.layer:addChild(background);

	local bgrect 	= background:getContentSize();
	local bgpos_x 	= background:getPositionX();
	local bgpos_y 	= background:getPositionY();

	-- 标题
	local title = ui.newTTFLabel({
			text  = title_text,
		    font  = title_font,
		    size  = title_fontsize,
		    color = title_fontcolor,
		    align = ui.TEXT_ALIGN_CENTER,
		    x	  = bgrect.width/2,
		    y	  = bgrect.height/2 + 120,	
		});
	background:addChild(title);

	-- 内容
	local content = ui.newTTFLabel({
			text  = content_text,
		    font  = content_font,
		    size  = content_fontsize,
		    color = content_fontcolor,
		    align = ui.TEXT_ALIGN_LEFT,
		    dimensions = CCSize(400, 200),
		    x	  = bgrect.width/2 - 190,
		    y	  = bgrect.height/2 + 20,
		});
	background:addChild(content);

	-- 按钮
	local button_buy = ui.newImageMenuItem({
			image 			= "#Button_Buy.png",
		    imageSelected 	= "#Button_Buy.png",
		    listener 		= function(tag)
		    					self:onBuyButtonClickAction(tag);
		    				end,
		    x 				= bgrect.width/2 - 120,
		    y 				= bgrect.height/2 - 110,
		});

	local button_cancel = ui.newImageMenuItem({
			image 			= "#Button_Cancel.png",
		    imageSelected 	= "#Button_Cancel.png",
		    listener 		= function(tag)
		    					self:onCancelButtonClickAction(tag);
		    				end,
		    x 				= bgrect.width/2 + 120,
		    y 				= bgrect.height/2 - 110,
		});

	local menu = ui.newMenu({button_buy, button_cancel});
	background:addChild(menu);

	parent:addChild(self.layer, 129);
end

function BuyingTipsView:onBuyButtonClickAction(tag)
	print "Buy Button Click."

	app:enterStoreScene()
end

function BuyingTipsView:onCancelButtonClickAction(tag)
	self.callback(true)
	self.layer:removeFromParentAndCleanup(true);
end

return BuyingTipsView;
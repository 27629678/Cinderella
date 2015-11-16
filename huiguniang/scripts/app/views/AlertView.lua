local AlertView = {}

function AlertView:show(table)

	-- table = {
	-- 			parent  = target,
	-- 			title	= "tilte",
	-- 			content = "content",
	-- 			button1 = 	{
	-- 							title 	 = "OK",
	-- 							callback = nil
	-- 						},
	-- 			button2 = 	{
	-- 							title 	 = "OK",
	-- 							callback = nil
	-- 						},
	-- 			callback= nil
	-- 		}

	local parent = table["parent"]
	if parent == nil then
		print "Parent is nil"
	end

	self.callback = table["callback"]
	
	if self.callback == nil then
		self.callback = parent:registAlertViewDelegate()
	end

	if self.callback ~= nil then
		self.callback(false)
	end

	-- config
	local nativefont 		= "DFYuanW7-GB";

	local title_font 		= "DFYuanW7-GB";
	local title_text 		= table["title"] == nil and "" or table["title"];
	local title_fontsize 	= 32;
	local title_fontcolor  	= ccc3(45, 15, 10);

	local content_font 		= "DFYuanW7-GB";
	local content_text 		= table["content"] == nil and "" or table["content"];
	local content_fontsize 	= 24;
	local content_fontcolor = ccc3(71, 32, 25);

	self.layer = display.newLayer()
	display.addSpriteFramesWithFile(UIALERTVIEW_TEXTURE_PLIST, UIALERTVIEW_TEXTURE_PNG);

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

	local pos_x 	= bgrect.width/2

	local pos1_x 	= bgrect.width/2 - 120
	local pos2_x 	= bgrect.width/2 + 120

	local pos_y 	= bgrect.height/2 - 110
	
	if content_text == "" then pos_y = pos_y + 20 end

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

	if content_text == "" then title:setPosition(bgrect.width/2,bgrect.height/2 + 90) end
	background:addChild(title);

	-- 内容
	local content = ui.newTTFLabel({
			text  = content_text,
		    font  = content_font,
		    size  = content_fontsize,
		    color = content_fontcolor,
		    align = ui.TEXT_ALIGN_CENTER,
		    dimensions = CCSize(480, 200),
		    x	  = bgrect.width/2,
		    y	  = bgrect.height/2 + 20,
		});
	background:addChild(content);

	-- 按钮
	local button_ok = ui.newImageMenuItem({
			image 			= "#Button_Background.png",
		    imageSelected 	= "#Button_Background.png",
		    listener 		= function(tag)
		    					-- self:onOKClickAction(tag);
		    					self:onCancelButtonClickAction(tag);
		    					local cb = table["button2"]["callback"]
		    					if cb ~= nil then
		    						cb(tag)
		    					end
		    				end,
		    x 				= bgrect.width/2 - 120,
		    y 				= bgrect.height/2 - 110,
		});

	local button_cancel = ui.newImageMenuItem({
			image 			= "#Button_Background.png",
		    imageSelected 	= "#Button_Background.png",
		    listener 		= function(tag)
		    					local cb = table["button1"]["callback"]
		    					if cb ~= nil then
		    						cb(tag)
		    					end
		    					self:onCancelButtonClickAction(tag);
		    				end,
		    x 				= bgrect.width/2 + 120,
		    y 				= bgrect.height/2 - 110,
		});

	local menu = nil
	if table["button2"] ~= nil then
		button_ok:setPosition(pos1_x, pos_y)
		addTitle(button_ok, table["button2"]["title"])
		button_cancel:setPosition(pos2_x, pos_y)
		addTitle(button_cancel, table["button1"]["title"])
		menu = ui.newMenu({button_ok, button_cancel})
	else
		button_cancel:setPosition(pos_x, pos_y)
		addTitle(button_cancel, table["button1"]["title"])
		menu = ui.newMenu({button_cancel});
	end
	 
	background:addChild(menu);

	parent:addChild(self.layer, 129);
end

function addTitle(parent, text)
	local parentsize = parent:getContentSize()
	-- print(parentsize.width, parentsize.height)
	local icon_1 = ui.newTTFLabel({
			text  = text,
		    font  = "DFYuanW7-GB",
		    size  = 27,
		    color = ccc3(209, 54, 0),
		    align = ui.TEXT_ALIGN_CENTER,
		    x	  = parentsize.width/2 + 2,
		    y	  = parentsize.height/2 + 4 - 3,	
		});
	parent:addChild(icon_1)

	local icon_2 = ui.newTTFLabel({
			text  = text,
		    font  = "DFYuanW7-GB",
		    size  = 27,
		    color = ccc3(255, 255, 255),
		    align = ui.TEXT_ALIGN_CENTER,
		    x	  = parentsize.width/2,
		    y	  = parentsize.height/2 + 4,	
		});
	parent:addChild(icon_2)
end

function AlertView:onOKClickAction(tag)
	print "OK Button Click."
end

function AlertView:onCancelButtonClickAction(tag)
	if self.callback ~= nil then
		self.callback(true)
	end
	self.layer:removeFromParentAndCleanup(true);
end

return AlertView
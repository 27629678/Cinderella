local ChapterSelectLayer = {}
local chapterList = import("..views.ChapterList")
local resourcedirectory = "ChapterSelect/"
local buyingtip = import(".BuyingTipsView")
local uibutton = import("..ui.UIButton")

function ChapterSelectLayer:create(parent)
	self.parent 	= parent;

	local m_scale = 1024/display.width
	local layer 	= display.newLayer()
	-- layer:setScaleX(display.width*1.0/1024)
	-- layer:setScaleY(display.height*1.0/768)
	self.layer 		= layer
	local offset_x 	= 50;
	local offset_y 	= 80;

	display.addSpriteFramesWithFile(CHAPTER_SELECT_TEXTURE_PLIST,CHAPTER_SELECT_TEXTURE_PNG);

	-- background
	local background = display.newScale9Sprite(
		"#background.png",
		display.cx + 5,
		display.cy - 60,
		CCSize(896, 566)
		);

	background:setInsetBottom(40);
	background:setInsetTop(40);
	background:setInsetLeft(32);
	background:setInsetRight(32);

	layer:addChild(background);
	
	local bgrect 	= background:getContentSize();
	local bgpos_x 	= background:getPositionX();
	local bgpos_y 	= background:getPositionY();

	-- print("Background, Width:", bgrect.width, "Height:", bgrect.height, "坐标：（", bgpos_x, ",", bgpos_y, ")");

	-- left button menu item
	self.leftbutton = ui.newImageMenuItem({
			image = "#button_left.png",
		    imageSelected = "#button_left.png",
		    listener = function ()
		    	self:onLeftButtonClickAction();
		    end
		});
	self.leftbutton:setScale(0);
	self.leftbutton:setEnabled(false);
	self.leftbutton:setPosition(bgpos_x - bgrect.width/2 + offset_x, bgpos_y - bgrect.height/2 + offset_y);

	-- right button menu item
	self.rightbutton = ui.newImageMenuItem({
			image = "#button_right.png",
		    imageSelected = "#button_right.png",
		    listener = function ()
		    	self:onRightButtonClickAction();
		    end
		});
	self.rightbutton:setEnabled(false);
	self.rightbutton:setPosition(bgpos_x + bgrect.width/2 - offset_x, bgpos_y - bgrect.height/2 + offset_y);

	-- menu
	local menu = ui.newMenu({self.leftbutton, self.rightbutton});
	self.menu = menu
	layer:addChild(menu);

    -- 章节选择
    self.chaptershowsprite = uibutton:newSpriteButton({
		image       = "ChapterSelect/ch_1_big.jpg",
        setAlpha    = false,
        x           = bgpos_x,
        y           = bgpos_y + 60,
        listener    = function(tag)
                        app:playJieshao(self.CurrentChapterID, self.CurrentChapterIndex)
                    end		
	}):addTo(layer)

	-- scroll view
	-- local rect = CCRect(display.cx - 363, 70, 735, 130)
	local rect = CCRect(display.cx - 363, 70, 735, 130)
	self.chapterlist = chapterList.new(rect)
	self.chapterlist:setTouchEnabled(true)
	self.chapterlist:addEventListener("onTapChapterIcon", handler(self, self.onTapChapterIcon))
	self.chapterlist:addEventListener("ChapterSelectViewDidScroll", handler(self, self.ChapterSelectViewDidScroll));
	layer:addChild(self.chapterlist)

	parent:addChild(layer);

	self.CurrentChapterID = 1;
	self.CurrentChapterIndex = 1;
end

function ChapterSelectLayer:onLeftButtonClickAction()
	print "LeftButtonClick";
end

function ChapterSelectLayer:onRightButtonClickAction()
	print "RightButtonClick";
end

function ChapterSelectLayer:ChapterSelectViewDidScroll(event)
	if event.direct == "left" then
		self.leftbutton:setScale(0);
		self.rightbutton:setScale(1);
	elseif event.direct == "right" then
		self.leftbutton:setScale(1);
		self.rightbutton:setScale(0);
	else
		self.leftbutton:setScale(1);
		self.rightbutton:setScale(1);
	end
end

function ChapterSelectLayer:onTapChapterIcon(event)
	-- print (	
	-- 	"Chapter Info:",
	-- 	-- "\nEvent Name:", event.name,
	-- 	"\nButton Index:", event.levelindex,
	-- 	"\nIs Free:", event.isfree,
	-- 	"\nChapter ID:", event.chapter
	-- 	);

	local isfree = event.isfree;

	if isfree then
		self.CurrentChapterID 		= event.chapter;
		self.CurrentChapterIndex 	= event.chindex;

		local filename = string.format("ChapterSelect/ch_%d_big.jpg", event.levelindex);
		self.parent:setBackgroundWithChapterID(event.chapter)

		local texture = CCTextureCache:sharedTextureCache():addImage(filename);
		if texture ~= nil then
			self.chaptershowsprite:setTexture(texture);
		end
	else
		print "U have to Buy."
		local callback = function(state)
			self:EnableUpLayerTouchEvent(state)
		end
		buyingtip:create(self.parent, callback);
	end
	
	print ("Current Chapter ID:", self.CurrentChapterID, "-", self.CurrentChapterIndex);
end

function ChapterSelectLayer:EnableUpLayerTouchEvent(state)
	self.parent.layer:setTouchEnabled(state)
	self.parent.menu:setTouchEnabled(state)
	self.layer:setTouchEnabled(state)
	self.menu:setEnabled(state)
	self.chapterlist:setTouchEnabled(state)
end

return ChapterSelectLayer;
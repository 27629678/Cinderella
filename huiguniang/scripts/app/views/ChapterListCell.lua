local ScrollViewCell = import("..ui.ScrollViewCell");
local ChapterListCell = class("ChapterListCell", ScrollViewCell);

function ChapterListCell:ctor(size, begin_index, end_index, datatable)
	
	local bgImage 		= "#button_background.png";
	local start_pos_x 	= display.cx - 290;
	-- iPhone
	-- local start_pos_y 	= 80;
	-- iPhone5
	local start_pos_y 	= size.height;
	local colWidth 		= 148;
	local isPayed 		= GameData.BuyState == "TRUE" and true or false;
	local nativefont 	= "DFYuanW7-GB";
	-- local nativefont  	= "Marker Felt";
	local fontcolor		= ccc3(71,32,25);
	local fontsize 		= 18;

	display.addSpriteFramesWithFile(CHAPTER_SELECT_TEXTURE_PLIST,CHAPTER_SELECT_TEXTURE_PNG);

	local batch = display.newBatchNode(CHAPTER_SELECT_TEXTURE_PNG);
	self:addChild(batch);

	self.buttons = {};

	local titletable = {}
	local imagetable = {}
	local freetable  = {}
	local ch_idtable = {}
	local ch_indextable = {}

	local begin  = begin_index
	local length = end_index

	for i = begin, length do
		titletable[#titletable + 1] = datatable[i]["title"]
		imagetable[#imagetable + 1] = datatable[i]["image"]
		freetable [#freetable  + 1] = datatable[i]["free"]
		ch_idtable[#ch_idtable + 1] = datatable[i]["ch_id"]
		ch_indextable[#ch_indextable + 1] = datatable[i]["ch_index"]
	end

	local x 	= start_pos_x;
	local y 	= start_pos_y;
	local index = begin_index;
	local count = end_index - begin_index + 1;

	for col = 1, count do
		-- background
		local background = display.newSprite(bgImage, x, y);
		batch:addChild(background);
		background.levelindex = col + index - 1;

		-- icon
		local icon = display.newSprite(imagetable[col], x, y + 15.5);
		batch:addChild(icon);

		-- label
		local label = ui.newTTFLabel({
		text 	= titletable[col],
	    font 	= nativefont,
	    size 	= fontsize,
	    x 		= x,
	    y 		= y - 40,
	    color 	= fontcolor,
	    align 	= ui.TEXT_ALIGN_CENTER
		});
		self:addChild(label);

		local m_IsFree = freetable[col] > 0 and true or false;
		if not (isPayed or m_IsFree) then
			fade = display.newSprite("#fad_small.png", x, y + 15.5):addTo(batch)
			background.isFree = false
		else
			background.isFree = true
		end

		background.ch_id 	= ch_idtable[col]
		background.ch_index = ch_indextable[col]

		self.buttons[#self.buttons + 1] = background;

		x = x + colWidth;
	end
end

function ChapterListCell:onTouch(event, x, y)
	if event == "began" then
		local button = self:checkButton(x, y);
		if button then
			print "touch";
		end
	elseif event == "moved" then
		print "moved";
	end
end

function ChapterListCell:onTap(x, y)
	local button = self:checkButton(x, y);
	if button then
		self:dispatchEvent(
		{
			name 		= "onTapChapterIcon",
			levelindex 	= button.levelindex,
			isfree 		= button.isFree,
			chapter 	= button.ch_id,
			chindex 	= button.ch_index
		});
	end
end

function ChapterListCell:checkButton(x, y)
	local pos = CCPoint(x, y);

	for i = 1, #self.buttons do
		local button = self.buttons[i];
		if button:getBoundingBox():containsPoint(pos) then
			-- print ("Button Index Order:", i);
			return button;
		end
	end

	return nil;
end


return ChapterListCell;
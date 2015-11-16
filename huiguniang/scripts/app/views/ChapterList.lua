local chaptercell = import(".ChapterListCell")
local pagecontrol = import("..ui.PageControl")

local ChapterList = class("ChapterList", pagecontrol)

function ChapterList:ctor(rect)
	ChapterList.super.ctor(self, rect, pagecontrol.DIRECTION_HORIZONTAL)

	local database = {
		{
			ch_id 		= 1,
			ch_index 	= 1,
			title 		= "第一章 1",
			image 		= "#ch_1_1_small.jpg",
			free  		= 1,
		},
		{
			ch_id 		= 1,
			ch_index 	= 2,
			title 		= "第一章 2",
			image 		= "#ch_1_2_small.jpg",
			free  		= 1,
		},
		{
			ch_id 		= 1,
			ch_index 	= 3,
			title 		= "第一章 3",
			image 		= "#ch_1_3_small.jpg",
			free  		= 1,
		},
		{
			ch_id 		= 1,
			ch_index 	= 4,
			title 		= "第一章 4",
			image 		= "#ch_1_4_small.jpg",
			free  		= 1,
		},
		{
			ch_id 		= 2,
			ch_index 	= 1,
			title 		= "第二章",
			image 		= "#ch_2_small.jpg",
			free  		= 0,
		},
		{
			ch_id 		= 3,
			ch_index 	= 1,
			title 		= "第三章",
			image 		= "#ch_3_small.jpg",
			free  		= 0,
		},
		{
			ch_id 		= 4,
			ch_index 	= 1,
			title 		= "第四章",
			image 		= "#ch_4_small.jpg",
			free  		= 0,
		},
	}

	-- add cells
	local countsPerRow = 5
	local itemCounts = 7
	local numPages = math.ceil(7/countsPerRow)
	self.pageCount = numPages

	for pageIndex = 1, numPages do

		cols = itemCounts - (pageIndex - 1) * countsPerRow

		if cols > countsPerRow then
			cols = countsPerRow
		end

		local titletable = {}
		local imagetable = {}

		local begin = (pageIndex - 1) * countsPerRow + 1
		local length = begin + cols - 1

		for i = begin, length do
			titletable[#titletable + 1] = database[i]["title"]
			imagetable[#imagetable + 1] = database[i]["image"]
		end

		local cell = chaptercell.new(rect.size, begin, length, database)
		cell:addEventListener("onTapChapterIcon", function (event)
			return self:onTapChapterIcon(event)
		end)
		self:addCell(cell)
	end
end

function ChapterList:scrollToCell(index, animated, time)
    ChapterList.super.scrollToCell(self, index, animated, time)

    local tag = "null";

    if index == 1 then
    	tag = "left"
    elseif index == self.pageCount then
    	tag = "right"
    end

    self:dispatchEvent(
		{
			name 	= "ChapterSelectViewDidScroll",
			direct 	= tag
		}
	);
end

function ChapterList:onTapChapterIcon(event)
	-- print ("Event Name:", event.name, "Level Index:", event.levelindex, "Free:", event.isfree);
	self:dispatchEvent(
	{
		name 		= "onTapChapterIcon",
		levelindex 	= event.levelindex,
		isfree 		= event.isfree,
		chapter 	= event.chapter,
		chindex 	= event.chindex
		});
end

return ChapterList
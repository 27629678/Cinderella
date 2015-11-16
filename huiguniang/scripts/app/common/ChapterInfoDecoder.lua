--
-- Author: sddz_yuxiaohua@corp.netease.com
-- Date: 2014-04-29 14:13:54
--

require("json")

-- 将模块名设置为require的参数，这样今后重命名模块时，只需重命名文件名即可。
local modname = ...

local ChapterInfoDecoder = {}

_G[modname] = ChapterInfoDecoder

function ChapterInfoDecoder.initWithChapterID(chapterid)
	chapterid = chapterid or 1

	local mPath = device.writablePath .. string.format("%s",chapterid) .. "/Config.txt"

	print("配置文件路径:",mPath)

	if io.exists(mPath) then
		local fileinfo = assert(io.readfile(mPath))
		io.close()

		return json.decode(fileinfo)
	else
		print("文件不存在")
		return nil
	end
end

return ChapterInfoDecoder
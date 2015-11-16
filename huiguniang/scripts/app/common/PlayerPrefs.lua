--
-- Author: sddz_yuxiaohua@corp.netease.com
-- Date: 2014-04-30 14:05:22
--
local GameState =require(cc.PACKAGE_NAME .. ".api.GameState")

local PlayerPrefs = {}

function PlayerPrefs:init()
	GameState.init(function(param)
        local returnValue = nil

        if param.errorCode then
            if param.errorCode == GameState.ERROR_INVALID_FILE_CONTENTS then
                print "不合法的文件内容"
            elseif param.errorCode == GameState.ERROR_HASH_MISS_MATCH then
                print "文件被人为更改过"
            elseif param.errorCode == GameState.ERROR_STATE_FILE_NOT_FOUND then
                print "文件不存在"
            end
        else
            -- crypto
            if param.name=="save" then
                local str=json.encode(param.values)
                str=crypto.encryptXXTEA(str, "abcd")
                returnValue={data=str}
            elseif param.name=="load" then
                local str=crypto.decryptXXTEA(param.values.data, "abcd")
                returnValue=json.decode(str)
            end
        end

        return returnValue
    end, "PlayerPrefs.txt", "com.163.61.cinderella")

    local GameData = GameState.load()
    if not GameData then
        GameData = GameState, {}
        GameState.save(GameData)
    end

    GameData.BuyState = "TRUE"
    GameState.save(GameData)

    return GameState, GameData
end

return PlayerPrefs
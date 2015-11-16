

local dao = {}

filePath = CCFileUtils:sharedFileUtils():getWritablePath() .. (device.platform == "ios" and ("huiguniang.sqlite") or ("res/"..DBFILE))

function dao:testDB()
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);
    for row in db:nrows("select * from user") do
      print(row.id,row.name)
    end

    db:close()
end


--获取用户信息：
function dao:getUserInfo()
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);

    for row in db:nrows("select * from user") do
      db:close()
      return row;
    end
end

--创建用户
function dao:createUser()
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);

    local result = db:exec'insert into user(name,type) values("xiaoshi","free")';
    db:close()
    return result;
end

--更新用户购买状态：
function dao:updateUserBuyed()
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);
    local result = db:exec'update user set type="buyed" where name="xiaoshi"';
    db:close()
    return result;
    
end

--获取用户学习配置信息：
function dao:getScheduleInfo()
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);

    for row in db:nrows("select * from schedule") do
      db:close()
      return row;
    end
end


--创建
function dao:createSchedule()
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);

    local result = db:exec'insert into schedule(name,type) values("xiaoshi","free")';
    db:close()
    return result;
end

--更新用户学习配置信息：
function dao:updateScheduleInfo(id)
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);
    local result = db:exec'update schedule set type="buyed" where name="xiaoshi"';
    db:close()
    return result;
end




--game and chars config/records:
function dao:getAllCharsFree()
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);

    a = {}
    for row in db:nrows("select * from chars_config where id<41") do
      table.insert(a, row)
    end
    db:close();
    return a;
end

function dao:getAllCharsPayed()
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);

    a = {}
    for row in db:nrows("select * from chars_config") do
      table.insert(a, row)
    end
    db:close();
    return a;
end

function dao:updateCharLearned(char_id)
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);

    local result = db:exec'insert into learn_record(type,char_id) values("learned",'..char_id..')';
    db:close()
    return result;
end

function dao:getCharsLearned()
    local sqlite3 = require("lsqlite3","rw");
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);

    a = {}
    for row in db:nrows("select * from learn_record") do
      table.insert(a, row)
    end
    db:close();
    return a;
end




--
function dao:getStoryConfig(storyid)  
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);

    for row in db:nrows("select * from story_config where id="..storyid) do
      db:close()
      return row;
    end
end

function dao:getConfig()
    local sqlite3 = require("lsqlite3","rw")
    local db, ErrCode, ErrMsg = sqlite3.open(filePath);

    a = {}
    for row in db:nrows("select * from user") do
      table.insert(a, row)
    end
    db:close();
    return a;
end

function dao:getAllCharsFromDB()
    local learnedRecord = self:getCharsLearned();
    local learnedIds = {};
    for k,v in ipairs(learnedRecord) do
        table.insert(learnedIds,learnedRecord[k]["char_id"]);
    end
    lastCharId = table.max(learnedIds);
    needLearnList = {};
    local i = 1;

    while i <=4 do
        table.insert(needLearnList,lastCharId+i);
        i = i + 1;
    end

    userType = 0;
    if self:isPayed() == 0 then
        userType = 0;
    end 
    if self:isPayed() == 1 then
        userType = 1;
    end
    local answersdata = self:generateRandomCharsAns(needLearnList,userType);
    return answersdata;
end

function dao:generateRandomCharsAns(char_ids,type)
    local resTab = {};
    if type == 0 then
        local i = 1;
        while i<= #char_ids do 
            local qItem = {};
            local allChars = dao:getAllCharsFree();
            for k,v in ipairs(allChars) do
                if v["id"] == char_ids[i] then
                    v["isAnswer"] = 1;
                    table.insert(qItem,v);
                    table.remove(allChars,k);
                end
            end
            local otherItems = collectThreeItems(allChars);
            for k,v in ipairs(otherItems) do
                --v.isAnswer = false;
                v["isAnswer"] = 0;
                table.insert(qItem,v);
            end
            i = i+1;
            table.insert(resTab,qItem);
        end
    end

    if type == 1 then
        local i = 1;
        while i<= #char_ids do 
            local qItem = {};
            local allChars = dao:getAllCharsPayed();
            for k,v in ipairs(allChars) do
                if v["id"] == char_ids[i] then
                    table.insert(qItem,v);
                    table.remove(allChars,k);
                end
            end
            local otherItems = {};
            otherItems = collectThreeItems(allChars);
            for k,v in ipairs(otherItems) do
                table.insert(qItem,v);
            end
            i = i+1;
            table.insert(resTab,qItem);
        end
    end
    return resTab;
end

function collectThreeItems(ta)
    collectList = {};
    randomItem1 = ta[math.random(1,#ta)];
    table.insert(collectList,randomItem1);
    while #collectList<=2 do
        randomItem = ta[math.random(1,#ta)];
        local insertFlag = true;
        for k,v in ipairs(collectList) do
            if v["id"] == randomItem["id"] then
                insertFlag = false;
            end
        end
        if insertFlag then
            table.insert(collectList,randomItem);
        end
    end
    return collectList;
    
end


function dao:isPayed() 
    local user = dao:getUserInfo();
    if user["type"] == "free" then
        return 0;
    end
    if user["type"] == "payed" then
        return 1;
    end    
end

--get the max number of the table
function table.max(atable)
    local maxNumber
    if maxNumber == nil then
        maxNumber = atable[1]
    end
    for m = 1, table.getn(atable) do
        if atable[m] > maxNumber then
            maxNumber = atable[m]
        end
    end
    return maxNumber
end

return dao
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")
require("app.common.json")
require("framework.scheduler")
md5 = require("app.common.md5")
local Store = require("app.common.NEIAPStoreManager")

local datasource = import("app.common.NEDataSource")

PlayerPrefs = import("app.common.PlayerPrefs")

local game = class("game", cc.mvc.AppBase)

GameData = {}

function game:ctor()
    game.super.ctor(self)
    self.objects_ = {}
    self.currentChapterID = 1
    self.currentChapterIndex = 1
end

function game:run()
    -- 初始化两个全局变量
    -- @GameState   GameState对象
    -- @GameData    GameState的Data对象
    GameState, GameData = PlayerPrefs:init()

    if device.platform == "ios" then
        -- 向OC注册课程设置完毕的回调方法
        self:registeCourseSettingCallback()
        -- 向OC注册网易识字读故事书请求完毕的回调方法
        self:registeBeganReadStoryCallback()

        -- 添加IAP回调方法
        game.store = Store.new()
        game.store:addEventListener(Store.TRANSACTION_PURCHASED,
                                    game.onTransactionPurchased)
        game.store:addEventListener(Store.TRANSACTION_FAILED,
                                    game.onTransactionFailed)
        game.store:addEventListener(Store.TRANSACTION_UNKNOWN_ERROR,
                                    game.onTransactionUnknownError)
        game.store:addEventListener(Store.TRANSACTION_RESTORED,
                                    game.onTransactionRetored)
    end

    CCFileUtils:sharedFileUtils():addSearchPath("res/")

    -- 加载Loading场景
    self:enterScene("LoadingScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function game.onTransactionPurchased(event)
    local transaction = event.transaction
    local productId = transaction.productIdentifier
    local product = game.store:getProductDetails(productId)
    local msg
    if product then
        msg = string.format("Game:productId = %s\nquantity = %s\ntitle = %s\nprice = %s %s", productId, tostring(transaction.quantity), product.localizedTitle, product.price, product.priceLocale)
    else
        -- prev unfinished transaction
        msg = string.format("Game:productId = %s\nquantity = %s", productId, tostring(transaction.quantity))
    end
    device.showAlert("IAP Purchased", msg, {"OK"})

    GameData.BuyState = "TRUE"
    GameState.save(GameData)
    -- add Player's Coins at here
end

function game.onTransactionRetored(event)
    local transaction = event.transaction
    if event.transaction.productIdentifier == "CH12S" then print "CH12S Restore Over." end

    GameData.BuyState = "TRUE"
    GameState.save(GameData)
    device.showAlert("提示", "内购已经恢复完毕", {"确定"})
end

function game.onTransactionFailed(event)
    local transaction = event.transaction
    local msg = string.format("errorCode = %s\nerrorString = %s",
                              tostring(transaction.errorCode),
                              tostring(transaction.errorString))
    device.showAlert("IAP Purchased", msg, {"OK"})
end

function game.onTransactionUnknownError(event)
    if display.getRunningScene() == "Store" then return end

    device.showAlert("IAP Error", "Unknown error", {"OK"})
end

function game:readJSON()
    local filepath = device.cachePath.."scripts/app/data/1/Config.txt";
    local content = readAll(filepath);
    --print(content);

    -- json string to lua table decode
    jsonObj = json.decode(content);

    print(jsonObj)
    print(jsonObj['chapterInfo']);
    print(jsonObj['charstolearn'][1]['id']);
    print(jsonObj['charstolearn'][1]['char_chinese']);
    print(jsonObj['charstolearn'][1]['char_sound']);
    return jsonObj
end

function readAll(file)
    local f = io.open(file, "r")
    local content = f:read("*a");
    return content;
end 


--get md5 from string:
function getMD5(str)
    local md5Str = md5.string(str);
    return md5Str;
end

--network get:
function getRequest()
    -- 创建一个请求，并以 POST 方式发送数据到服务端
    local url = "http://www.baidu.com"
    local request = network.createHTTPRequest(onRequestFinished, url, "GET")
    --request:addPOSTValue("KEY", "VALUE")
     
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
end


function onRequestFinished(event)
    local ok = (event.name == "completed")
    local request = event.request
 
    if not ok then
        -- 请求失败，显示错误代码和错误消息
        print(request:getErrorCode(), request:getErrorMessage())
        return
    end
 
    local code = request:getResponseStatusCode()
    print(code);
    local response = request:getResponseString();
    print("result:"..response)
    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        print(code)
        return
    end
 
    -- 请求成功，显示服务端返回的内容
    --print("run here");
    --local response = request:getResponseBody()
    --print();
    --print("result:"..response)
end

function game:playStartScene()
    self:enterScene("MainMenu", nil, "fade", 0.6, display.COLOR_WHITE)
end

function game:playJieshao(chapterid, chapterindex)
    print (chapterid, chapterindex)
    self.currentChapterID = chapterid
    self.currentChapterIndex = chapterindex

    -- self:enterScene("UnitTest",{chapterid}, "fade", 0.6, display.COLOR_WHITE)
    self:playStory()

    -- self:purgeArmatureData()
    -- self:enterScene("jieshao",{chapterid}, "fade", 0.6, display.COLOR_WHITE)
end

-- added by yuxiaohua
function game:playStory()
    self:purgeArmatureData()

    if self.currentChapterIndex ~= 4 then
        scenename = string.format("ch%dScene%d", self.currentChapterID, self.currentChapterIndex)
        self:enterScene(scenename, nil, "fade", 0.1, display.COLOR_WHITE)
    else
        self:enterScene("ChapterEndScene", nil, "fade", 0.1, display.COLOR_WHITE)
    end
end

function game:enterStoreScene()
    self:enterScene("Store", nil, "fade", 0.2, display.COLOR_WHITE)
end

function game:enterMainMenuScene()
    self:enterScene("MainMenu", nil, "fade", 0.2, display.COLOR_WHITE)
end

function game:enterCourseConfigScene()
    self:enterScene("CourseConfig", nil, "fade", 0.2, display.COLOR_WHITE)
end

function game:enterAboutScene()
    self:enterScene("About", nil, "fade", 0.2, display.COLOR_WHITE)
end

function game:enterAboutScene()
    self:enterScene("About", nil, "fade", 0.2, display.COLOR_WHITE)
end

function game:playNextChapterIndex()
    if self.currentChapterIndex < 4 then
        self:purgeArmatureData()
        self.currentChapterIndex = self.currentChapterIndex + 1

        if self.currentChapterIndex ~= 4 then
            scenename = string.format("ch%dScene%d", self.currentChapterID, self.currentChapterIndex)
            self:enterScene(scenename, nil, "fade", 0.1, display.COLOR_WHITE)
        else
            self:enterScene("ChapterEndScene", nil, "fade", 0.1, display.COLOR_WHITE)
        end
    end
end

function game:rewindCurrentChapterIndex()
    if self.currentChapterIndex < 5 and self.currentChapterIndex > 0 then
        scenename = string.format("ch%dScene%d", self.currentChapterID, self.currentChapterIndex)
        self:enterScene(scenename, nil, "fade", 0.1, display.COLOR_WHITE)
    end
end

function game:playLastChapterIndex()
    if self.currentChapterIndex > 1 then
        self:purgeArmatureData()
        self.currentChapterIndex = self.currentChapterIndex - 1;
        scenename = string.format("ch%dScene%d", self.currentChapterID, self.currentChapterIndex)
        self:enterScene(scenename, nil, "fade", 0.1, display.COLOR_WHITE)
    end
end

function game:purgeArmatureData()
    CCArmatureDataManager:sharedArmatureDataManager():removeAll()
    CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
    CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

-- 注册课程设置完成后OC回调Lua的FuncID
function game:registeCourseSettingCallback()
    local function callback(event)
        if event["status"] == "1" then
            device.showAlert("提示", "设置成功", {"YES", "NO"}, nil)
        elseif event["status"] == "0" then
            device.showAlert("提示", "设置失败", {"YES", "NO"}, nil)
        end
    end

    luaoc.callStaticMethod("NEStoryAPI", "RegistSynchronousLearningProgressCallback", {listener = callback})
end

-- 注册网易识字开始学习故事打开故事书对应章节的Lua Func ID
function game:registeBeganReadStoryCallback()
    local function callback(event)
        local m_Message = string.format("开始阅读%s章，使用自带数据%s", event["ID"], event["tag"])
        device.cancelAlert()
        device.showAlert("提示", m_Message, {"YES", "NO"}, nil)
    end

    luaoc.callStaticMethod("NEStoryAPI", "RegistBeganReadStoryCallback", {listener = callback})
end

-- 传递分数给网易识字App
function game:transferMessageToElearnApp()
    print("传递分数给网易识字App")
end
return game

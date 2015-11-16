local common = {};

function common:showMenu(parent,storyChars,scene,app,music)
	display.addSpriteFramesWithFile(COMMON_ZIMU_DATA_FILENAME,COMMON_ZIMU_IMAGE_FILENAME);
	self.chongfu = display.newSprite("#B_chongfu.png", display.cx, display.cy);
	self.fanhui = display.newSprite("#B_fanhui.png", display.cx, display.cy);
	self.guanbi = display.newSprite("#B_guanbi.png",display.cx, display.cy);
	self.qipao = display.newSprite("#qipao.png",display.cx, display.cy);
    self.wenhao = display.newSprite("#wenhao.png",display.cx, display.cy);

	
	self.chongfu:setPosition(975,690);
	self.fanhui:setPosition(50,690);
	self.qipao:setAnchorPoint(CCPoint(0,0));
	self.qipao:setPosition(50,1000);
	self.guanbi:setPosition(850,330);

	
	--parent:addChild(self.guanbi);
	parent:addChild(self.qipao)
	parent:addChild(self.chongfu);
	parent:addChild(self.fanhui);
    parent:addChild(self.wenhao);


	self.label = ui.newTTFLabel({
        --text = storyConfig["content"],
        text = storyChars,
        font = "DFYuanW7-GB",
        x = 160,
        y = display.bottom +0,
        size = 25,
        dimensions = CCSize(700,450);
        color = ccc3(86, 14, 0);
    });
    self.label:setAnchorPoint(CCPoint(0,0));
    self.label:setPosition(100,-50);
    self.label:setContentSize(CCSize(400,50));

	self.qipao:addChild(self.label);
	self.qipao:addChild(self.guanbi);

	local manager = CCArmatureDataManager:sharedArmatureDataManager()
    manager:addArmatureFileInfo("common/xin_tu_output/xinfeng.png", "common/xin_tu_output/xinfeng.plist", "common/xin_tu_output/xinfeng.xml");

     
    self.tuzi = CCNodeExtend.extend(CCArmature:create("tuzi"));

    self.xinfeng = CCNodeExtend.extend(CCArmature:create("xinfeng"));
    self.xinfeng:setAnchorPoint(CCPoint(0,0));
    --print(self.tuzi);
   
    self.tuzi:setPosition(500,680);
    self.tuzi:setAnchorPoint(CCPoint(0.5,0));
    parent:addChild(self.tuzi);
    self.tuzi:setTouchEnabled(true);
    tuziHeight = self.tuzi:getContentSize().height;
    tuziWidth = self.tuzi:getContentSize().width;
    self.tuzi:setCascadeBoundingBox(cc.rect(-tuziWidth/2, -tuziHeight/2, tuziWidth,tuziHeight));
    self.tuzi:addTouchEventListener(function(event, x, y)
        if event == "began" then
            -- BourceEffect(self.tuzi);
            local x, y = self.tuzi:getPosition()
        	transition.moveTo(self.tuzi, {y = y + 100, time = 1})
            
            local qx, qy = self.qipao:getPosition()
    		transition.moveTo(self.qipao, {y = qy - 700, time = 1.5})
            
            return true
        end
    end);



    self.guanbi:setTouchEnabled(true);
    self.guanbi:setAnchorPoint(CCPoint(0.5,0));
    self.guanbi:addTouchEventListener(function(event, x, y)
        if event == "began" then
            BourceEffectCommon(self.guanbi,function()
                local qx, qy = self.qipao:getPosition()
                transition.moveTo(self.qipao, {y = qy + 700, time = 1})

                local x, y = self.tuzi:getPosition()
                transition.moveTo(self.tuzi, {y = y - 100, time = 1.5})
            end);
            return true 
        end
    end);

    self.chongfu:setTouchEnabled(true);
    self.chongfu:setAnchorPoint(CCPoint(0.5,0));
    self.chongfu:addTouchEventListener(function(event, x, y)
        if event == "began" then
            BourceEffectCommon(self.chongfu,function()
                 audio.playBackgroundMusic(music,false)
            end);            
            return true 
        end
    end);

    self.fanhui:setTouchEnabled(true);
    self.fanhui:setAnchorPoint(CCPoint(0.5,0));
    self.fanhui:addTouchEventListener(function(event, x, y)
        if event == "began" then
            BourceEffectCommon(self.fanhui,function()
                app:playStartScene();            
                return true 
            end);
        end
    end);

    runAnimationForever(self.tuzi,"tuzi",2);
end


function common:checkNetConnect()
    local networkstatus = network.isInternetConnectionAvailable();
    print(networkstatus);
end

function common:callOCWebViewBroadCast()
    local function callback(event)
        print(event);
    end

    local ret = luaoc.callStaticMethod("PostBoardViewController","LoadWebViewWithDictioanary",{url="http://61.163.com/elearn/edu/v3/broadcast",width=800,height=600})
end

function common:showXinFeng(parent)
    local manager = CCArmatureDataManager:sharedArmatureDataManager()
    manager:addArmatureFileInfo("common/xin_tu_output/xinfeng.png", "common/xin_tu_output/xinfeng.plist", "common/xin_tu_output/xinfeng.xml");
    
    self.xinfeng = CCNodeExtend.extend(CCArmature:create("xinfeng"));
    self.xinfeng:setPosition(display.cx,display.top - 40);
    
    parent:addChild(self.xinfeng);
    runAnimationForever(self.xinfeng,"xinfeng",1)
    self.xinfeng:setTouchEnabled(true);
    xinfengHeight = self.xinfeng:getContentSize().height;
    xinfengWidth = self.xinfeng:getContentSize().width;
    self.xinfeng:setCascadeBoundingBox(cc.rect(-xinfengWidth/2, -xinfengHeight/2, xinfengWidth,xinfengHeight));
    self.xinfeng:addTouchEventListener(function(event, x, y)
        if parent.isTouchEnabled(parent) == false then
            return
        end

        if event == "began" then
            BourceEffectCommon(self.xinfeng,function()
                self:callOCWebViewBroadCast()
                return true
            end);
        end
    end);

end

function BourceEffectCommon(button,cb)
    local function zoom1(offset, time, onComplete)
        local x, y = button:getPosition()
        local size = button:getContentSize()

        local scaleX = button:getScaleX() * (size.width + offset) / size.width
        local scaleY = button:getScaleY() * (size.height - offset) / size.height

        transition.moveTo(button, {y = y - offset, time = time})
        transition.scaleTo(button, {
            scaleX     = scaleX,
            scaleY     = scaleY,
            time       = time,
            onComplete = onComplete,
        })
    end

    local function zoom2(offset, time, onComplete)
            local x, y = button:getPosition()
            local size = button:getContentSize()

            transition.moveTo(button, {y = y + offset, time = time / 2})
            transition.scaleTo(button, {
                scaleX     = 1.0,
                scaleY     = 1.0,
                time       = time,
                onComplete = onComplete,
            })
    end
    zoom2(0,0.2,function() 
        zoom1(10,0.2,function()
            zoom2(10,0.2,function()
            	cb();
            end)
        end)
    end);
end

function runAnimationForever(obj,actionName,timeLoop)
    local animation = obj:getAnimation()
    animation:setAnimationScale(24/60)
    animation:play(actionName, -1, -1, 1, 0);
    -- animation:play(actionName)
end

return common
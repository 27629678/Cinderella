
local jieshao = class("jieshao", function()
    return display.newScene("jieshao")
end)

function jieshao:ctor(param)
	chapterIndex = param;
	display.addSpriteFramesWithFile(JIESHAO_DATA_FILENAME,JIESHAO_FILENAME);
    self.bg = display.newSprite("#G_jieshao.png", display.cx, display.cy);
    self.p1 = display.newSprite("#1.png", display.cx, display.cy);
    self.p2 = display.newSprite("#2.png", display.cx, display.cy);
    self.p3 = display.newSprite("#3.png", display.cx, display.cy);
    self.p4 = display.newSprite("#4.png", display.cx, display.cy);
    self.p5 = display.newSprite("#5.png", display.cx, display.cy);
    self.fanhui = display.newSprite("#B_fanhui_1.png", display.cx, display.cy);
    self.kaishi = display.newSprite("#B_kaishi.png", display.cx, display.cy);
    self.dian1 = display.newSprite("#E_dian_1.png", display.cx, display.cy);
    self.dian2 = display.newSprite("#E_dian_2.png", display.cx, display.cy);
    self.baidi = display.newSprite("#di.png", display.cx, display.cy);
    self.title = display.newSprite("#T_W_jieshao.png", display.cx, display.cy);
    self.you = display.newSprite("#E_you.png", display.cx, display.cy);
    self.zuo = display.newSprite("#E_zuo.png", display.cx, display.cy);

    self:addChild(self.bg);
    self.kaishi:setPosition(350,20);
    self.kaishi:setAnchorPoint(CCPoint(0,0));
    self.fanhui:setPosition(30,680);
    self.fanhui:setAnchorPoint(CCPoint(0,0));
    self.title:setPosition(370,640);
    self.title:setAnchorPoint(CCPoint(0,0));
    self.zuo:setPosition(20,320);
    self.zuo:setAnchorPoint(CCPoint(0,0));
    self.you:setPosition(950,320);
    self.you:setAnchorPoint(CCPoint(0,0));


    self:addChild(self.kaishi);
    self:addChild(self.fanhui);
    self:addChild(self.baidi);
    self:addChild(self.title);
    self:addChild(self.zuo);
    self:addChild(self.you);

    self.slide = display.newLayer();
    self.slide:setTouchEnabled(false);
    itemWidth = 721;

end

function jieshao:onEnter(param)
    self:slideShow();
    self.fanhui:setTouchEnabled(true);
    self.fanhui:addTouchEventListener(function(event, x, y)
        if event == "began" then
            BourceEffectJieshao(self.fanhui,function() 
            	app:playStartScene();
                return;
            end);
        end
    end); 
    
    self.kaishi:setTouchEnabled(true);
    self.kaishi:addTouchEventListener(function(event,x,y) 
    	if event == "began" then
            BourceEffectJieshao(self.kaishi,function() 
            	app:playStory()
            end);
        end
    	
    end);
end


function jieshao:slideShow()
    self.p1:setAnchorPoint(CCPoint(0,0))
    self.p1:setPosition(0,0);
    self.p2:setAnchorPoint(CCPoint(0,0))
    self.p2:setPosition(itemWidth,0);
    self.p3:setAnchorPoint(CCPoint(0,0));
    self.p3:setPosition(itemWidth*2,0);
    self.p4:setAnchorPoint(CCPoint(0,0));
    self.p4:setPosition(itemWidth*3,0);
    self.p5:setAnchorPoint(CCPoint(0,0));
    self.p5:setPosition(itemWidth*4,0);

	self.slide:addChild(self.p1);
    self.slide:addChild(self.p2);
    self.slide:addChild(self.p3);
    self.slide:addChild(self.p4);
    self.slide:addChild(self.p5);

    self.pl1 = ui.newTTFLabel({
        text = "小美扮演灰姑娘,一个可怜的小女孩",
        x = 160,
        y = 40,
        size = 23,
        color = ccc3(210,141,67)
    });


    self.baidi:addChild(self.pl1);
    self.scroller = CCScrollView:create(CCSizeMake(itemWidth,500),self.slide);
    self.scroller:setPosition(CCPoint(10,80));
    self.scroller:setBounceable(false);
    self.scroller:setTouchEnabled(false);
    self.scroller:setContentOffset(ccp(0,0), false);

    self.baidi:addChild(self.scroller);
    self.zuo:setTouchEnabled(true);

    slideIndex = 1;
    self:touchSlide(slideIndex);
    transition.fadeOut(self.zuo,{time = 0});
    self.zuo:addTouchEventListener(function(event, x, y)
        if event == "began" then
                BourceEffectJieshao(self.zuo,function()
                    transition.fadeIn(self.you,{time = 0.1});
                    if slideIndex >1 then
                        slideIndex = slideIndex - 1;
                        moveSlide(self.slide,1,0.4);
                        self:touchSlide(slideIndex);
                        self:showLF(slideIndex);
                    end

                    return;
                end);
            return true;
        end
    end);

    self.you:setTouchEnabled(true);
    self.you:addTouchEventListener(function(event, x, y)
        if event == "began" then
            transition.fadeIn(self.zuo,{time = 0.1});
            if slideIndex<=4 then
                BourceEffectJieshao(self.you,function()
                    moveSlide(self.slide,0,0.4);
                    slideIndex = slideIndex + 1;
                    self:touchSlide(slideIndex);
                    return;
                end);
            end
        end
    end); 
end

function jieshao:touchSlide(slideIndex)
    self.p1:setTouchEnabled(false);
    self.p2:setTouchEnabled(false);
    self.p3:setTouchEnabled(false);
    self.p4:setTouchEnabled(false);
    self.p5:setTouchEnabled(false);
    local item = nil
    if slideIndex==1 then
        item = self.p1;
        self.pl1:setString("小美扮演灰姑娘,一个可怜的小女孩");
        transition.fadeOut(self.zuo,{time = 0});
        transition.fadeIn(self.you,{time = 0});
    end

    if slideIndex==2 then
        item = self.p2;
        self.pl1:setString("小识扮演王子,他是国王的儿子,深爱着灰姑娘");
        transition.fadeIn(self.zuo,{time = 0});
        transition.fadeIn(self.you,{time = 0});
    end

    if slideIndex==3 then
        item = self.p3;
        self.pl1:setString("噜噜扮演灰姑娘的后母,一个心肠狠毒的坏女人");
        transition.fadeOut(self.you,{time = 0});
        transition.fadeIn(self.zuo,{time = 0});
    end

    if slideIndex==4 then
        item = self.p4;
        self.pl1:setString("喵喵扮演仙女,拥有神奇的魔力");
        transition.fadeIn(self.zuo,{time = 0});
        transition.fadeIn(self.you,{time = 0});
    end

    if slideIndex==5 then
        item = self.p5;
        self.pl1:setString("汪汪扮演侍卫,他是王子身边的随从");
        transition.fadeOut(self.you,{time = 0});
        transition.fadeIn(self.zuo,{time = 0});
    end


    item:setTouchEnabled(true);
    posStart = 0;
    posMove = 0;
    slideStart = 0;
    slideY = 0;
    moveTotal = 0;
    item:addTouchEventListener(function(event, x, y)
        if event == "began" then
            slideStart,slideY= self.slide:getPosition();
            posStart = x;
            return true;
        end

        if event == "moved" then
            posMove = x - posStart;
            moveTotal = posMove;
            if math.abs(posMove)<200 then
                self.slide:setPosition(slideStart+posMove,slideY);
            else
                posMove = 199; 
            end
            return true;        
        end

        if event == "ended" then
            if math.abs(posMove)<200 and math.abs(posMove)>10 then
                self.slide:setPosition(slideStart,slideY);
            end
            if moveTotal<=-200 then
                if slideIndex <=4 then
                    slideIndex = slideIndex + 1;
                    moveSlide(self.slide,0,0.4);
                    self:touchSlide(slideIndex);
                    self:showLF(slideIndex);
                end  
            end
            if moveTotal>=200 then
                if slideIndex >=2 then
                    slideIndex = slideIndex - 1;
                    moveSlide(self.slide,1,0.4);
                    self:touchSlide(slideIndex);
                    self:showLF(slideIndex);
                end
            end
            return true;
        end
    end); 
end


--slide action:
function jieshao:showLF(slideIndex)
    if slideIndex==1 then
        transition.fadeOut(self.zuo,{time = 0});
        transition.fadeIn(self.you,{time = 0});
    end

    if slideIndex>=2 and slideIndex<=4 then
        transition.fadeIn(self.zuo,{time = 0});
        transition.fadeIn(self.you,{time = 0});
    end

    if slideIndex==5 then
        transition.fadeOut(self.you,{time = 0});
        transition.fadeIn(self.zuo,{time = 0});
    end
end



function moveSlide(button,type,time)
    local x, y = button:getPosition()
    if type==1 then
        transition.moveTo(button, {x = x + itemWidth, time = time / 2})
    end

    if type==0 then
        transition.moveTo(button, {x = x - itemWidth, time = time / 2})
    end
end



--bource effect:
function BourceEffectJieshao(button,cb)
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

return jieshao
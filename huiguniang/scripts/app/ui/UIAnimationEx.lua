local UIAnimationEx = {}

function UIAnimationEx:animationAddTouchEvent(target, listener, scale)
    local m_scale = scale or 1

    target:setTouchEnabled(true)
    local m_rect = target:getContentSize()
    target:setCascadeBoundingBox(cc.rect(-m_rect.width/2, -m_rect.height/2, m_rect.width, m_rect.height))

    target:addTouchEventListener(function(event, x, y)
        if event == "began" then
            target:setScale(m_scale)
            return true
        end

        local touchInTarget = target:getCascadeBoundingBox():containsPoint(CCPoint(x, y))
        if event == "moved" then
            if touchInTarget then
                target:setScale(m_scale)
            else
                target:setScale(1)
            end
        elseif event == "ended" then
            if touchInTarget then listener(target) end
            target:setScale(1)
        else
            target:setScale(1)
        end
    end)
end

function UIAnimationEx:roleAnimationAddTouchEvent(parent, listener)
    parent:setTouchEnabled(true);
    local m_Height = parent:getContentSize().height;
    local m_Width = parent:getContentSize().width;
    parent:setCascadeBoundingBox(cc.rect(-m_Width/2, -m_Height/2, m_Width, m_Height));
    parent:addTouchEventListener(function(event, x, y)
    	if event == "began" then
            return true
        end

        local touchInTarget = parent:getCascadeBoundingBox():containsPoint(CCPoint(x, y))
        if event == "moved" then
            -- do nothing
        elseif event == "ended" then
            if touchInTarget and audio.isMusicPlaying() ~= true then listener() end
        end
    end)
end

function UIAnimationEx:createAnimationWithArmature(name, pos, parent)
    pos = pos or CCPoint(display.cx, display.cy)
    local anim = CCNodeExtend.extend(CCArmature:create(name))
    anim:setAnchorPoint(CCPoint(0,0))
    anim:setPosition(pos)
    anim:addTo(parent)

    return anim
end

function UIAnimationEx:playAnim(obj, anim, loop)
    local animation = obj:getAnimation()
    if animation ~= nil then
        animation:setAnimationScale(24 / 60) -- Flash fps is 24, cocos2d-x is 60
        looptag = loop == true and 1 or 0
        animation:play(anim, -1, -1, looptag, 0)
    end
end

function UIAnimationEx:playAnimationWithDelay(scene, target, animname, delay)
    delay = delay or 0

    if target == nil then print "Target Can not Be Nil!(UIAnimationEx.lua 69)" return end

    local animation = target:getAnimation()
    if animation ~= nil then
        animation:setAnimationScale(24 / 60) -- Flash fps is 24, cocos2d-x is 60
        scene:performWithDelay(function () animation:play(animname) end, delay)
    end
end

function UIAnimationEx:playAnimaForever(datatable)
    local duration  = datatable["duration"]
    local scene     = datatable["scene"]
    local obj       = datatable["obj"]
    local name      = datatable["name"]
    
    if scene == nil then return end
    if obj == nil then return end

    self:playAnim(obj, name)

    scene:performWithDelay(function()
        self:playAnimaForever(datatable)
    end, duration)
end

return UIAnimationEx
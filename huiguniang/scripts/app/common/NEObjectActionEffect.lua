-- NEObjectActionEffect.lua
-- Created by sddz_yuxiaohua@corp.netease.com
-- on 14-03-28

local NEObjectActionEffect = {}

-- 左右旋转一定角度
-- 参数
-- @parent 	旋转的目标对象
-- @angel 	旋转角度
-- @anchor 	锚点
function NEObjectActionEffect:RotateWithParentandAngle(parent, angle, anchor)
	-- 目标不可以为空对象
	if parent == nil then
		return
	end

	-- 设置锚点
	local anchorpoint = anchor or CCPoint(0.5, 0)
	parent:setAnchorPoint(anchorpoint)

	-- 设置可以触摸
	parent:setTouchEnabled(true)

	-- 添加触摸监听
	parent:addTouchEventListener(function(event, x, y)
        if event == "began" then
            local durtime = 0.2
            local action_1 = transition.rotateTo(parent, {rotate = angle, time = durtime})
            local action_2 = transition.rotateTo(parent, {rotate = -angle, time = durtime})
            local action_3 = transition.rotateTo(parent, {rotate = 0, time = durtime})

            local sequence = transition.sequence({action_1, action_2, action_3})
            parent:runAction(sequence)

            return true 
        end
    end)
end

-- 目标对象抖动效果
-- 参数
-- @parent 	抖动的目标对象
-- @anchor 	锚点
function NEObjectActionEffect:Shake(parent, onComplete, anchor)
	-- 目标不可以为空对象
	if parent == nil then
		return
	end

	-- 设置锚点
	local anchorpoint = anchor or CCPoint(0.5, 0)
	parent:setAnchorPoint(anchorpoint)

	-- 设置可以触摸
	parent:setTouchEnabled(true)

	-- 添加触摸监听
	parent:addTouchEventListener(function(event, x, y)
        if event == "began" then
        	self:Bource(parent, onComplete)
        	return true 
        end
    end)
end

-- 目标对象抖动效果
-- 参数
-- @parent 	抖动的目标对象
-- @cb 		回调Block
function NEObjectActionEffect:Bource(button,cb)
	local function zoom1(offset, time, completeblock)
        local x, y = button:getPosition()
        local size = button:getContentSize()

        local scaleX = button:getScaleX() * (size.width + offset) / size.width
        local scaleY = button:getScaleY() * (size.height - offset) / size.height

        transition.moveTo(button, {y = y - offset, time = time})
        transition.scaleTo(button, {
            scaleX     = scaleX,
            scaleY     = scaleY,
            time       = time,
            onComplete = completeblock,
        })
    end

    local function zoom2(offset, time, completeblock)
            local x, y = button:getPosition()
            local size = button:getContentSize()

            transition.moveTo(button, {y = y + offset, time = time / 2})
            transition.scaleTo(button, {
                scaleX     = 1.0,
                scaleY     = 1.0,
                time       = time,
                onComplete = completeblock,
            })
    end

    zoom2(0,0.2,function() 
        zoom1(10,0.2,function()
            zoom2(10,0.2,function()
            	if cb ~= nil then
            		cb()
            	end
            end)
        end)
    end);
end

function NEObjectActionEffect:BourceOutIn(obj, callback)
    -- print(obj:getAnchorPoint().x, obj:getAnchorPoint().y)
    local m_size = obj:getContentSize()

    if obj:getAnchorPoint().y ~= 0 then
        obj:setPosition(obj:getPositionX(), obj:getPositionY() + (0 - obj:getAnchorPoint().y) * m_size.height)
        obj:setAnchorPoint(CCPoint(0.5, 0))
    end

    local offset_y = 80

    -- 动作1
    transition.scaleTo(obj, {
        scaleX     = 1.2,
        scaleY     = 0.8,
        time       = 0.2,
        onComplete = function()
            -- 动作2
            transition.scaleTo(obj, {scaleX = 0.9, scaleY = 1.1, time = 0.2})
            transition.moveTo(obj,  {
                y           = obj:getPositionY() + offset_y,
                time        = 0.2,
                onComplete  = function()
                    -- 动作3
                    transition.moveTo(obj, {y = obj:getPositionY() - offset_y, time = 0.2})
                    transition.scaleTo(obj,{
                        scaleX     = 1.2,
                        scaleY     = 0.8,
                        time       = 0.2,
                        onComplete = function()
                            -- 动作4
                            transition.scaleTo(obj, {scaleX = 1, scaleY = 1, time = 0.2})

                            -- 回调
                            if callback ~= nil then
                                callback()
                            end
                        end,
                    })
                end,
            })
        end,
    })
end

function NEObjectActionEffect:MoveUpandDown(scene, obj, offset, duration)
    scene:performWithDelay(function()
        transition.moveTo(obj, {y = obj:getPositionY() + offset, time = duration})
        self:MoveUpandDown(scene, obj, -offset, duration)
    end, duration)
end

function NEObjectActionEffect:rotateForever(obj, duration, delaytime)
    if obj == nil then return end

    transition.execute(
        obj,
        CCRotateBy:create(duration,360),
        {
            delay = delaytime or 0,
            onComplete = function() self:rotateForever(obj, duration, delaytime) end
        }) 
end

return NEObjectActionEffect
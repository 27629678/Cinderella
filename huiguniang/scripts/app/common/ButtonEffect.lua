local ButtonEffect = {}
--local array = CCArray:create()

function ButtonEffect:BourceEffectCommon(button,cb)
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
    local nodeTables = {};
    gamelayer1 = display.newLayer();
    gamelayer2 = display.newLayer();
    table.insert(nodeTables,gamelayer1);
    table.insert(nodeTables,gamelayer2);
    --local nodeTables = {gamelayer1,gamelayer2};
    for i,v in ipairs(nodeTables) do 
    	print(i)
    	print(v)
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

return ButtonEffect;
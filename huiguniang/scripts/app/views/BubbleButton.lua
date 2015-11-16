
local BubbleButton = {}

-- create bubble button
function BubbleButton.new(params)
    local button -- pre-reference


    --button = ui.newImageMenuItem(params)
    button = display.newSprite(params.image, params.x, params.y)

    button.bubble = function()
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

        zoom1(40, 0.08, function()
            zoom2(40, 0.09, function()
                zoom1(20, 0.10, function()
                    zoom2(20, 0.11, function()
                      
                    end)
                end)
            end)
        end) 
    end
    return button
end

return BubbleButton

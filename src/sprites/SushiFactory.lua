import "const"

--- @class SushiFactory
SushiFactory = {}
class("SushiFactory", {}).extends()

local sushiList
local produceTime = BASE_PRODUCE_TIME
local consumeTime = 8000
local produceTimer

function SushiFactory:init(size)
    self.produceTime = BASE_PRODUCE_TIME / GAME_SPEED
    self.produceTime = 8000 / GAME_SPEED
    sushiList = table.create(size, 0)
    for _ = 1, size do
        local sushi = Sushi(math.random(#Assets.img.sushiImg))
        table.insert(sushiList, sushi)
    end
end

local function consume(sushi)
    sushi:reset()
    table.insert(sushiList, sushi)
end

function SushiFactory:produce()
    local sushi = table.remove(sushiList)
    sushi:add()
    playdate.timer.new(consumeTime, consume, sushi)
    playdate.timer.new(produceTime, SushiFactory.produce)
    sushi:setCollisionsEnabled(true)
end

function SushiFactory:start()
    if not self.produceTimer then
        self.produceTimer = playdate.timer.new(produceTime, SushiFactory.produce)
    else
        self.produceTimer:start()
    end
end

function SushiFactory:stop()
    if self.produceTimer then
        self.produceTimer:pause()
    end
end

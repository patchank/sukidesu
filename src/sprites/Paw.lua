local gfx <const> = playdate.graphics

--- @class Paw : playdate.graphics.sprite
Paw = {}
class("Paw", {}).extends(gfx.sprite)

local closedPawImg <const> = gfx.image.new(Assets.closedPaw)
assert(closedPawImg)
local openPawImg <const> = gfx.image.new(Assets.openPaw)
assert(openPawImg)

local meowSound, err = playdate.sound.sampleplayer.new(Assets.meowSound)
assert(meowSound)

local state = CLOSED_PAW

local sushi

function Paw:init()
    Paw.super.init(self, closedPawImg)
    self.state = CLOSED_PAW
    self:setCollideRect(0, 0, 30, 150)
    self:setZIndex(10)
    self:add()
end

function Paw:open()
    self:setImage(openPawImg)
    self.state = OPEN_PAW
    if self.sushi then
        self.sushi:throw()
        self.sushi = nil
    end
end

function Paw:close()
    self:setImage(closedPawImg)
    self.state = CLOSED_PAW
end

function Paw:setSushi(newSushi)
    self.sushi = newSushi
end

function Paw:releaseSushi()
    meowSound:play(1)
    if self.sushi then
        self.sushi:throw()
        meowSound:play(1)
    end
end

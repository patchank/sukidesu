local gfx <const> = playdate.graphics

--- @class Band : playdate.graphics.sprite
Band = {}
class("Band", { flipDirection = gfx.kImageUnflipped }).extends(gfx.sprite)

local bandTable <const> = gfx.imagetable.new(Assets.band)
local bandAnimation <const> = gfx.animation.loop.new(10, bandTable, true)

function Band:init(flip)
    Band.super.init(self)
    self.imagetable = bandTable
    self.animation = bandAnimation
    self.animation.delay = 100 / GAME_SPEED
    self.flipDirection = flip
    self:setZIndex(9)
end

function Band:update()
    Band.super.update(self)
    self:setImage(self.animation:image(), self.flipDirection)
end

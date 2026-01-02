local gfx <const> = playdate.graphics

--- @class Celebration : playdate.graphics.sprite
Celebration = {}
class("Celebration", {}).extends(gfx.sprite)

function Celebration:init(imgTable)
    Celebration.super.init(self)
    self.imagetable = imgTable
    self.animation = gfx.animation.loop.new(30, imgTable, true)
    self:setZIndex(50)
end

local function hide(s)
    s:remove()
end

function Celebration:show(x, y)
    self:moveTo(x, y)
    self:add()
    playdate.timer.new(500, hide, self)
end

function Celebration:update()
    Celebration.super.update(self)
    self:setImage(self.animation:image())
end

local gfx <const> = playdate.graphics

--- @class Shuriken : playdate.graphics.sprite
Shuriken = {}
class("Shuriken", {}).extends(gfx.sprite)

local shurikenTable <const> = gfx.imagetable.new(Assets.shuriken)
assert(shurikenTable)
local shurikenAnimation <const> = gfx.animation.loop.new(50, shurikenTable, true)

local state = SHURIKEN_HIDDEN
local angle

function Shuriken:init()
    Shuriken.super.init(self)
    self.imagetable = shurikenTable
    self.animation = shurikenAnimation
    self:setCollideRect(0, 0, 20, 20)
end

function Shuriken:reset()
    self.state = SHURIKEN_HIDDEN
    self.x = 200
    self.y = 120
    self:setCollisionsEnabled(true)
    self:remove()
end

function Shuriken:hit()
    self:remove()
    self:reset()
    if Score.hit() == 0 then
        GLOBAL_GAME_STATE = GAME_END
    end
end

function Shuriken:throw(targetX, targetY)
    local a = targetX - 200
    local b = targetY - 120
    local c = math.sqrt(a * a + b * b)
    self.angle = math.acos(a / c)
    self.state = SHURIKEN_FLYING
    self:setCollisionsEnabled(true)
end

function Shuriken:update()
    Shuriken.super.update()
    if (self.state == SHURIKEN_FLYING) then
        self:setImage(self.animation:image())
        local targetX = self.x + 2 * GAME_SPEED * math.cos(self.angle)
        local targetY = self.y + 2 * GAME_SPEED * math.sin(self.angle)
        local _, _, collisions, numberOfCollisions = self:checkCollisions(targetX, targetY)
        if (numberOfCollisions > 0) then
            local collision = collisions[1]
            if (collision.other.class == Paw) then
                self:hit()
                collision.other:releaseSushi()
            end
        else
            self:moveWithCollisions(targetX, targetY)
        end
    end
end

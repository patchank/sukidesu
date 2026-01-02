local gfx <const> = playdate.graphics

--- @class Cat : playdate.graphics.sprite
Cat = {}
class("Cat", { x = 200 }).extends(gfx.sprite)

local catHeadImg <const> = gfx.image.new(Assets.catHead)
local x = 200
local pawy = 220
local lastCrankPosition = 180
local paw
local exposure = 0

function Cat:init()
    Cat.super.init(self, catHeadImg)
    self.exposure = 0
    self.paw = Paw()
    self:moveTo(x, 220)
    self:add()
end

function Cat:update()
    Cat.super.update()
    local isLeftButtonPressed = playdate.buttonIsPressed(playdate.kButtonLeft)
    local isRightButtonPressed = playdate.buttonIsPressed(playdate.kButtonRight)
    local isBButtonJustPressed = playdate.buttonJustPressed(playdate.kButtonB)
    local isBButtonJustReleased = playdate.buttonJustReleased(playdate.kButtonB)
    local crankPosition = math.abs(playdate.getCrankPosition() - 180)
    local changed = false

    if (self.lastCrankPosition ~= crankPosition) then
        self.lastCrankPosition = crankPosition
        self.pawy = 300 - crankPosition / 1.3
        changed = true
    end
    if crankPosition < 20 then
        self.exposure = 0
    else
        self.exposure += GAME_SPEED * (crankPosition / 180)
    end

    if (isLeftButtonPressed and self.x > 70) then
        self.x -= GAME_SPEED * 2
        changed = true
    elseif (isRightButtonPressed and self.x < 330) then
        self.x += GAME_SPEED * 2
        changed = true
    end

    if isBButtonJustPressed then
        self.paw:open()
        changed = true
    elseif isBButtonJustReleased then
        self.paw:close()
        changed = true
    end


    if changed then
        self:moveTo(self.x, 220)
        if (self.x > 200) then
            self:movePaw(self.x + 50, self.pawy, isBButtonJustReleased)
        else
            self:movePaw(self.x - 50, self.pawy, isBButtonJustReleased)
        end
    end
end

function Cat:movePaw(newX, newY, isBButtonJustReleased)
    local _, _, collisions, numberOfCollisions = self.paw:checkCollisions(newX, newY)
    if (numberOfCollisions > 0) then
        local collision = collisions[1]
        if (collision.other.class == Sushi) then
            local sushi = collision.other
            if (self.paw.state == CLOSED_PAW) then
                if (isBButtonJustReleased) then
                    sushi:catch(self.paw)
                else
                    sushi:throw()
                end
            end
        end
    end
    self.paw:moveTo(newX, newY)
end

function Cat:hide()
    self:remove()
    self.paw:remove()
end

function Cat:show()
    self:add()
    self.paw:add()
end

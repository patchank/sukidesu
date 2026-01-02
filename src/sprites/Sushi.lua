local gfx <const> = playdate.graphics

--- @class Sushi : playdate.graphics.sprite
Sushi = {}
class("Sushi", { side = LEFT_BAND, state = S_ON_BAND }).extends(gfx.sprite)

local paw
local index

function Sushi:init(i)
    self.index = i
    Sushi.super.init(self, Assets.img.sushiImg[i])
    self:setZIndex(5)
    self:setCollideRect(0, 0, 30, 30)
    self.state = S_ON_BAND
    if (math.random() > 0.5) then
        self.side = RIGHT_BAND
        self.x = RIGHT_BAND_X_START
    else
        self.side = LEFT_BAND
        self.x = LEFT_BAND_X_START
    end
end

function Sushi:reset()
    self:setCollisionsEnabled(false)
    self.state = S_ON_BAND
    self.y = 100
    self:remove()
    if (math.random() > 0.5) then
        self.side = RIGHT_BAND
        self.x = RIGHT_BAND_X_START
    else
        self.side = LEFT_BAND
        self.x = LEFT_BAND_X_START
    end
end

function Sushi:catch(paw)
    self.state = S_CAUGHT
    self.paw = paw
    paw:setSushi(self)
    self:setCollisionsEnabled(false)
end

function Sushi:throw()
    self.state = S_THROWN
    self:setCollisionsEnabled(false)
end

function Sushi:update()
    Sushi.super.update()
    if (self.state == S_ON_BAND) then
        if (self.side == RIGHT_BAND) then
            self.x += GAME_SPEED
        else
            self.x -= GAME_SPEED
        end
        self:moveTo(self.x, 100)
    elseif self.state == S_CAUGHT then
        if self.paw.y > 290 then -- at the bottom of the screen scores
            self:reset()
            Score.update(SUSHI_SCORE[self.index])

            local newScore, _, pieces = Score.read()

            if math.fmod(pieces, 5) == 0 then
                GAME_SPEED += 1
                GLOBAL_playMusic:setRate(1 + GAME_SPEED / 5)
            end
        else
            self:moveTo(self.paw.x, self.paw.y - 70)
        end
    elseif self.state == S_THROWN then
        self.y += GAME_SPEED * 2
        self:moveTo(self.x, self.y)
    end
end

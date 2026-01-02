local gfx <const> = playdate.graphics

--- @class Itamae : playdate.graphics.sprite
Itamae = {}
class("Itamae", {}).extends(gfx.sprite)

local itamaeTable <const> = gfx.imagetable.new(Assets.itamae)
assert(itamaeTable)
local itamaeAnimation <const> = gfx.animation.loop.new(10, itamaeTable, true)
local cat
local state
local shooSound, err = playdate.sound.sampleplayer.new(Assets.shooSound)
assert(shooSound)
local shooImg = playdate.graphics.sprite.new(gfx.image.new(Assets.shooImg))
shooImg:moveTo(250, 25)

function Itamae:init(newCat)
    Itamae.super.init(self)
    self.imagetable = itamaeTable
    self.animation = itamaeAnimation
    self.animation.delay = 50 / GAME_SPEED
    self.state = ITAMAE_COOKING
    self.cat = newCat
    self:setZIndex(-100)
    self:moveTo(182, 70)
    self:add()
end

function Itamae:hide()
    self:remove()
end

function Itamae:show()
    self:add()
end

function Itamae:finishAttack(shuriken)
    if shuriken then
        shuriken:remove()
    end
    self.state = ITAMAE_COOKING
end

function Itamae:update()
    Itamae.super.update(self)

    if (self.cat.exposure > 20 and self.state ~= ITAMAE_ATTACKING) then
        local shuriken
        local _, _, pieces = Score.read()
        if pieces > 1 then
            shuriken = Shuriken()
            shuriken:moveTo(200, 120)
            shuriken:add()
            shuriken:throw(self.cat.paw.x, self.cat.paw.y)
            self.produceTimer = playdate.timer.new(4000 / GAME_SPEED, Itamae.finishAttack, self, shuriken)
        end
        shooSound:play()
        shooImg:add()
        self.produceTimer = playdate.timer.new(500, Itamae.finishShoo)
        self.produceTimer = playdate.timer.new(4000 / GAME_SPEED, Itamae.finishAttack, self, shuriken)
        self.state = ITAMAE_ATTACKING
    end
    self:setImage(self.animation:image())
end

function Itamae:finishShoo()
    shooImg:remove()
end

local gfx <const> = playdate.graphics

--- @class HomeScreen : playdate.graphics.sprite
HomeScreen = {}
class("HomeScreen", {}).extends(gfx.sprite)

local HomeScreenTable <const> = gfx.imagetable.new(Assets.homeScreen)
local HomeScreenAnimation <const> = gfx.animation.loop.new(70, HomeScreenTable, true)
local textSprite = gfx.sprite.spriteWithText("a", 200, 100)
local topScoreSprite = gfx.sprite.spriteWithText("a", 200, 100)
local gameTitle = playdate.graphics.sprite.new(gfx.image.new(Assets.gameTitle))
local welcomeMusic, err = playdate.sound.fileplayer.new(Assets.welcomeMusic)
local isCrankDown = false

function HomeScreen:init(flip)
    HomeScreen.super.init(self)
    self.imagetable = HomeScreenTable
    self.animation = HomeScreenAnimation
    local crankPosition = playdate.getCrankPosition()
    self.isCrankDown = not (crankPosition > 170 and crankPosition < 190)
    self:moveTo(100, 190)
    textSprite:moveTo(300, 150)
    gameTitle:moveTo(240, 80)
    self:updateTopScore()
    self:add()
    welcomeMusic:play(0)
end

function HomeScreen:updateTopScore()
    local textImage = gfx.image.new(200, 100)
    gfx.pushContext(textImage)
    gfx.drawTextInRect("Top Score: " .. Score.getTopScore(), 0, 0, 200, 100, nil, nil, kTextAlignment.left)
    gfx.popContext()
    topScoreSprite:setImage(textImage)
    topScoreSprite:moveTo(370, 70)
end

function HomeScreen:hide()
    self:remove()
    textSprite:remove()
    gameTitle:remove()
    topScoreSprite:remove()
    welcomeMusic:stop()
end

function HomeScreen:show()
    local crankPosition = playdate.getCrankPosition()
    self.isCrankDown = not (crankPosition > 170 and crankPosition < 190)
    self:add()
    textSprite:add()
    gameTitle:add()
    self:updateTopScore()
    topScoreSprite:add()
    welcomeMusic:play(0)
end

function HomeScreen:changeInstructions(newText)
    local textImage = gfx.image.new(250, 100)
    gfx.pushContext(textImage)
    gfx.drawTextInRect(newText, 0, 0, 200, 100, nil, nil, kTextAlignment.left)
    gfx.popContext()
    textSprite:setImage(textImage)
end

function HomeScreen:isReadyToStart()
    return self.isCrankDown
end

function HomeScreen:update()
    HomeScreen.super.update(self)
    self:setImage(self.animation:image())

    local crankPosition = playdate.getCrankPosition()
    if (crankPosition < 170 or crankPosition > 190) then
        if self.isCrankDown then
            self:changeInstructions(gfx.getLocalizedText("homeCrankDown"))
            self.isCrankDown = false
        else
            self.isCrankDown = false
        end
    end
    if (crankPosition > 170 and crankPosition < 190) then
        if not self.isCrankDown then
            self:changeInstructions(gfx.getLocalizedText("homePressA"))
            self.isCrankDown = true
        else
            self.isCrankDown = true
        end
    end
end

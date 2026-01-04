import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"
import "CoreLibs/math"
import "CoreLibs/ui"

import "assets"
import "sprites"
import "const"
import "Score"
import "HomeScreen"

-- setup environment
local gfx <const> = playdate.graphics
local fontDefault <const> = gfx.getFont()
GLOBAL_GAME_STATE = GAME_STOP

-- main screen
local homeScreen = HomeScreen()

-- game elements
local rightBand = Band(gfx.kImageUnflipped)
rightBand:moveTo(RIGHT_BAND_X_START + BAND_LENGTH / 2.5, BAND_Y)
local leftBand = Band(gfx.kImageFlippedX)
leftBand:moveTo(LEFT_BAND_X_START - BAND_LENGTH / 2.5, BAND_Y)

local gameOverMsg = playdate.graphics.sprite.new(gfx.image.new(Assets.gameOverMsg))
gameOverMsg:moveTo(200, 120)
--gameOverMsg:setZIndex(100)
GLOBAL_playMusic = playdate.sound.fileplayer.new(Assets.playMusic)

local cat = Cat()
local itamae = Itamae(cat)
local sushiFactory = SushiFactory(10)
Score:new()


-- print instructions in system menu
function playdate.gameWillPause()
    local sysMenuImg = playdate.graphics.image.new("assets/tinyCat")
    local menuImg = gfx.image.new(400, 240, gfx.kColorWhite)
    gfx.pushContext(menuImg)
    local myFont = gfx.font.new("assets/Nontendo-Light")
    gfx.setFont(myFont)
    gfx.drawTextInRect(gfx.getLocalizedText("sysMenuInstructions"), 5, 5, 190, 235, nil, nil, kTextAlignment.left)
    sysMenuImg:draw(155, 210)
    gfx.popContext()
    playdate.setMenuImage(menuImg)
end

local function init()
    playdate.graphics.sprite.removeAll()
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            if GLOBAL_GAME_STATE == GAME_PLAY then
                Assets.img.background:draw(0, 0)
            end
        end
    )
    sushiFactory:stop()
    cat:hide()
    itamae:hide()
    GLOBAL_GAME_STATE = GAME_STOP
    homeScreen:show()
end

-- add reset top score to system menu
local menu = playdate.getSystemMenu()
local menuItem, error = menu:addMenuItem("Reset top score", function()
    Score.resetTopScore()
    init()
end)

local function gameStart()
    homeScreen:hide()
    rightBand:add()
    leftBand:add()
    cat:show()
    itamae:show()
    sushiFactory:start()
    Score.reset()
    GLOBAL_playMusic:setVolume(2)
    GLOBAL_playMusic:play(0)
    GLOBAL_GAME_STATE = GAME_PLAY
    GAME_SPEED = 1
end

function playdate.update()
    gfx.sprite.update()
    if GLOBAL_GAME_STATE == GAME_STOP then
        if playdate.buttonJustPressed(playdate.kButtonA) and homeScreen:isReadyToStart() then
            gameStart()
        end
    elseif GLOBAL_GAME_STATE == GAME_PLAY then
        playdate.timer.updateTimers()
        fontDefault:drawTextAligned(tostring(Score.read()), 390, 8, kTextAlignment.right)
    elseif GLOBAL_GAME_STATE == GAME_END then
        sushiFactory:stop()
        cat:hide()
        GLOBAL_playMusic:stop()
        playdate.graphics.sprite.removeAll()
        gameOverMsg:add()
        local finalScoreSprite = gfx.sprite.spriteWithText("Your score: " .. Score.read(), 185, 89)
        finalScoreSprite:moveTo(200, 145)
        finalScoreSprite:add()
        GLOBAL_GAME_STATE = GAME_OVER

        if Score.read() > Score.getTopScore() then
            Score.updateTopScore()
        end
    elseif GLOBAL_GAME_STATE == GAME_OVER then
        if (playdate.buttonJustPressed(playdate.kButtonA)) then
            init()
        end
    end
    if playdate.isCrankDocked() then
        playdate.ui.crankIndicator:draw()
    end
end

init()

local gfx <const> = playdate.graphics

local score = 0
local pieces = 0
local catLifeImg <const> = gfx.image.new(Assets.catLife)
local lives = table.create(3, 0)
local remainingLives = 3
local topScore = 0

Score = {}

local savedScore = playdate.datastore.read("topScore")
if savedScore then
    topScore = savedScore.topScore
else
    local gameData = { topScore = 0 }
    playdate.datastore.write(gameData, "topScore")
    topScore = 0
end

function Score:new()
    for i = 1, 3 do
        table.insert(lives, playdate.graphics.sprite.new(catLifeImg))
        lives[i]:moveTo(30 * i, 15)
    end
    remainingLives = 3
    return self
end

function Score.read()
    return score, remainingLives, pieces
end

function Score.update(increment)
    score += increment
    pieces += 1
end

function Score.reset()
    score = 0
    pieces = 0
    remainingLives = 3
    for i = 1, 3 do
        lives[i]:add()
    end
end

function Score.hit()
    lives[remainingLives]:remove()
    remainingLives -= 1
    return remainingLives
end

function Score.getTopScore()
    return topScore
end

function Score.updateTopScore()
    local gameData = { topScore = score }
    playdate.datastore.write(gameData, "topScore")
    topScore = score
end

function Score.resetTopScore()
    local gameData = { topScore = 0 }
    playdate.datastore.write(gameData, "topScore")
    topScore = 0
end

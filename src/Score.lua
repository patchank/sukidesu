local gfx <const> = playdate.graphics

local score = 0
local pieces = 0
local catLifeImg <const> = gfx.image.new(Assets.catLife)
local lives = table.create(3, 0)
local remainingLives = 3
local topScore = 0
local currentCombo = { index = 0, count = 0 }

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
    currentCombo = { index = 0, count = 0 }
    return self
end

function Score.read()
    return score, remainingLives, pieces
end

function Score.update(index) -- returns score info (currently only informs if it's a combo or not)
    score += SUSHI_SCORE[index]
    pieces += 1
    if (currentCombo.index == index) then
        currentCombo.count += 1
        if currentCombo.count == 3 then
            score += SUSHI_SCORE[index] * 2
            currentCombo.count = 0
            return { combo = true }
        end
    else
        currentCombo.index = index
        currentCombo.count = 1
    end
    return { combo = false }
end

function Score.reset()
    score = 0
    pieces = 0
    remainingLives = 3
    for i = 1, 3 do
        lives[i]:add()
    end
    currentCombo = { index = 0, count = 0 }
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

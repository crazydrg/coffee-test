import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics
local titleImage = gfx.image.new("title.png")
local currentScreen = "title" -- State variable to track the current screen
local transitionProgress = 0 -- Variable to track transition progress
local transitionSpeed = 5 -- Speed of the transition, increased for faster effect
local countdown = 5 -- Countdown from 5 to 1
local countdownTimer = nil -- Timer for the countdown
local gameTimer = nil -- Timer for the 60-second countdown

function playdate.update()
    gfx.clear() -- Clear the screen

    if currentScreen == "title" then
        if titleImage == nil then
            print("Failed to load title.png. Please check if the file is in the correct directory and named correctly.")
        else
            gfx.setImageDrawMode(gfx.kDrawModeCopy) -- Default drawing mode for the image
            titleImage:draw(15, -65) -- Adjust the coordinates to center the image
        end

        gfx.setImageDrawMode(gfx.kDrawModeFillWhite) -- Set the draw mode to fill with white for text
        gfx.setFont(gfx.getSystemFont()) -- Use system font
        gfx.setColor(gfx.kColorWhite) -- Set text color to white

        gfx.drawText("Press A to Start", 140, 180) -- Adjusted coordinates for a more centered, lower position

    elseif currentScreen == "transition" then
        transitionProgress = transitionProgress + transitionSpeed

        gfx.setImageDrawMode(gfx.kDrawModeCopy)

        -- Move the title screen out
        if titleImage ~= nil then
            titleImage:draw(15 - transitionProgress, -65) -- Swipe the title image left
        end

        gfx.drawText("Press A to Start", 140 - transitionProgress, 180) -- Swipe the text left

        -- Center Coffee Shop Text
        gfx.drawText("Welcome to the Coffee Shop!", 100 + (transitionProgress / 2), 120) -- Slide in the coffee shop screen

        if transitionProgress >= 400 then -- Once the transition is done, switch to the coffee shop
            currentScreen = "countdown"
            transitionProgress = 0 -- Reset transition progress for the next screen
            countdownTimer = playdate.timer.keyRepeatTimerWithDelay(0, 1000, function()
                countdown = countdown - 1
                if countdown <= 0 then
                    currentScreen = "game"
                    countdown = 5 -- Reset countdown for next use
                    countdownTimer:remove() -- Remove the countdown timer
                    gameTimer = playdate.timer.new(60000, function() print("Game over!") end)
                end
            end)
        end

    elseif currentScreen == "countdown" then
        gfx.drawText("Welcome to the Coffee Shop!", 100, 120)
        gfx.drawText(tostring(countdown), 200, 160)

    elseif currentScreen == "game" then
        if gameTimer ~= nil then
            local remainingTime = math.floor((gameTimer.duration - gameTimer.timeElapsed) / 1000)
            gfx.drawText("Time: " .. tostring(remainingTime), 10, 10)
        end
    end

    playdate.timer.updateTimers()
end

function playdate.AButtonDown()
    if currentScreen == "title" then
        currentScreen = "transition" -- Start transition to the coffee shop screen
    end
end
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics
local titleImage = gfx.image.new("title.png")
local currentScreen = "title" -- State variable to track the current screen
local transitionProgress = 0 -- Variable to track transition progress
local transitionSpeed = 5 -- Speed of the transition, increased for faster effect
local countdown = 5 -- Countdown from 5 to 1
local countdownTimer = nil -- Timer for the countdown
local gameTimer = nil -- Timer for the 60-second countdown

function playdate.update()
    gfx.clear() -- Clear the screen

    if currentScreen == "title" then
        if titleImage == nil then
            print("Failed to load title.png. Please check if the file is in the correct directory and named correctly.")
        else
            gfx.setImageDrawMode(gfx.kDrawModeCopy) -- Default drawing mode for the image
            titleImage:draw(15, -65) -- Adjust the coordinates to center the image
        end

        gfx.setImageDrawMode(gfx.kDrawModeFillWhite) -- Set the draw mode to fill with white for text
        gfx.setFont(gfx.getSystemFont()) -- Use system font
        gfx.setColor(gfx.kColorWhite) -- Set text color to white

        gfx.drawText("Press A to Start", 140, 180) -- Adjusted coordinates for a more centered, lower position

    elseif currentScreen == "transition" then
        transitionProgress = transitionProgress + transitionSpeed

        gfx.setImageDrawMode(gfx.kDrawModeCopy)

        -- Move the title screen out
        if titleImage ~= nil then
            titleImage:draw(15 - transitionProgress, -65) -- Swipe the title image left
        end

        gfx.drawText("Press A to Start", 140 - transitionProgress, 180) -- Swipe the text left

        -- Center Coffee Shop Text
        gfx.drawText("Welcome to the Coffee Shop!", 100 + (transitionProgress / 2), 120) -- Slide in the coffee shop screen

        if transitionProgress >= 400 then -- Once the transition is done, switch to the coffee shop
            currentScreen = "countdown"
            transitionProgress = 0 -- Reset transition progress for the next screen
            countdownTimer = playdate.timer.keyRepeatTimerWithDelay(0, 1000, function()
                countdown = countdown - 1
                if countdown <= 0 then
                    currentScreen = "game"
                    countdown = 5 -- Reset countdown for next use
                    countdownTimer:remove() -- Remove the countdown timer
                    gameTimer = playdate.timer.new(60000, function() print("Game over!") end)
                end
            end)
        end

    elseif currentScreen == "countdown" then
        gfx.drawText("Welcome to the Coffee Shop!", 100, 120)
        gfx.drawText(tostring(countdown), 200, 160)

    elseif currentScreen == "game" then
        if gameTimer ~= nil then
            local remainingTime = math.floor((gameTimer.duration - gameTimer.timeElapsed) / 1000)
            gfx.drawText("Time: " .. tostring(remainingTime), 10, 10)
        end
    end

    playdate.timer.updateTimers()
end

function playdate.AButtonDown()
    if currentScreen == "title" then
        currentScreen = "transition" -- Start transition to the coffee shop screen
    end
end

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/crank"
import "CoreLibs/timer"


local gfx <const> = playdate.graphics
local snd <const> = playdate.sound
local titleImage = gfx.image.new("title.png")
local currentScreen = "title"
local transitionProgress = 0
local transitionSpeed = 5
local showWelcome = true
local countdown = 5
local countdownTimer
local bgMusicPlaying = false
local stopCheckingMusic = false

-- Load your sound files
local bgMusic = snd.fileplayer.new("bg.wav")
local etSound = snd.fileplayer.new("et.wav")

function setup()
    if titleImage == nil then
        print("Failed to load title.png. Please check if the file is in the correct directory and named correctly.")
    end

    if bgMusic then
        print("Background music loaded")
        bgMusic:play()
        bgMusicPlaying = true
    else
        print("Failed to load bg.wav. Please check if the file is in the correct directory and named correctly.")
    end

    if etSound then
        print("Sound effect loaded")
    else
        print("Failed to load et.wav. Please check if the file is in the correct directory and named correctly.")
    end
end

function checkMusic()
    if not stopCheckingMusic and bgMusic and not bgMusic:isPlaying() and bgMusicPlaying then
        bgMusic:play()
    end
end

function startCountdown()
    showWelcome = false -- Hide the welcome message
    countdown = 5 -- Reset countdown
    countdownTimer = playdate.timer.new(1000, function()
        countdown = countdown - 1
        if countdown <= 0 then
            if bgMusic then
                bgMusic:stop() -- Stop the music
            end
            stopCheckingMusic = true -- Stop checking the music
            if countdownTimer then
                countdownTimer:remove() -- Stop timer when countdown reaches 0
            end
            currentScreen = "gameRoom" -- Transition to game room
        end
    end)
    countdownTimer.repeats = true -- Set the timer to repeat
end


function playdate.update()
    gfx.clear()

    if currentScreen == "title" then
        if titleImage then
            gfx.setImageDrawMode(gfx.kDrawModeCopy)
            titleImage:draw(15, -65)
        end

        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.setFont(gfx.getSystemFont())
        gfx.setColor(gfx.kColorWhite)
        gfx.drawText("Press A to Start", 140, 180)

    elseif currentScreen == "transition" then
        transitionProgress = transitionProgress + transitionSpeed

        gfx.setImageDrawMode(gfx.kDrawModeCopy)

        if titleImage then
            titleImage:draw(15 - transitionProgress, -65)
        end

        gfx.drawText("Press A to Start", 140 - transitionProgress, 180)

        local coffeeShopTextX = 100 + (400 - transitionProgress)
        gfx.drawText("Welcome to the Coffee Shop!", coffeeShopTextX, 120)

        if transitionProgress >= 400 then
            currentScreen = "coffeeShop"
            transitionProgress = 0
            playdate.timer.performAfterDelay(2000, startCountdown) -- Wait 2 seconds before starting countdown
        end

    elseif currentScreen == "coffeeShop" then
        if showWelcome then
            gfx.drawText("Welcome to the Coffee Shop!", 100, 120)
        else
            if countdown > 0 then
                gfx.drawText("Your shift starts in...", 120, 110)
                gfx.drawText(tostring(countdown), 200, 130)
            else
                gfx.drawText("Your shift starts now!", 120, 120)
                playdate.timer.performAfterDelay(1000, function()
                    currentScreen = "gameRoom" -- Transition to the game room
                end)
            end
        end

    elseif currentScreen == "gameRoom" then
        updateGameRoom()
    end

    playdate.timer.updateTimers() -- Make sure timers are updated
    checkMusic() -- Check if music is playing and restart if necessary
end

function playdate.AButtonDown()
    if currentScreen == "title" then
        if etSound then
            etSound:play()
            print("Sound effect played")
        end
        currentScreen = "transition"
    end
end

setup()

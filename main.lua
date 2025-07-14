--[[ 
Task One:
    As a programmer, your task is to bring the assets created by the other specialists together in
    a coherent manner. The program you write here needs to:
    - Display the art assets:
        You need a window set up with the dimensions 1280x720
        You need to be able to display the backgrounds
            The backgrounds you display will be named:
                Background_Main.png
                Background_Variation_1.png
                Background_Variation_2.png
            The backgrounds will be 1280x720
        You will need to be able to display the character art with dimensions 420x720 directly in the center
            The character art will be named:
                MC_Default.png
                MC_Shocked.png
                MC_Happy.png
                MC_Sad.png
                MC_Concerned.png
                MC_Fear.png
        All of these assets will be held under assets\art\
    - Play music:
        You will need to be ablee to play music of any length.
            The music will be named:
                Theme.wav
                Theme_Variation_1.wav
                Theme_Variation_2.wav
    - Tie it all together using the writer's story
        Writers will give you a txt file at 'assets\story.txt'
            In it, all dialogue box entries will be denoted with one double quote (") right at the start
            All actionable words (instruction to change the MC sprite, background art, or music) is denoted with a single asterik (*)
            The following are actionable words:
                *MC_Default
                *MC_Mad
                *MC_Shocked
                *MC_Happy
                *MC_Sad
                *MC_Concerned
                *MC_Fear
                *Background_1
                *Background_2
                *Background_3
                *Music_1
                *Music_2
                *Music_3
                *Music_None
                *Zoom - These next three are optional
                *Unzoom
                *Shake - Shake the character
            Ensure that an error in action wording/dialogue wording will not break your game
    - Add bonus features
        There are a few optional features you may choose to include:
            Music crossfade - Lower the volume of one song then raise the volume of the next
            Dialogue box crossfade
            Split long dialogue - Ensure that no matter how long the text, the dialogue box will be able to handle it without text escaping the box.
                This can be done at the start as you load the dialogue into an array. Check the strlength first, then sub accordingly
                As a bonus bonus challenge, only cut off the dialogue at a period or space so that two words dont span two messages

    For convencience, file tree is as follows:
        assets
            art
                Background_Main.png
                Background_Variation_1.png
                Background_Variation_2.png
                MC_Concerned.png
                MC_Default.png
                MC_Fear.png
                MC_Happy.png
                MC_Sad.png
                MC_Shocked.png
            music
                Music_1.mp3
                Music_2.mp3
                Music_3.mp3
            story.txt
        main.lua
]]

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Visual Novel!')
    loadText()
    require('dependencies')
    music['Music_1']:setLooping(true)
    music['Music_2']:setLooping(true)
    music['Music_3']:setLooping(true)
    love.audio.setVolume(.5)
    love.audio.setMixWithSystem(true)
end


io.input(love.filesystem.getSource()..'/assets/story.txt') -- Sets our story.txt as the input we read from using io
text = {} -- This array will store all of the lines from the text file so we don't have to read from it
function loadText() -- Loads all of the text from /assets/story.txt into the text array
    i = 1
    while true do
        line = io.read("*line")
        if line == nil then
            return
        else
            text[i] = line
            i = i+1
        end
    end
end


line_num = 0 -- The value we will be itterating through
display_dialogue = "" -- Initializing display_dialogue ensures love wont crash when display_dialogue is drawn before a new value is set
char_state = "Default" -- Initialized for the same reason as above
bg_state = 'Background_1' -- Initialized for the same reason as above
function nextLine()
    line_num = line_num + 1 -- Iterates to the next line (this can be done at the end instead of the beginning if you initialize line_num to 1, but I like having it here so I remember
    
    current_line = text[line_num]
    if current_line == nil then -- This is the end condition. Once you iterate through the entire array, text[line_num] will return nil and you will need to end the game
        love.event.quit()
    end

    line_type = string.sub(current_line, 1,1) -- grabs characters from 1 to 1 (so just the first character)
    if line_type == '*' then -- Checks if the line is an action, then checks which action it is
        current_line = string.lower(current_line) -- Simple method to make actions case insensitive
        if current_line == '*mc_default' then -- This can be done better, but for simplicity sake we will just use a long ifelse chain.
            char_state = 'Default'
        elseif current_line == '*mc_shocked' then
            char_state = 'Shocked'
        elseif current_line == '*mc_happy' then
            char_state = 'Happy'
        elseif current_line == '*mc_sad' then
            char_state = 'Sad'
        elseif current_line == '*mc_concerned' then
            char_state = 'Concern'
        elseif current_line == '*mc_fear' then
            char_state = 'Fear'
        elseif current_line == '*music_1' then
            love.audio.stop()
            music['Music_1']:play()
        elseif current_line == '*music_2' then
            love.audio.stop()
            music['Music_2']:play()
        elseif current_line == '*music_3' then
            love.audio.stop()
            music['Music_3']:play()
        elseif current_line == '*music_none' then
            love.audio.stop()
        elseif current_line == '*background_1' then
            bg_state = 'Background_1'
        elseif current_line == '*background_2' then
            bg_state = 'Background_2'
        elseif current_line == '*background_3' then
            bg_state = 'Background_3'
        end
        nextLine() -- Once we do the action, we want to read the next line until we display new dialogue
    elseif line_type == '"' then
        display_dialogue = string.sub(current_line, 2,-1) -- This removes the quote at the start and sets it as the display dialogue.
    end
end

function love.keypressed(key)
    if key == 'space' then
        nextLine()
    end
end

function love.update(dx)

end

function drawBackground()
    love.graphics.draw(bg[bg_state])
end

function drawCharacter()
    love.graphics.draw(mc[char_state], 430, 0)
end

grey = {31/255, 31/255, 31/255, .7}
function drawDialogue()
    love.graphics.setColor(grey)
    love.graphics.rectangle('fill', 10, 550, WINDOW_WIDTH-20, WINDOW_HEIGHT-560)
    love.graphics.setColor(1,1,1, 1)
    love.graphics.printf(display_dialogue, 20, 560, WINDOW_WIDTH-20)
end


function love.draw()
    drawBackground()
    drawCharacter()
    drawDialogue()
    -- Display entry out of entries
    love.graphics.print(string.format('%s / %s', line_num, tostring(#text)), 10, 30)
end
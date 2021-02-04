-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local json = require( "json" )
local widget = require( "widget" )
local H = require "H"

local scene = composer.newScene()

local filePath = system.pathForFile( "numerology.json", system.DocumentsDirectory )

-- variables 
local alphabet = 
{
    1,2,3,4,5,8,
    3,5,1,1,2,3,4,
    5,7,8,1,2,3,4,
    6,6,6,5,1,7 
};

local input
local output 
local content = nil

local function CalcRes()
    local sum = 0  
    
    local name = input.text 
    name = name:gsub('[%p%c%s]', '')
    name = name:gsub("%s+", "")
    name = name:lower()

    for i = 1,  #name
    do
        local c = name:sub(i,i)
        if(tonumber(c) ~= nil)then 
            sum = sum + tonumber(c) 
        else
            c = string.byte(c)-string.byte("a")+1
            sum = sum + alphabet[c];
        end
    end
    	
    output.text = "Number: " .. tostring( sum )

    if(content) then 
    	content.text = ""
    	content:removeSelf()
    	content = nil
    end

    return sum 
end

local function generateHoroscope()
	local sum = CalcRes()

	if(sum > 108 or sum < 0)then
		sum = 0 
	end

	content = native.newTextBox( display.safeActualContentWidth*0.5, 400, display.actualContentWidth, display.actualContentHeight*0.4)
	content.size = 14
	content.isEditable = false
	--content.hasBackground = false
	content.text = H[sum]

end

local function addToFavourite()
	local number = CalcRes()
	local name = input.text 
	local Saved = {}

	local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        Saved = json.decode( contents )
    end

    if(Saved == nil or #Saved == 0)then
		Saved = {}
	end

    for i = 1, #Saved do
		if (Saved[i].name == name ) then  
			return 
		end
    end

	if(Saved == nil or #Saved == 0)then
		Saved = {}
		table.insert(Saved, { name = name , number = number })
	else
		table.insert(Saved, 1, { name = name , number = number })
	end

	file = io.open( filePath, "w" )
 
    if file then
        file:write( json.encode( Saved ) )
        io.close( file )
    end


end



function scene:create( event )
	local sceneGroup = self.view

	input = native.newTextField(  display.contentCenterX, 50, 270, 50)
	--input.font = native.newFont( "Helvetica-Bold", 25)
	input.size = 20
	input.align = "center"
	input.placeholder = "Enter Name" 
	--input.hasBackground = false
	--input:setTextColor( 1, 0, 1 )
	input.isEditable = true

	output = display.newText( "", display.contentCenterX-70, display.contentCenterY-50, system.defaultFontBold, 20 )
	output:setFillColor( 0, 0, 0 )

--[[	content = display.newText( "", display.contentCenterX, display.contentCenterY+10, native.systemFont, 10)
	content:setFillColor( 0, 0, 0 )--]]
	
	local btn_Fav = widget.newButton {
        width = 100, -- this defines the width of the button
        height = 30, -- this defines the height of the button 
        defaultFile = "images/btn-blank.png", -- the image to be used in the normal state
        overFile = "images/btn-blank-over.png", -- the image to be used in the pressed state
        label = "Add to Favourite", -- the text to display on the button
        font = system.defaultFontBold, -- the font name to be used
        fontSize = 10, -- the size of the font
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.9 } }, -- the color of the label and the color when pressed
        onEvent = addToFavourite -- the name of the function to be called when the button is pressed
    }
    btn_Fav.x = display.contentCenterX+70 -- position the button on the center of x axis
    btn_Fav.y = display.contentCenterY-120 -- position the button on the center of y axis
 

    local btn_horoscope = widget.newButton {
        width = 120, -- this defines the width of the button
        height = 30, -- this defines the height of the button 
        defaultFile = "images/btn-blank.png", -- the image to be used in the normal state
        overFile = "images/btn-blank-over.png", -- the image to be used in the pressed state
        label =  "Get Numerology", -- the text to display on the button
        font = system.defaultFontBold, -- the font name to be used
        fontSize = 10, -- the size of the font
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.9 } }, -- the color of the label and the color when pressed
        onEvent = generateHoroscope -- the name of the function to be called when the button is pressed
    }
    btn_horoscope.x = display.contentCenterX-70 -- position the button on the center of x axis
    btn_horoscope.y = display.contentCenterY-120 -- position the button on the center of y axis
  
	input:addEventListener( "userInput", CalcRes )

	input.text = event.params.name
	if(#input.text > 0) then 
		CalcRes()
		generateHoroscope()
	end

	sceneGroup:insert( input )
	sceneGroup:insert( output )
	--sceneGroup:insert( content )
	sceneGroup:insert(btn_Fav)
	sceneGroup:insert(btn_horoscope)
end
	
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		--input:removeSelf( )
	elseif phase == "did" then
		-- Called when the scene is now off screen
		    if(content) then 
		    	content.text = ""
		    	content:removeSelf()
		    	content = nil
		    end
		composer.removeScene( "view1" )
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
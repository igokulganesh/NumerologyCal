-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"


-- event listeners for tab buttons:
local function onFirstView( event )
	composer.gotoScene( "view1",  {
		    effect = "slideRight",
		    time = 400, 
		    params = {
		        name = ""
		    }
		})
end

local function onSecondView( event )
	composer.gotoScene( "view2",   {
		    effect = "slideLeft",
		    time = 400, 
		    params = {
		        name = ""
		    }
		})
end


-- create a white background to fill screen
display.setDefault( "background", 1, 1, 1 ) -- white bg 
--display.newRect( display.contentCenterX, 0, display.contentWidth, 100 ):setFillColor( 0.5, 0.9, 1 )
--display.newText( "Numerology Calculator", display.contentCenterX, 0, native.systemBoldFont, 30 ):setFillColor( 1, 0, 0.5 )


-- create a tabBar widget with two buttons at the bottom of the screen

-- table to setup buttons
local tabButtons = {
	{ --[[label="Home",--]] defaultFile="images/button1.png", overFile="images/button1-down.png", width = 37, height = 37, onPress=onFirstView, selected=true },
	{ --[[label="Favourite",--]] defaultFile="images/heart2.png", overFile="images/heart1.png", width = 37, height = 37, onPress=onSecondView },
}

--[[display.newText( "Home", display.contentCenterX-80, -5, native.systemBoldFont, 10 ):setFillColor( 0 )
display.newText( "Favourite", display.contentCenterX+80, -10, native.systemBoldFont, 10 ):setFillColor( 0)
--]]

-- create the actual tabBar widget
local tabBar = widget.newTabBar{
	top = -25,
	buttons = tabButtons
}

onFirstView()	-- invoke first tab button's onPress event manually

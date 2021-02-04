-----------------------------------------------------------------------------------------
--
-- view2.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local json = require( "json" )
local widget = require( "widget" )

local scene = composer.newScene()

local filePath = system.pathForFile( "numerology.json", system.DocumentsDirectory )
local nameTable
local Saved

local function onRowTouch( event )

    local row = event.target 
    local phase = event.phase 

    if(row.id == 0) then 
    	return 
    end

    if(phase == "touch" or phase == "tap")then 
        composer.gotoScene( "view1", {
		    effect = "slideRight",
		    time = 400, 
		    params = {
		        name = row.params.name
		    }
		} )
    elseif(phase == "swipeLeft" or phase == "swipeRight")then    	
    	table.remove( Saved, row.id )
    	nameTable:deleteRow( row.id+1 )

    	local file = io.open( filePath, "w" )
 
	    if file then
	        file:write( json.encode( Saved ) )
	        io.close( file )
	    end
    end
end

local function onRowRender( event )  
    local row = event.row       
    -- Name
    row.name = display.newText( row, row.params.name, 0, row.height/2, native.systemFont, 18 )
    row.name.align = "left"
    row.name.anchorX = 0
    row.name:setFillColor( 0 )  

    -- Number 
    row.number = display.newText( row, row.params.number, display.contentWidth-100, row.height/2, native.systemFont, 18  )
    row.number.align = "right"
    row.number.anchorX = 0
    row.number:setFillColor( 0 )  

end

function scene:create( event )
	local sceneGroup = self.view
	
	nameTable = widget.newTableView(
	    {
	        x =  display.safeActualContentWidth*0.5,
	        y = 250,
	        height = display.safeActualContentHeight-200,
	        width = display.safeActualContentWidth-20,
	        onRowRender = onRowRender,
	        onRowTouch = onRowTouch,
	        listener = scrollListener
	    }
	)

	nameTable:insertRow{
		id = 0, 
		rowHeight = 40,
		isCategory = true,
		rowColor = { default={0.8,0.8,0.8,0.8} }, 
        lineColor = { 1, 0, 0 }, 
		params = {
			name = "Name", 
			number = "Number"
		}
   	}

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
       	nameTable:insertRow{
       		id = i, 
			rowHeight = 40,
			isCategory = false,
			rowColor = { default={1,1,1}, over={1,0.5,0,0.2} },
			lineColor = { 0.90, 0.90, 0.90 },
			params = {
				name = Saved[i].name, 
				number = Saved[i].number
			}
       }
    end

	sceneGroup:insert(nameTable)
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
	elseif phase == "did" then
		-- Called when the scene is now off screen
		composer.removeScene( "view2" )
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

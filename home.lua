module(..., package.seeall)

--====================================================================--
-- SCENE: [NAME]
--====================================================================--

--[[

 - Version: [1.0]
 - Made by: [Fully Croisened]
 - Website: [www.fullycroisened.com]
 - Mail: [croisened@gmail.com]

--]]



new = function (params)

	------------------
	-- Imports, Include any external references that this scenes needs
	-- Example: local ui = require ( "ui" )
	------------------
local ui = require("ui")
require ("physics")
physics.start()
-- physics.setDrawMode ( "hybrid" ) -- Uncomment in order to show in hybrid mode
physics.setGravity( 0, 9.8 * 2)
physics.start()

	-------------------------------------------------
	-- Handle any Params that get passed to the Scene
	-------------------------------------------------

	local vLabel = ""
	local vReload = false
	local availBalls = {}
	local bottleTimer

-- Whole Fruit physics properties
local minVelocityY = 900
local maxVelocityY = 1100

local minVelocityX = -200
local maxVelocityX = 200

local minAngularVelocity = 100
local maxAngularVelocity = 200

-- Adding a collision filter so the fruits do not collide with each other, they only collide with the catch platform
local bottleProp = {density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 2, maskBits = 1}}
local catchPlatformProp = {density = 1.0, friction = 0.3, bounce = 0.2, filter = {categoryBits = 1, maskBits = 2}}

	--
	if type( params ) == "table" then
		--
		if type( params.label ) == "string" then
			vLabel = params.label
		end
		--
		if type( params.reload ) == "boolean" then
			vReload = params.reload
		end
		--
	end

	------------------
	-- Groups
	------------------
	local localGroup = display.newGroup()
	local bottleGroup = display.newGroup()


    ------------------
    -- Local Variable Definitions
    -------------------

	------------------
	-- Display Objects
	-- Example: local background = display.newImage( "background1.png" )
	------------------
	local backGround = display.newImage( "home.png", true )


	--local infoButton = display.newImage("infobutton.png",true)
	--local vitamindButton = display.newImage("vitamindbutton.png",true)




	------------------
	-- Functions
	------------------
function initBottles()

	local bottle1 = {}
	bottle1.whole = "football1.png"
	table.insert(availBalls, bottle1)

	local bottle2 = {}
	bottle2.whole = "football2.png"
	table.insert(availBalls, bottle2)

	local bottle3 = {}
	bottle3.whole = "football3.png"
	table.insert(availBalls, bottle3)

end


function getRandomBall()

	local bottleProp = availBalls[math.random(1, #availBalls)]
	local bottle = display.newImage(bottleProp.whole)
	bottle.whole = bottleProp.whole
	return bottle
end

-- Return a random value between 'min' and 'max'
function getRandomValue(min, max)
	return min + math.abs(((max - min) * math.random()))
end

function shootObject(type)

	local object = getRandomBall()

	bottleGroup:insert(object)

	object.x = display.contentWidth / 2
	object.y = display.contentHeight  + object.height * 2

	bottleProp.radius = nil
	physics.addBody(object, "dynamic", bottleProp)

	-- Apply linear velocity
	local yVelocity = getRandomValue(minVelocityY, maxVelocityY) * -1 -- Need to multiply by -1 so the fruit shoots up
	local xVelocity = getRandomValue(minVelocityX, maxVelocityX)
	object:setLinearVelocity(xVelocity,  yVelocity)

	-- Apply angular velocity (the speed and direction the fruit rotates)
	local minAngularVelocity = getRandomValue(minAngularVelocity, maxAngularVelocity)
	local direction = (math.random() < .5) and -1 or 1
	minAngularVelocity = minAngularVelocity * direction
	object.angularVelocity = minAngularVelocity

end

-- Creates a platform at the bottom of the game "catch" the fruit and remove it
function setUpCatchPlatform()

	local platform = display.newRect( 0, 0, display.contentWidth * 4, 50)
	platform.x =  (display.contentWidth / 2)
	platform.y = display.contentHeight + display.contentHeight
	physics.addBody(platform, "static", catchPlatformProp)

	platform.collision = onCatchPlatformCollision
	platform:addEventListener( "collision", platform )
end

function onCatchPlatformCollision(self, event)
	-- Remove the fruit that collided with the platform
	event.other:removeSelf()
end
    -------------------
    --Clean Up anything explicitly
    -------------------
    local cleanMe = function()

      timer.cancel(ballTimer)
      ballTimer = nil
      bottleGroup:removeSelf()
      --print("Cleaning")

    end


    -------------------
    --Change Scenes-----
    -------------------
    local moveToGame = function(event)

      --make a call to cleanup anything explicitly
      cleanMe()

      --Example scene change with parameters
      --director:changeScene( { label="Scene Reloaded" }, "screen2","moveFromRight" )

      --Example scene change without parameters
      --director:changeScene( "screen1", "crossfade" )

      director:changeScene( "game", "moveFromRight" )


    end

    	--local dealButton = display.newImage("dealbutton.png",true)
local playButton = ui.newButton{
	default = "playbutton.png",
	over = "playbuttonover.png",
	onRelease = moveToGame,
}






	--====================================================================--
	-- INITIALIZE, Every Display Object must get shoved into the local Display Group
	-- Example:	localGroup:insert( background )
	--====================================================================--
	local initVars = function ()

	  localGroup:insert(backGround)

	  localGroup:insert(bottleGroup)

	  localGroup:insert(playButton)
	  initBottles()
	  setUpCatchPlatform()

    end


   --Setup Sceen--
   local setUpScene = function()
     --Wire up events in here

    -- dealButton:addEventListener("tap", moveToDeal)
    --infoButton:addEventListener("tap", moveToInfo)
    --vitamindButton:addEventListener("tap", moveToFacts)

     --Position Things
     playButton.x = display.contentWidth / 2
     playButton.y = 600

   	 ballTimer = timer.performWithDelay(1500, function(event) shootObject("ball") end, 0)




   end

   	------------------
	-- INITIALIZE variables
	------------------
	initVars()
	setUpScene()

	------------------
	-- MUST return a display.newGroup()
	------------------
	return localGroup

end

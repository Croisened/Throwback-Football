module(..., package.seeall)

--====================================================================--
-- SCENE: [NAME]
--====================================================================--

--[[

 - Version: [1.0]
 - Made by: [name]
 - Website: [url]
 - Mail: [mail]

******************
 - INFORMATION
******************

  - [Your info here]

--]]

new = function (params)

	------------------
	-- Imports, Include any external references that this scenes needs
	-- Example: local ui = require ( "ui" )
	------------------


	-------------------------------------------------
	-- Handle any Params that get passed to the Scene
	-------------------------------------------------

	local vLabel = ""
	local vReload = false
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


    ------------------
    -- Local Variable Definitions
   -------------------
	local stButton

	------------------
	-- Display Objects
	-- Example: local background = display.newImage( "background1.png" )
	------------------
	local backGround = display.newImage( "gamebg.png", true )

	--local switch = display.newImage("switch.png", true)
	local player = display.newImage("player.png", true)


	--local homeButton = display.newImage("homebutton.png",true)

	local grid = {}
	local playerPos
	local playerPosy
	local lockPlayer = false
	local defendersActive = false
	local distanceTraveled = 0

	local defenders = {}
	local timerDefense

---[[

	local defenderPos = {
	   {col = 4, row = 1},
	   {col = 4, row = 2},
	   {col = 4, row = 3},
	   {col = 6, row = 2},
	   {col = 9, row = 2}

	}
--]]







	------------------
	-- Functions
	------------------
    -------------------
    --Clean Up anything explicitly
    -------------------
    local cleanMe = function()

      --print("Cleaning")
	  timer.cancel(timerDefense)
      timerDefense = nil


    end

    -------------------
    --Change Scene-----
    -------------------
    local moveToScene = function(event)

      --make a call to cleanup anything explicitly
      cleanMe()

      --Example scene change with parameters
      --director:changeScene( { label="Scene Reloaded" }, "screen2","moveFromRight" )

      --Example scene change without parameters
      --director:changeScene( "screen1", "crossfade" )

      director:changeScene( "home", "moveFromLeft" )

    end

    --Stats Button-----
    -------------------
    local pressStats = function(event)

        --print("stats")
        
        


    end

	    --Score Button-----
    -------------------
    local pressScore = function(event)

        --print("score")


    end

		    --Kick Button-----
    -------------------
    local pressKick = function(event)

        --print("kick")


    end


	local function checkForTackle()
---[[
	  --spin through all defenders and see if any match the player positions
     
     --If the defenders aren't active, activate them!
       
       if not defendersActive then
         timerDefense = timer.performWithDelay(1000, function(event) moveDefense() end, 0)
         defendersActive = true
       end
     
	  local tackled = false

      for x = 1,5 do

	      -- print("Defender " defenders[x].col)

	   if (defenderPos[x].col == playerPos) and (defenderPos[x].row == playerPosy) then

	      --we have a tackle!
          print("game over, bud!")

		  --stop the timer and lock the player
		  timer.cancel(timerDefense)
		  lockPlayer = true


	      --do something cool

	     -- Vibrate the phone
	     system.vibrate()
		 showTackled()

	   end

	  end


--]]
	end


	---[[

local function ResetScene(event)
   --print("reset scene")


     director:changeScene( "game", "moveFromLeft" )
     


end

--]]


---[[

		function showTackled()

     	   --print("showTackled")
		   local prize = display.newImage( "tackled.png", true )
		   prize.x = 512
		   prize.y = 384
		   localGroup:insert(prize)
		   transition.to(prize,{rotation = prize.rotation + 360,time = 1000, onComplete=function() display.remove(prize); prize=nil end})
		   timer.performWithDelay(3000, ResetScene, 1)
		   
		   --Tackeld so lets increment the Downs...
		   setGlobal("Down", getGlobal("Down") + 1)
		   
		   --If we get to 4th down...you know kick or blah blah blah, try for 1st down, then to player 2, etc.
		   --For our purposes lets just run 4 downs and if we haven't got a touch down, reset the game back to 1st down
		   
		   
		   if getGlobal("Down") > 4 then
		     --Game over, bud!
		     --Back to 1st down on the 20, 80 yards to go for TD in 4 downs...
		     
		     setGlobal("Down", 1)
		     setGlobal("Distance", 80)
		     
		     
		   end
		   
		   
		   
         end

--]]



    local pressMove = function(event)

        --print("move")

		if lockPlayer then return end

		if (playerPos < 9)  then
		  playerPos = playerPos + 1
		  player.x = xoffset[playerPos]
		else
     	  playerPos = 1
		  player.x = xoffset[1]
   	    end

        if getGlobal("Distance") > 0 then
          --subtract a yard, because we gained a yard
          setGlobal("Distance", getGlobal("Distance") - 1)
          print(getGlobal("Distance"))
        else
          --Means we scored, touchdown!
          print("Touchdown")
        end

        checkForTackle()


    end

    local pressUp = function(event)

        --print("up")

	    if lockPlayer then return end

		if (playerPosy <  3) then
		  playerPosy = playerPosy + 1
		  player.y = yoffset[playerPosy]
   	    end

        checkForTackle()

    end

    local pressDown = function(event)

        --print("down")

		if lockPlayer then return end

		if (playerPosy > 1) then
		  playerPosy = playerPosy - 1
		  player.y = yoffset[playerPosy]
   	    end

	    checkForTackle()

    end



	--====================================================================--
	-- INITIALIZE, Every Display Object must get shoved into the local Display Group
	-- Example:	localGroup:insert( background )
	--====================================================================--
	local initVars = function ()

	  localGroup:insert(backGround)

	  --localGroup:insert(switch)
	  localGroup:insert(player)
	  --localGroup:insert(defender)
	  --localGroup:insert(homeButton)

	  xoffset = {250, 308, 376, 444, 512, 580, 648, 716, 774}
	  yoffset = {264, 210, 156}


    end


   --Setup Sceen--
   local setUpScene = function()
     --Wire up events in here

     --homeButton:addEventListener("touch", moveToScene)

    kButton = ui.newButton{
  	  default = "kbutton.png",
	  over = "kbuttonover.png",
	  onRelease = pressKick,
      }
	localGroup:insert(kButton)

    moveButton = ui.newButton{
  	  default = "movebutton.png",
	  over = "movebuttonover.png",
	  onRelease = pressMove,
      }
	localGroup:insert(moveButton)

    upButton = ui.newButton{
  	  default = "upbutton.png",
	  over = "upbuttonover.png",
	  onRelease = pressUp,
      }
	localGroup:insert(upButton)


    downButton = ui.newButton{
  	  default = "downbutton.png",
	  over = "downbuttonover.png",
	  onRelease = pressDown,
      }
	localGroup:insert(downButton)



     --Position Things
	 kButton.x = 114
	 kButton.y = 600

	 moveButton.x = 114
	 moveButton.y = 450

	 upButton.x = 910
	 upButton.y = 450

	 downButton.x = 910
	 downButton.y = 600




   end



local function defenderAtPos(row, col)
---[[
	for i=1, 5 do
		if defenderPos[i].row == row and defenderPos[i].col == col then
			return true
		end
	end

	return false
	--]]
end

local function moveDefender(guy, row, col)
---[[
	defenderPos[guy].row = row
	defenderPos[guy].col = col
	defenders[guy].x = xoffset[col]
	defenders[guy].y = yoffset[row]
--]]
end

function moveDefense()


  local desiredx
  local desiredy
  local badGuy = math.random(1,5)
  local canMoveEastWest
  local canMoveNorthSouth

  --print("Bad Guy = " .. badGuy)


 ---[[

  if playerPosy < defenderPos[badGuy].row then
    --to the left of defender
	--print("player is below")

	desiredRowInc = -1
  elseif playerPosy > defenderPos[badGuy].row then
    -- to the right of defender
	--print("player is above")


	desiredRowInc = 1
  else
    --equal
	--print("player is same row")

	desiredRowInc = 0

  end

--]]





 ---[[

  if playerPos < defenderPos[badGuy].col then
    --to the left of defender
	--print("player is to the left")


	desiredColInc = -1
  elseif playerPos > defenderPos[badGuy].col then
    -- to the right of defender
	--print("player is to the right")

	desiredColInc = 1
  else
    --equal
	--print("player is same col")

	desiredColInc = 0
  end

--]]

	-- Check to see if we can move to desired positions
	print(defenderPos[badGuy].col + desiredColInc)

	if (defenderPos[badGuy].col + desiredColInc < 10) and (defenderPos[badGuy].col + desiredColInc > 0) then
		canMoveEastWest = true
	else
		canMoveEastWest = false
	end


	if (defenderPos[badGuy].row + desiredRowInc < 4) and (defenderPos[badGuy].row + desiredRowInc > 0) then
		canMoveNorthSouth = true
	else
		canMoveNorthSouth = false
	end

	if (canMoveEastWest) then
		-- Check to see if there is a defender in the way
		if (defenderAtPos(defenderPos[badGuy].row, defenderPos[badGuy].col + desiredColInc) == true) then
			canMoveEastWest = false
		end
	end

	if (canMoveNorthSouth) then
		-- Check to see if there is a defender in the way
		if (defenderAtPos(defenderPos[badGuy].row + desiredRowInc, defenderPos[badGuy].col) == true) then
			canMoveNorthSouth = false
		end
	end

	if (canMoveEastWest and canMoveNorthSouth) then
		-- Randomly pick one
		if math.random(1,2) == 2 then
			-- Move east/west
			moveDefender(badGuy, defenderPos[badGuy].row, defenderPos[badGuy].col + desiredColInc)
		else
			-- Move north/south
			moveDefender(badGuy, defenderPos[badGuy].row + desiredRowInc, defenderPos[badGuy].col)
		end
	elseif canMoveEastWest then
		-- Move east west
			moveDefender(badGuy, defenderPos[badGuy].row, defenderPos[badGuy].col + desiredColInc)
	elseif canMoveNorthSouth then
		-- Move north south
			moveDefender(badGuy, defenderPos[badGuy].row + desiredRowInc, defenderPos[badGuy].col)
	else
		-- Do nothing
	end


	checkForTackle()

end


local setupGame = function()


  player.x = xoffset[1]
  player.y = yoffset[2]
  playerPos = 1
  playerPosy = 2


  for x = 1,5 do

   	local defender = display.newImage("defender.png", true)
	defenders[x] = defender
	defender.x = xoffset[defenderPos[x].col]
	defender.y = yoffset[defenderPos[x].row]
	localGroup:insert(defender)

  end
  
 
  --Lets display what Down it is....
  ---[[
  --local label = display.newText("Down: " tostring(getGlobal("Down")) .. "Distance Remaining: " .. tostring(getGlobal("Distance")) , 0, 0, "MaroonedOnMarsBB", 40 )
  --local label = display.newText("Down: " tostring(getGlobal("Down")), 0, 0, "MaroonedOnMarsBB", 40 )
  local label = display.newText("Down: " .. tostring(getGlobal("Down") .. "    Distance Remaining: " .. tostring(getGlobal("Distance"))), 0, 0, "MaroonedOnMarsBB", 40 )
  label:setReferencePoint(display.CenterLeftReferencePoint);
  label:setTextColor(255, 0, 0)
  label.x = display.contentWidth /2 - 185 
  label.y = 420
  localGroup:insert(label)
  --]]


end


   	------------------
	-- INITIALIZE variables
	------------------
	initVars()
	setUpScene()
	setupGame()

	------------------
	-- MUST return a display.newGroup()
	------------------
	return localGroup

end

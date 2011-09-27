display.setStatusBar( display.HiddenStatusBar )

--====================================================================--
-- DIRECTOR CLASS SAMPLE
--====================================================================--

--[[

 - Version: 1.3
 - Made by Ricardo Rauber Pereira @ 2010
 - Blog: http://rauberlabs.blogspot.com/
 - Mail: ricardorauber@gmail.com

******************
 - INFORMATION
******************

  - This is a little sample of what Director Class does.
  - If you like Director Class, please help us donating at my blog, so I could
	keep doing it for free. http://rauberlabs.blogspot.com/

--]]

--====================================================================--
-- IMPORT DIRECTOR CLASS
--====================================================================--

require "globals"
local director = require("director")

--====================================================================--
-- CREATE A MAIN GROUP
--====================================================================--

local mainGroup = display.newGroup()

--====================================================================--
-- MAIN FUNCTION
--====================================================================--

local main = function ()
	
	------------------
	-- Add the group from director class
	------------------
	
	mainGroup:insert(director.directorView)
	
	------------------
	-- Change scene without effects
	------------------
	
	director:changeScene("home")
	
	------------------
	-- Return
	------------------
	
	return true
end

--====================================================================--
-- BEGIN
--====================================================================--

main()

-- It's that easy! :-)

--[[
local monitorMem = function()

    collectgarbage()
    print( "MemUsage: " .. collectgarbage("count") )

    local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
    print( "TexMem:   " .. textMem )
end

Runtime:addEventListener( "enterFrame", monitorMem )
--]]
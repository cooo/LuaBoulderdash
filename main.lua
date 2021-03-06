require("lib/strings")
require("boulderdash")
require("levels/load")
require("keyboard")


function love.load()

	t_minus_zero = reset_time()
	idle_time = reset_time()
	gamePaused = false
	delay = 0.10
	delay_dt = 0

	love.graphics.setColorMode("replace")
		
	
	level_loader:load()
		
	boulderdash:Startup()
	boulderdash:LevelUp()
end


function love.update(dt)
	if gamePaused then return end
	
	if boulderdash.dead then
		boulderdash:explode("rockford")
		boulderdash.magicwall_dormant = true
		audio:stop("twinkly_magic_wall")
	end

	if not boulderdash.start_over then
		boulderdash:update(dt)
	else
		boulderdash:startOver()
	end
end

function love.draw()
	boulderdash:draw()
end


-- some ideas for keys:
-- cursor & space is taken care of in the rockford object
-- s : sound on/off
-- d : suicide (when rockford is stuck)
-- p : pause
-- q : quit (kill the complete game)
-- m : bring up a menu so you can change caves/levels
-- 

function love.keypressed(key, unicode)
	idle_time = love.timer.getMicroTime()	-- the start of idle time
	debug = {}
	table.insert(boulderdash.keypressed, key)
	if key=="d" then
		-- print some debug stuff here
	end

	-- defer key to handler
	keyboard.keypressed(key)

end

function love.keyreleased(key, unicode)
	boulderdash:default()	
end

function love.focus(f)
  if not f then
	gamePaused = true
    print("LOST FOCUS")
  else
	gamePaused = false
    print("GAINED FOCUS")
  end
end

function love.quit()
  print("Thanks for playing! Come back soon!")
end

function since(t)
	return love.timer.getMicroTime() - t
end

function reset_time()
	return love.timer.getMicroTime()
end


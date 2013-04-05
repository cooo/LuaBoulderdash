require("boulderdash")

function love.load()

	t_minus_zero = reset_time()
	idle_time = reset_time()
	gamePaused = false
	delay = 0.10
	delay_dt = 0

	love.graphics.setColorMode("replace")
	screen_width = love.graphics.getWidth()	
	boulderdash:Startup()
	boulderdash:LevelUp()
end


function love.update(dt)
	if gamePaused then return end
	
	if boulderdash.dead then
		boulderdash:explode("rockford")
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


function love.keypressed(key, unicode)
	idle_time = love.timer.getMicroTime()	-- the start of idle time
	debug = {}
	table.insert(boulderdash.keypressed, key)
	if key=="d" then
		-- print some debug stuff here
	end
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
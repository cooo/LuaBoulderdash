require("boulderdash")

function love.load()

	t_minus_zero = reset_time()
	idle_time = reset_time()
	gamePaused = false
	delay = 0.05
	delay_dt = 0

	love.graphics.setColorMode("replace")
	screen_width = love.graphics.getWidth()	
	boulderdash:Startup()

end


function love.update(dt)
	if gamePaused then return end
	
	if boulderdash.dead then
		boulderdash:explode()
	end
	if not boulderdash.done then
		if not boulderdash.start_over then
			boulderdash:update(dt)
		else
			boulderdash:startOver()
		end
	else
		boulderdash:LevelUp()
	end
end

function love.draw()
	boulderdash:draw()
end


function love.keypressed(key, unicode)
	idle_time = love.timer.getMicroTime()	-- the start of idle time
	debug = {}
	if key=="d" then
		for i,object in pairs(boulderdash.objects) do
			--if (object.type=="space") then
			if (object.x==4 and object.y==3) then
				print(object.x .. "," .. object.y .. ": " .. object.id .. object.type)
			end
		end
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
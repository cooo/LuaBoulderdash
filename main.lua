function love.load()
	t_minus_zero = reset_time()
	idle_time = reset_time()
	
	require("boulderdash")
	
	gamePaused = false
	
    require("levels/levels")
    require("camera")
	
	delay = 0.05
	delay_dt = 0
	
	boulderdash:Startup()
	
	scale = 32
	
	for y,i in pairs(level) do
		for x,j in pairs(level[y]) do
			if level[y][x]=="S" then
				boulderdash.Create( "steel", x, y )
		    elseif level[y][x]=="W" then
				boulderdash.Create( "wall", x, y )
		    elseif level[y][x]=="r" then
				boulderdash.Create( "rock", x, y )
		    elseif level[y][x]=="d" then
				boulderdash.Create( "diamond", x, y )
			elseif level[y][x]=="." then
				boulderdash.Create( "dirt", x, y )
			elseif level[y][x]=="X" then
				boulderdash.Create( "rockford", x, y )
			elseif level[y][x]=="P" then
				boulderdash.Create( "outbox", x, y )
			elseif level[y][x]==" " then
				boulderdash.Create( "space", x, y )
			end
		end
	end

end


function love.update(dt)
	if gamePaused then return end
		
		
	if delay_dt > delay then
	    
		boulderdash:update(dt)	
		delay_dt = 0
    end
	delay_dt = delay_dt + dt
end

function love.draw()
	camera:set()
	boulderdash:draw()
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	camera:unset()
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
	no_keys = false
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
	no_keys = true
	idle_time = love.timer.getMicroTime()	-- the start of idle time
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
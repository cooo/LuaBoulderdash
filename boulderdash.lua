require("camera")
require("levels/levels")

boulderdash = {}
boulderdash.objects = {}
boulderdash.objpath = "objects/"
boulderdash.imgpath = "images/"
boulderdash.scale = 1
boulderdash.diamonds = 0
local register = {}
local id = 0

function id(x,y)
	return "x" .. x .. "y" .. y
end

function boulderdash:find(x,y)
	return boulderdash.objects[id(x,y)]
end


function boulderdash:Startup()
	-- register everything in the boulderdash.objpath folder
	files = love.filesystem.enumerate( boulderdash.objpath )
	for k, file in ipairs(files) do
		if not (file == "base.lua") then
			local obj_name = string.sub(file,1,string.find(file, ".lua") - 1)
			register[obj_name] = love.filesystem.load( boulderdash.objpath .. file )
		end
	end
	
	-- loadup the first level
	self:LevelUp(at_level)
	
end

function boulderdash:LevelUp(level_index)
	
	level = levels[level_index].playfield
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

function boulderdash.Derive(name)
	return love.filesystem.load( boulderdash.objpath .. name .. ".lua" )()
end

function boulderdash.Create(name, x, y)
	x = x or 0
	y = y or 0
	if register[name] then
		local object = register[name]()
		object:load(x,y)
		object.type = name
		object.id = id(x,y)
		boulderdash.objects[object.id] = object
		return object
	else
		print("Error: Entity " .. name .. " does not exist! ")
	end
end

function boulderdash:update(dt)
	if delay_dt > delay then
		for i, object in pairs(boulderdash.objects) do
			if object.update then
				if not object.moved then
					object:update(dt)
				else
					object.moved = false
				end	
			end
		end
		delay_dt = 0
    end
	delay_dt = delay_dt + dt
end

function boulderdash:default()
	idle_time = love.timer.getMicroTime()	-- the start of idle time
	for i, object in pairs(boulderdash.objects) do
		if object.default then
			object:default()
		end
	end
end

function boulderdash:draw()
	
	camera:set()

	for i, object in pairs(boulderdash.objects) do
		if object.draw then
			object:draw()
		end
	end
	
	camera:unset()
	
	-- draw a scoreboard on top
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0, 0, 800, 32 )
	
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	
	if (boulderdash.diamonds >= levels[at_level].diamonds_to_get) then
		love.graphics.print("Score ".. tostring(boulderdash.diamonds .. " Done."), 400, 10)
	else
		love.graphics.print("Score ".. tostring(boulderdash.diamonds), 400, 10)
	end
	
end
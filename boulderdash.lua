require("camera")
require("levels/levels")

boulderdash = {}
boulderdash.objects = {}
boulderdash.objpath = "objects/"
boulderdash.imgpath = "images/"
boulderdash.diamonds = 0
boulderdash.at_level = 0
boulderdash.goal = {}
boulderdash.done = false
boulderdash.dead = false
local register = {}
local id = 0

function id(x,y)
	return "x" .. x .. "y" .. y
end

function boulderdash:setDone()
	boulderdash.done = true
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
	self:LevelUp()
end

function boulderdash:LevelUp()	

	self.objects = {}
	self.at_level = self.at_level + 1
	level = levels[self.at_level].playfield
	for y,i in pairs(level) do
		for x,j in pairs(level[y]) do
			boulderdash.Create( object_map[level[y][x]], x, y )
		end
	end

	boulderdash:Replace("rockford", "entrance")

	self.done = false
	camera:setPosition( 0, 0 )
    
end

function boulderdash:Replace(find, replace)
	-- find rockford, and replace him with an entrance
	for i, object in pairs(boulderdash.objects) do
		if object.type == find then
			boulderdash.Create( replace, object.x, object.y )
			return object.x, object.y
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

function boulderdash:setGoal( x, y )
	self.goal = { x=x,y=y }
end

function boulderdash:getGoal()
	return self.goal
end


function boulderdash:update(dt)
	if boulderdash.dead then
		local x,y = boulderdash:Replace("rockford", "explode")

		boulderdash.Create( "explode", x+1, y )
		boulderdash.Create( "explode", x-1, y )
		boulderdash.Create( "explode", x+1, y-1 )
		boulderdash.Create( "explode", x, y-1 )
		boulderdash.Create( "explode", x-1, y-1 )
		boulderdash.Create( "explode", x+1, y+1 )
		boulderdash.Create( "explode", x, y+1 )
		boulderdash.Create( "explode", x-1, y+1 )
	
		boulderdash.dead = false
	end
	if not boulderdash.done then
	
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
	else
		boulderdash:LevelUp()
	end
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
	love.graphics.rectangle("fill", 0, 0, screen_width, 32 )
	
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	
	if (boulderdash.diamonds >= levels[boulderdash.at_level].diamonds_to_get) then
		love.graphics.print("Score ".. tostring(boulderdash.diamonds .. " Done."), 400, 10)
	else
		love.graphics.print("Score ".. tostring(boulderdash.diamonds), 400, 10)
	end
	
end


require("camera")
require("levels/levels")
require("scoreboard")
require("amoebas")

boulderdash = {}
boulderdash.objpath   = "objects/"
boulderdash.objects   = {}
boulderdash.imgpath   = "images/"
boulderdash.soundpath = "sound/"
boulderdash.sounds    = {}
boulderdash.diamonds = 0
boulderdash.at_level = 0
boulderdash.goal = {}
boulderdash.done = true
boulderdash.dead = false
boulderdash.died = false
boulderdash.start_over = false
boulderdash.flash = false
boulderdash.keypressed = {}

local register = {}

function id(x,y)
	return "x" .. x .. "y" .. y
end

function boulderdash:magic_wall_tingles()
	return not boulderdash.magicwall_dormant and not boulderdash.magicwall_expired 
end


function boulderdash.Derive(name)
	return love.filesystem.load( boulderdash.objpath .. name .. ".lua" )()
end

function boulderdash:setDone()
	boulderdash.done = true
end

function boulderdash:find(x,y)
	return boulderdash.objects[id(x,y)]
end

function boulderdash:findByID(id)
	return boulderdash.objects[id]
end

local function registerObjects()
	-- register everything in the boulderdash.objpath folder
	local files = love.filesystem.enumerate( boulderdash.objpath )
	for k, file in ipairs(files) do
		if not (file == "base.lua") then
			local obj_name = string.sub(file,1,string.find(file, ".lua") - 1)
			register[obj_name] = love.filesystem.load( boulderdash.objpath .. file )
		end
	end
end

local function loadSounds()
	local sounds = love.filesystem.enumerate( boulderdash.soundpath )	
	for k, sound in ipairs(sounds) do
		if string.find(sound, ".ogg") then
			local sound_name = string.sub(sound,1,string.find(sound, ".ogg") - 1)
			boulderdash.sounds[sound_name] = love.audio.newSource(boulderdash.soundpath .. sound)
		end
	end
end

function boulderdash:Startup()
	registerObjects()
	loadSounds()
end


local function lookup(letter)
	object = object_map2[letter]
	if object then
		return object
	else
		print("cannot find " .. letter)
		return "space"
	end
end

function boulderdash:LevelUp()	

	self.objects = {}
	self.at_level = self.at_level + 1
--	level = levels[self.at_level].playfield
    level = level_loader.games[1].caves[self.at_level].map
	for y,i in pairs(level) do
		for x,j in pairs(level[y]) do
			boulderdash.Create( lookup(level[y][x]), x-1, y )
		end
	end

	local xc,yc = boulderdash:Replace("rockford", "entrance")

	self.done = false
	boulderdash.flash = false
	boulderdash.dead = false
	boulderdash.died = false
	boulderdash.start_over = false
	boulderdash.diamonds = 0
	boulderdash.magictime = level_loader.games[1].caves[boulderdash.at_level].magictime or 0
	boulderdash.magicwall_dormant = true
	boulderdash.magicwall_expired = false
	
	amoebas.init(tonumber(level_loader.games[1].caves[boulderdash.at_level].amoebatime))

	boulderdash.i = 0	
	delay = 0.1
	scoreboard:load()

	if (xc<11)then
		xc = 0
	elseif (xc>26) then
		xc = 15
	elseif ((yc>=11) and (yc<=26)) then
		xc = xc - 11
	end

	if (yc<7)then
		yc = 0
	elseif (yc>=13) then
		yc = 4
	elseif ((yc>=7 and (yc<13))) then
		yc = yc - 8
	end
	
	camera:setPosition(0,0)
    camera:move(xc*32,yc*32)
end

function boulderdash:Replace(find, replace)
	for i, object in pairs(boulderdash.objects) do
		if (object.type == find) then
			boulderdash.Create( replace, object.x, object.y )
			return object.x, object.y
		end
	end	
end

function boulderdash:ReplaceAll(find, replace)
	for i, object in pairs(boulderdash.objects) do
		if (object.type == find) then
			boulderdash.Create( replace, object.x, object.y )
		end
	end	
end

function boulderdash:ReplaceByID(id, replace)
	local object = boulderdash:findByID(id)
	boulderdash.Create( replace, object.x, object.y )
	return object.x, object.y
end

function boulderdash.Create(name, x, y, explode_to)
	x = x or 0
	y = y or 0
	if explode_to then
		print(name .. ' ' .. explode_to)
	end
	if register[name] then
		local object = register[name]()
		object:load(x,y)
		object.type = name
		object.id = id(x,y)
		if explode_to then
			object.to = explode_to
		end
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


function boulderdash:explode(find)
	local object = boulderdash:findByID(find)
	local explode_to = nil
	if object and object.explode_to_diamonds then
		explode_to = "diamond"
	end
	play_sound("explosion")

	local x,y = boulderdash:ReplaceByID(find, "space")
	boulderdash:canExplode( x  , y  , explode_to )
	boulderdash:canExplode( x+1, y  , explode_to )
	boulderdash:canExplode( x-1, y  , explode_to )
	boulderdash:canExplode( x+1, y-1, explode_to )
	boulderdash:canExplode( x  , y-1, explode_to )
	boulderdash:canExplode( x-1, y-1, explode_to )
	boulderdash:canExplode( x+1, y+1, explode_to )
	boulderdash:canExplode( x  , y+1, explode_to )
	boulderdash:canExplode( x-1, y+1, explode_to )

	if (find=="rockford") then
		boulderdash.dead = false -- to prevent starting the explode sequence again
		boulderdash.died = true  -- to signal rockford just died
	end

end

function boulderdash:canExplode(x,y, explode_to)
	if not (boulderdash:find(x,y).type == "steel") then
		boulderdash.Create( "explode", x, y, explode_to )  -- default is explode_to space
	end
end


function boulderdash:startOver()
	boulderdash.at_level = boulderdash.at_level - 1
	boulderdash:LevelUp()
end


function boulderdash:update(dt)
	if delay_dt > delay then
		boulderdash.i = boulderdash.i + 1		

		amoebas.grow_directions = {}
		

		for i, object in pairs(boulderdash.objects) do
			if object.update then
				if not object.moved then
					object:update(dt)
					object.moved = true
				end	
			end
		end
		delay_dt = 0
		
		if boulderdash.flash then
			love.graphics.setBackgroundColor(0,0,0)
		end
		scoreboard:update(dt)		
		amoebas:update(dt)
		
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
				object.moved = false
			end
		end
	camera:unset()
	
	scoreboard:draw()
--	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 750, 10)
		
end


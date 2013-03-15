boulderdash = {}
boulderdash.objects = {}
boulderdash.objpath = "objects/"
boulderdash.imgpath = "images/"
boulderdash.scale = 1
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
	for i, object in pairs(boulderdash.objects) do
		if object.update then
			if not object.moved then
				object:update(dt)
			else
				object.moved = false
			end	
		end
	end
end

function boulderdash:draw()
	for i, object in pairs(boulderdash.objects) do
		if object.draw then
			object:draw()
		end
	end
end
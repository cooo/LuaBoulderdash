-- amoebas consists of one or more amoeba objects
-- could there be more than one amoebas?
-- before refactoring boulderdash.lua: 300 lines
amoebas = {}

amoebas.present          = false
amoebas.max_size         = 200			-- change to rocks if larger
amoebas.amoeba_random    = 4/128		-- growth speed, changes after amoebatime (see cave data)
amoebas.grow_directions  = {}			-- amoebas can possibly grow in the directions
amoebas.amoeba_timer     = 0			-- growing time since start of level
amoebas.amoebatime       = 0			-- from the cave data, denotes switch from slow to fast growth
amoebas.size             = 0
amoebas.events           = {}           -- what might happen to amoebas

-- events
local growth      = {}	    -- amoeba can grow?
local to_rocks    = {}	    -- change to rocks?
local to_diamonds = {}		-- change to diamonds?

function growth.happens()
	return amoebas.present and (#amoebas.grow_directions > 0) 
end

function to_diamonds.happens()
	return amoebas.present and (#amoebas.grow_directions==0)
end

function to_rocks.happens()
	return amoebas.size >= amoebas.max_size
end

function growth.execute()
	local pick_amoeba = math.random(1,#amoebas.grow_directions)
	if (pick_amoeba==1) then   			-- amoeba grows this frame, pick one
		local x,y = boulderdash:Replace(amoebas.grow_directions[pick_amoeba].id, "amoeba")
		amoebas.size = amoebas.size + 1
	end
end

function to_diamonds.execute()
	for i, object in pairs(boulderdash.objects) do
		if (object.type == "amoeba") then
			local x,y = boulderdash:Replace(object.id, "diamond")
		end
	end
	amoebas.present = false
end

function to_rocks.execute()
	for i, object in pairs(boulderdash.objects) do
		if (object.type == "amoeba") then
			local x,y = boulderdash:Replace(object.id, "rock")
		end
	end
	amoebas.present = false
end

		
function amoebas:init(amoebatime)
	if amoebas.present then
		amoebas.events        = { to_rocks, to_diamonds, growth }	-- the order is important
		amoebas.amoebatime    = amoebatime or 0
		amoebas.amoeba_timer  = 0
		amoebas.amoeba_random = 4/128
		amoebas.size          = 1
	end
end

function amoebas:update(dt)
	if amoebas.present then	
		for i, amoeba_event in pairs(amoebas.events) do
			if amoeba_event.happens() then
				amoeba_event.execute()
			end
		end
		amoebas.amoeba_timer = amoebas.amoeba_timer + dt
		if amoebas.amoeba_timer > amoebas.amoebatime then
			amoebas.amoeba_random = 0.25
		end
	end
end

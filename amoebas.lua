-- amoebas consists of one or more amoeba objects
-- could there be more than one amoebas?
-- before refactoring boulderdash.lua: 300 lines
amoebas = {}

amoebas.present			= false
amoebas.max_size		= 200			-- change to rocks if larger

amoebas.amoeba_random	= 4/128			-- growth speed, changes after amoeba_time (see cave data)
amoebas.grow_directions = {}			-- amoebas can possibly grow in the directions
amoebas.amoeba_timer     = 0			-- growing time since start of level
amoebas.amoebatime       = 0			-- from the cave data, denotes switch from slow to fast growth
amoebas.size 			 = 0
		
function amoebas:init(amoebatime)
	if amoebas.present then
		amoebas.amoebatime    = amoebatime or 0
		amoebas.amoeba_timer  = 0
		amoebas.amoeba_random = 4/128
		amoebas.size 		  = 1
	end
end

function amoebas:update(dt)
	if (amoebas.size >= amoebas.max_size) then 				-- change to rocks?
		for i, object in pairs(boulderdash.objects) do
			if (object.type == "amoeba") then
				local x,y = boulderdash:Replace(object.id, "rock")
			end
		end
		amoebas.present = false
	elseif amoebas.present and (#amoebas.grow_directions==0) then		-- change to diamonds?
		for i, object in pairs(boulderdash.objects) do
			if (object.type == "amoeba") then
				local x,y = boulderdash:Replace(object.id, "diamond")
			end
		end
		amoebas.present = false
	elseif amoebas.present and (#amoebas.grow_directions > 0) then			-- amoeba can grow?
		local pick_amoeba = math.random(1,#amoebas.grow_directions)
		if (pick_amoeba==1) then   			-- amoeba grows this frame, pick one
			local x,y = boulderdash:Replace(amoebas.grow_directions[pick_amoeba].id, "amoeba")
			amoebas.size = amoebas.size + 1
		end
	end
	
	if amoebas.present then
		amoebas.amoeba_timer = amoebas.amoeba_timer + dt
		if amoebas.amoeba_timer > amoebas.amoebatime then
			amoebas.amoeba_random = 0.25
		end
	end
end


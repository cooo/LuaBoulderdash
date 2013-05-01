local amoeba = boulderdash.Derive("base")
amoeba.hard = true
amoeba.rounded = true
amoeba.images = {}
amoeba.sprite_index = nil
amoeba.too_many = 200

local directions = { {x=-1,y=0}, {x=0,y=-1}, {x=1,y=0}, {x=0,y=1} }

function amoeba:load( x, y )
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "amoeba.png"))
	for i=0, 32*(8-1), 32 do
		table.insert( self.images, love.graphics.newQuad(i, 0, 32, 32, 32*8, 32) )
	end
	self:setPos( x, y )
	boulderdash.has_amoeba = true
end

function amoeba:update(dt)
	amoeba:grow()
	boulderdash.amoeba_count = boulderdash.amoeba_count + 1
	local timer = since(t_minus_zero) % 1
	self.sprite_index = 1 + math.floor(timer / (1/8))
end

function amoeba:grow()
	-- boulderdash.amoeba_random
	-- 1. can grow?
	local eligible_neigbours = {}
	for i,d in ipairs(directions) do
		local neighbour = boulderdash:find(self.x+d.x, self.y+d.y)
		if (neighbour.type == "space" or neighbour.type == "dirt") then
			boulderdash.amoeba_can_grow = true -- general switch
			table.insert(eligible_neigbours, neighbour)
		end
	end
	
	if (#eligible_neigbours>0) then 			-- pick one of the possible directions to grow
		local pick_neighbour = math.random(1, #eligible_neigbours)
		table.insert(boulderdash.amoebas, eligible_neigbours[pick_neighbour])
	end

end

function amoeba:draw()
	local x, y = self:getPos()
	local img  = self:getImage()
	love.graphics.drawq(img, self.images[self.sprite_index or 1], x*self.scale, y*self.scale)
end

return amoeba
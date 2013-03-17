local base = {}

base.x = 0
base.y = 0
base.img = nil
base.type = nil
base.rounded = false
base.hard = false
base.moved = false
base.debug = false
base.scale = 32

function id(x,y)
	return "x" .. x .. "y" .. y
end

function base:setPos( x, y )
--	print("base:setPos (" .. x .. ", " .. y .. ")" )
	base.x = x
	base.y = y
	if (x==13 and y==2) then
		base.debug=false
	end
end

function base:setImage(img)
	base.img = img
end

function base:getImage()
	return base.img
end

function base:getPos()
	return base.x, base.y
end

-- move something in x,y direction and put space where something was
function base:doMove(x,y)
	local xr,yr = base:getPos()
	base:setPos( xr+x, yr+y )
	base.id = id( base:getPos() )
	boulderdash.objects[base.id] = base
	base.moved = true

	local space = boulderdash.Create( "space", xr, yr )
	boulderdash.objects[space.id] = space
end

function base:fall()
	local x,y = base:getPos()
	
	-- fall straight down
	if (boulderdash:find(x,y+1).type == "space") then
		base.falling = true
		-- create space
		local space = boulderdash.Create( "space", x, y )
		boulderdash.objects[space.id] = space
		-- move rock
		base:setPos(x,y+1)
		base.id = id(x,y+1)
		-- put sp
		boulderdash.objects[base.id] = base
	
	-- fall of rounded object (to the right)
	elseif (boulderdash:find(x,y+1).rounded and boulderdash:find(x+1,y).type=="space" and boulderdash:find(x+1,y+1).type=="space") then
		base.falling = true
		-- create space
		local space = boulderdash.Create( "space", x, y )
		boulderdash.objects[space.id] = space
		-- move rock
		base:setPos(x+1,y+1)
		base.id = id(x+1,y+1)
		-- put sp
		boulderdash.objects[base.id] = base

	-- fall of rounded object (to the left)
	elseif (boulderdash:find(x,y+1).rounded and boulderdash:find(x-1,y).type=="space" and boulderdash:find(x-1,y+1).type=="space") then
		base.falling = true
		-- create space
		local space = boulderdash.Create( "space", x, y )
		boulderdash.objects[space.id] = space
		-- move rock
		base:setPos(x-1,y+1)
		base.id = id(x-1,y+1)
		-- put sp
		boulderdash.objects[base.id] = base
	
	elseif (boulderdash:find(x,y+1).hard ) then
	    base.falling = false
	end
	
end


function base:draw()	
	local x, y = self:getPos()	
	local img = self:getImage()
	love.graphics.draw(img, x*self.scale, y*self.scale, 0, 2, 2)
	
	if (base.debug) then
		print(base.type)
		print(base.x .. ", " .. base.y)
		print(base.falling)
	end
end

return base
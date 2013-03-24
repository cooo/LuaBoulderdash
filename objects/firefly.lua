local firefly = boulderdash.Derive("base")
local faces = { "left", "up", "right", "down" }
local orientation = 1
firefly.hard = true
firefly.rounded = true
firefly.images = {}
firefly.sprite_index = 1
firefly.flash_delay = 0.02
firefly.flash_timer = 0
firefly.facing = faces[orientation]

function firefly:rotateRight()
	orientation = orientation + 1
	if (orientation > 4) then orientation = 1 end
	firefly.facing = faces[orientation]
end

function firefly:rotateLeft()
	orientation = orientation - 1
	if (orientation < 1) then orientation = 4 end
	firefly.facing = faces[orientation]
end

function firefly:load( x, y )
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "firefly.png"))
	for i=0, 32*(8-1), 32 do
		table.insert( self.images, love.graphics.newQuad(i, 0, 32, 32, 32*8, 32) )
	end
	self:setPos( x, y )
end

function firefly:update(dt)
	self:move(dt)
--	if (since(self.flash_timer) > self.flash_delay) then
		self.sprite_index = self.sprite_index + 1
		self.flash_timer = reset_time()
		if (self.sprite_index == 9) then
			self.sprite_index = 1
		end
--	end
	end

function firefly:draw()
	local x, y = self:getPos()	
	local img  = self:getImage()
	love.graphics.drawq(img, self.images[self.sprite_index or 1], x*self.scale, y*self.scale)
end

function firefly:move(dt)
	local x, y = self:getPos()	
	print("@ " .. x .. " " .. y .. " " .. firefly.facing)
	
	if ((faces[orientation]=="left") and (boulderdash:find(x,y+1).type == "space")) then
		print("move down")
		self:doMove(0,1)
		self:rotateLeft()
	elseif ((faces[orientation]=="down") and (boulderdash:find(x+1,y).type == "space")) then
		print("move right")
		self:doMove(1,0)
		self:rotateLeft()
	elseif ((faces[orientation]=="right") and (boulderdash:find(x,y-1).type == "space")) then
	    print("move up")			    
		self:doMove(0,-1)
		self:rotateLeft()
	elseif ((faces[orientation]=="up") and (boulderdash:find(x-1,y).type == "space")) then
	    print("move left")
		self:doMove(-1,0)
		self:rotateLeft()
	elseif ((faces[orientation]=="left") and (boulderdash:find(x-1,y).type == "space")) then
	    print("move left")
		self:doMove(-1,0)
	elseif ((faces[orientation]=="down") and (boulderdash:find(x,y+1).type == "space")) then
	    print("move down")
		self:doMove(0,1)
	elseif ((faces[orientation]=="right") and (boulderdash:find(x+1,y).type == "space")) then
	    print("move right")
		self:doMove(1,0)
	elseif ((faces[orientation]=="up") and (boulderdash:find(x,y-1).type == "space")) then
	    print("move up")
		self:doMove(0,-1)
	else
		self:rotateRight()
	end
	local x, y = self:getPos()	
	print("> " .. x .. " " .. y .. " " .. firefly.facing)
		
end

return firefly
local diamond = boulderdash.Derive("base")
diamond.hard = true
diamond.rounded = true
diamond.images = {}
diamond.sprite_index = nil

function diamond:load( x, y )
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "diamonds_32.png"))
	for i=0, 32*(8-1), 32 do
		table.insert( self.images, love.graphics.newQuad(i, 0, 32, 32, 32*8, 32) )
	end
	self:setPos( x, y )
end

function diamond:update(dt)
  	self:fall()
	local timer = since(t_minus_zero) % 1
	self.sprite_index = 1 + math.floor(timer / (1/8))
end

function diamond:draw()
	local x, y = self:getPos()	
	local img  = self:getImage()
	love.graphics.drawq(img, self.images[self.sprite_index or 1], x*scale, y*scale)
end

function diamond:consume()
	boulderdash.diamonds = boulderdash.diamonds + 1
end

return diamond
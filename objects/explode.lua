local explode = boulderdash.Derive("base")
explode.images = {}
explode.sprite_index = 1
explode.end_frame = 5
explode.flash_delay = 0.1
explode.flash_timer = 0

function explode:load( x, y )
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "explode.png" ))
	for i=0, 32*(5-1), 32 do
		table.insert( self.images, love.graphics.newQuad(i, 0, 32, 32, 32*5, 32) )
	end
	self:setPos( x, y )
	self.flash_timer = reset_time()
end

function explode:update(dt)
	if (since(self.flash_timer) > self.flash_delay) then
		self.sprite_index = self.sprite_index + 1
		if (self.sprite_index >= self.end_frame) then
			self.sprite_index = self.end_frame
			boulderdash:Replace(self.id, "space")
			boulderdash.start_over = true
		end
		self.flash_timer = reset_time()
	end	
end

function explode:draw()
	local x, y = self:getPos()	
	local img  = self:getImage()
	love.graphics.drawq(img, self.images[self.sprite_index or 1], x*self.scale, y*self.scale)
end

return explode
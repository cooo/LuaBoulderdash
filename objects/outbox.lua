local outbox = boulderdash.Derive("base")
outbox.hard = true
outbox.flash_image = nil
outbox.flash_delay = 0.15
outbox.flash_timer = 0

function outbox:setFlashImage(img)
	self.flash_image = img
end

function outbox:load( x, y )
	self:setImage(     love.graphics.newImage( boulderdash.imgpath .. "steel.png" ))
	self:setFlashImage(love.graphics.newImage( boulderdash.imgpath .. "outbox.png"))
	self:setPos ( x, y )
	
	boulderdash:setGoal( x, y )
end


function outbox:update(dt)
	if not outbox.hard then
		if (since(outbox.flash_timer) > outbox.flash_delay) then
			self.flash_image, self.img = self.img, self.flash_image -- lua's swap trick without temp
			outbox.flash_timer = reset_time()
		end
	end
end

function outbox:draw()	
	-- animation of the outbox starts now	
	if (boulderdash.diamonds >= levels[boulderdash.at_level].diamonds_to_get) then
		outbox.hard = false
	end

	-- no super in lua, so just do it again
	local x, y = self:getPos()	
	local img = self:getImage()
	love.graphics.draw(img, x*self.scale, y*self.scale, 0, 2, 2)
end


return outbox
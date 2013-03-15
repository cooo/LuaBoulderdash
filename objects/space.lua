local space = boulderdash.Derive("base")

function space:load( x, y )
--	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "space.png"))
	self:setPos( x, y )
end

function space:update(dt)

end

function space:draw()	

end

return space
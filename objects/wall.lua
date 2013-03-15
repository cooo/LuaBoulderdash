local wall = boulderdash.Derive("base")
wall.hard = true
wall.rounded = true

function wall:load( x, y )
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "wall.png"))
	self:setPos( x, y )
end

function wall:update(dt)

end

return wall
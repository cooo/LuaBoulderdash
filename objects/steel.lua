local steel = boulderdash.Derive("base")
steel.hard = true
function steel:load( x, y )
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "steel.png"))
	self:setPos( x, y )
end

function steel:update(dt)

end

return steel
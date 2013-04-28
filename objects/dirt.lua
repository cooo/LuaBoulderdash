local dirt = boulderdash.Derive("base")
dirt.hard = true
function dirt:load( x, y )
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "dirt.png"))
	self:setPos( x, y )
end

function dirt:update(dt)

end

function dirt:consume()
	
	play_sound("eat_dirt")
	
	return true
end

return dirt
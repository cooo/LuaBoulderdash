local outbox = boulderdash.Derive("base")
outbox.hard = true

function outbox:load( x, y )
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "outbox.png"))
	self:setPos( x, y )
end

function outbox:update(dt)

end

return outbox
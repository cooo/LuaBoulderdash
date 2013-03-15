local diamond = boulderdash.Derive("base")
diamond.hard = true
diamond.rounded = true


function diamond:load( x, y )
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "diamond.png"))
	self:setPos( x, y )
end

function diamond:update(dt)
  	self:fall()
end

function diamond:consume()
	print("yum!")
end

return diamond
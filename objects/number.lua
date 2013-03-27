local number = boulderdash.Derive("base")

number.quads = {}
number.i = nil

function number:load(x,y)
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "numbers_white.png"))
	for i=0, 16*(10-1), 16 do
		table.insert( self.quads, love.graphics.newQuad(0, i, 32, 16, 32, 16*10) )
	end
	self:setPos( x, y )
end

function number:draw()
	local x, y = self:getPos()
	local img  = self:getImage()
	love.graphics.drawq(img, self.quads[number.i+1], x, y)
end

return number

-- d8fnFas0awa90a
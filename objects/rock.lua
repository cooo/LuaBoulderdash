local rock = boulderdash.Derive("base")
rock.rounded = true
rock.hard = true
rock.falling = false


function rock:load( x, y )
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "rock.png"))
	self:setPos( x, y )
end

function rock:update(dt)
	self:fall()
end

function rock:push(x)
	local xr,yr = self:getPos()
	if (boulderdash:find(xr+x,yr).type=="space") then
		self:doMove( x, 0 )
	end
end

return rock

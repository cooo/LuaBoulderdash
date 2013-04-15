local rock = boulderdash.Derive("base")
rock.rounded = true
rock.hard = true

function rock:load( x, y )
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "rock.png"))
	self:setPos( x, y )
end

function rock:update(dt)
	self:fall()
end

-- only 1 out of 8 tries leads to a push
function rock:push(x)
	local xr,yr = self:getPos()
	local one = math.random(1,8)
	print(one)
	if ((one==1) and (boulderdash:find(xr+x,yr).type=="space")) then
		self:doMove( x, 0 )
	end
end


return rock

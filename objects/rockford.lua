local rockford = boulderdash.Derive("base")
rockford.images = {}
rockford.images.left = {}
rockford.images.right = {}
rockford.images.wink = {}
rockford.images.tap = {}
local random_number
local random_number_lock = false
local sprite_index

function rockford:load( x, y )
	
	files = love.filesystem.enumerate( boulderdash.imgpath .. "rockford" )
	for k, file in ipairs(files) do
		if (file=="rockford.png") then
			self:setImage(love.graphics.newImage( boulderdash.imgpath .. "rockford/rockford.png"))
		else
			local obj_name = string.sub(file,1,string.find(file, ".png") - 1)
			local obj_basename = string.sub(file,1,string.find(file, "_") - 1)
			local img_name = love.graphics.newImage( boulderdash.imgpath .. "rockford/" .. file)
			
			if (obj_basename=="left") then
				rockford.images.left[obj_name] = img_name
			elseif (obj_basename=="right") then
				rockford.images.right[obj_name] = img_name
			elseif (obj_basename=="wink") then
				rockford.images.wink[obj_name] = img_name
			elseif (obj_basename=="tap") then
				rockford.images.tap[obj_name] = img_name
			end
		end
	end
	
	self:setPos( x, y )
	boulderdash:setGoal( x, y )
end

function rockford:update(dt)
	self:move(dt)
	self:he_might_die()
	self:wink()
end

function rockford:default()
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "rockford/rockford.png"))
end

-- move him around or grab something
function rockford:move(dt)

	if not boulderdash.done and not rockford.moved then
		if     love.keyboard.isDown("right") then self:LeftOrRight( 1, love.keyboard.isDown(" ")) 
		elseif love.keyboard.isDown("down")  then self:UpOrDown   ( 1, love.keyboard.isDown(" ")) 
		elseif love.keyboard.isDown("left")  then self:LeftOrRight(-1, love.keyboard.isDown(" ")) 
		elseif love.keyboard.isDown("up")    then self:UpOrDown   (-1, love.keyboard.isDown(" "))
		elseif (#boulderdash.keypressed > 0) then
			local key = table.remove(boulderdash.keypressed, 1)
			if     (key=="right") then self:LeftOrRight( 1, love.keyboard.isDown(" ")) 
			elseif (key=="down")  then self:UpOrDown   ( 1, love.keyboard.isDown(" ")) 
			elseif (key=="left")  then self:LeftOrRight(-1, love.keyboard.isDown(" ")) 
			elseif (key=="up")    then self:UpOrDown   (-1, love.keyboard.isDown(" "))
			end
		end
	end
end

-- when a rock or diamond falls on his head rockford dies
function rockford:he_might_die()
	local xr,yr = self:getPos()
	
	local object = boulderdash:find(xr,yr-1)
	if (object.falling) then
		print("game over")
		boulderdash.dead = true
	end

end

-- he gets a little nervous when he doesn't have anything to do
function rockford:wink()
	local timer = since(idle_time)
	if (timer > 2) then

		if not random_number_lock then
			random_number_lock = true
			random_number = math.random(1,2)
		end
		
		if (random_number==1) then
			rockford:setImgWink(timer)
		else
			rockford:setImgTap(timer)
		end

		if sprite_index==8 then
			random_number_lock = false
			idle_time = reset_time() 
		end 
	end
end



function rockford:LeftOrRight(x, grab)
	print("rockford l.r.")
	table.remove(boulderdash.keypressed, 1)
	if self:canMove( x, 0 ) then
		if grab then
			self:doGrabRockford( x, 0 )
		else
			self:doMoveRockford( x, 0 )
		end
	end
	if (x<0) then
    	self:setImgLeft()
	else
		self:setImgRight()
	end
end

function rockford:UpOrDown(y, grab)
	print("rockford u.d.")
	table.remove(boulderdash.keypressed, 1)
	if self:canMove( 0, y ) then
		if grab then
			self:doGrabRockford( 0, y )
		else
			self:doMoveRockford( 0, y )
		end
	end
end

function rockford:canMove(x,y)
	local xr,yr = self:getPos()
	
	-- get the object where rockford wants to go
	local object = boulderdash:find(xr+x,yr+y)

	if (object.hard and not object.consume) then
		if (object.push) then
			object:push(x)
		end
		return false
	end
	idle_time = love.timer.getMicroTime()	-- the start of idle time

	return rockford:consume(object)
end

function rockford:doMoveRockford(x,y)

	local xr,yr = self:getPos()
	self:doMove(x,y)
	boulderdash:setGoal( xr+x, yr+y )
	-- xr -> xxr
	-- 10 -> 11 no move
	-- 11 -> 10 no move
	-- 11 -> 12 move camera
	-- 12 -> 11 move camera
	if ((xr+x>10 and xr>10) and (xr<27 and xr+x<27)) then
		camera:move(x*self.scale,0)
	end
	if ((yr>7 and yr+y>7) and (yr<13 and yr+y<13)) then
		camera:move(0,y*self.scale)
	end
	
end

function rockford:doGrabRockford(x,y)
	local xr,yr = self:getPos()
	local space = boulderdash.Create( "space", xr+x, yr+y )
	boulderdash.objects[space.id] = space
end

function rockford:consume(object)
	if object.consume then
		return object:consume()
	else
		return true
	end
end

function rockford:setImgLeft()
	local timer = since(t_minus_zero) % 1	
	local sprite_index = 1 + math.floor(timer / (1/8))
	self:setImage(rockford.images.left["left_" .. sprite_index])
end

function rockford:setImgRight()
	local timer = since(t_minus_zero) % 1	
	local sprite_index = 1 + math.floor(timer / (1/8))
	self:setImage(rockford.images.right["right_" .. sprite_index])
end

function rockford:setImgWink(timer)
	sprite_index = math.min(1 + math.floor((timer%1) / (1/16)), 8)
	self:setImage(rockford.images.wink["wink_" .. sprite_index])
end

function rockford:setImgTap(timer)
	sprite_index = math.min(1 + math.floor((timer%1) / (1/16)), 8)
	self:setImage(rockford.images.tap["tap_" .. sprite_index])
end



return rockford
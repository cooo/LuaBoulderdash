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
	self:setImage(love.graphics.newImage( boulderdash.imgpath .. "rockford/rockford.png"))
	
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
end

function rockford:update(dt)
	self:move(dt)
	self:die()
	if no_keys then
		self:setImage(love.graphics.newImage( boulderdash.imgpath .. "rockford/rockford.png"))
	end
	
	self:wink()
	
end

-- when a rock falls on his head rockford dies
function rockford:die()
	local xr,yr = self:getPos()
	
	local object = boulderdash:find(xr,yr-1)
	if (object.falling) then
		print("game over")
		gamePaused = true
	end

end

function rockford:move(dt)
	
	if love.keyboard.isDown("right") then self:moveright(1) end
	if love.keyboard.isDown("down")  then self:movedown(1)  end
	if love.keyboard.isDown("left")  then self:moveleft(-1) end
	if love.keyboard.isDown("up")    then self:moveup(-1)   end
end


function rockford:moveleft(x)
	if self:canMove( x, 0 ) then
		self:doMoveRockford( x, 0 )
	end
    self:setImgLeft()
end

function rockford:moveright(x)
	if self:canMove( x, 0 ) then
		self:doMoveRockford( x, 0 )
	end
	self:setImgRight()
end

function rockford:moveup(y)
	if self:canMove( 0, y ) then
		self:doMoveRockford( 0, y )
	end
end

function rockford:movedown(y)
	if self:canMove( 0, y ) then
		self:doMoveRockford( 0, y )
	end
end

function rockford:canMove(x,y)
	local xr,yr = self:getPos()
	
	-- get the object where rockford wants to go
	local object = boulderdash:find(xr+x,yr+y)

	if (object.hard and not object.consume) then
		print(object.type)
		if (object.type=="rock") then
			object:push(x)
		end
		return false
	end

	rockford:consume(object)
	return true
end

function rockford:doMoveRockford(x,y)
	self:doMove(x,y)
	
	local xr,yr = self:getPos()
	print(xr .. " " .. xr+x)
	if (xr>11 and xr<29) then
		camera:move(x*scale,0)
	end
	if (yr>7 and yr<13) then
		camera:move(0,y*scale)
	end
	
end



function rockford:consume(object)
	if object.consume then
		object:consume()
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

return rockford
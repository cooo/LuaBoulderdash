scoreboard = {}
scoreboard.countdown = nil
scoreboard.one_second_timer = 0
scoreboard.one_second = 1
scoreboard.diamonds_to_get = 0
scoreboard.diamonds_are_worth = 0
scoreboard.extra_diamonds_are_worth = 0
scoreboard.score = 0
scoreboard.numbers_white_img = nil -- move this to a numbers.lua
scoreboard.number_lua = nil
scoreboard.matrix = {}

function scoreboard:load()
	self.countdown                = levels[boulderdash.at_level].cave_time
	self.diamonds_to_get          = levels[boulderdash.at_level].diamonds_to_get
	self.diamonds_are_worth       = levels[boulderdash.at_level].diamonds_are_worth
	self.extra_diamonds_are_worth = levels[boulderdash.at_level].extra_diamonds_are_worth
	self.one_second_timer         = reset_time()
		
	scoreboard.number_lua = love.filesystem.load( boulderdash.objpath .. "number.lua" )
	scoreboard:diamonds()
end

function scoreboard.Create(name, x, y, i)
	x = x or 0
	y = y or 0

	local object = scoreboard.number_lua()
	object:load(x,y,i)
	object.type = name
	object.id = id(x,y)
	scoreboard.matrix[object.id] = object
	return object
end


function scoreboard:update(dt)
	if (since(self.one_second_timer) > self.one_second) then
		self.countdown = self.countdown - 1
		if (self.countdown <= 0) then
			-- explode too?
			self.countdown = 0
			boulderdash.dead = true -- to prevent starting the explode sequence again
		end
		self.one_second_timer = reset_time()
	end
	scoreboard:diamonds()
end

function scoreboard:draw_on_board(str, x)
	
	if (x>=0) then
		local board_to_get = {}
		string.gsub(str, "(.)", function(x) table.insert(board_to_get, x) end)
	
		for i, digit in pairs(board_to_get) do
			-- TODO: take this stuff out of the loop
			scoreboard.Create( "number", x+(i*36), 5, digit )
		end
	end
end

function string.rjust(str, len, pad)
	if string.len(str) >= len then
	 	return str
	else
		return string.rjust(pad .. str, len, pad)
	end
end

function scoreboard:diamonds()
		
	scoreboard:draw_on_board(self.diamonds_to_get, 10)
	scoreboard:draw_on_board(self.diamonds_are_worth, 100)
	
	scoreboard:draw_on_board(boulderdash.diamonds, 250)
	
	scoreboard:draw_on_board(string.rjust(self.countdown,3,"0"), 350)
	scoreboard:draw_on_board(string.rjust(self.score,6,"0"), 500) -- format with 6 positions
	
end

function scoreboard:draw()

	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0, 0, screen_width, 32 )

	-- draw the matrix
	for i, object in pairs(self.matrix) do
		object:draw()
	end

	-- draw a scoreboard on top
	-- 
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 750, 10)
	-- 
	if (boulderdash.diamonds >= self.diamonds_to_get) then
		if not boulderdash.flash then
			love.graphics.setBackgroundColor(255,255,255)
			boulderdash.flash=true
		end
	end
	
	
	
	-- love.graphics.print(self.diamonds_to_get .. " " .. self.diamonds_are_worth, 50, 10)
	-- love.graphics.print(boulderdash.diamonds, 100, 10)
	-- 
	-- love.graphics.print("Score ".. tostring(self.score), 400, 10)
	-- 
	-- love.graphics.print("Time " .. self.countdown, 600, 10)
	-- 
	
end
scoreboard = {}
scoreboard.countdown = nil
scoreboard.one_second_timer = 0
scoreboard.one_second = 1
scoreboard.diamonds_to_get = 0
scoreboard.diamonds_are_worth = 0
scoreboard.extra_diamonds_are_worth = 0
scoreboard.score = 0
scoreboard.numbers_white_img = nil -- move this to a numbers.lua


function scoreboard:load()
	self.countdown                = levels[boulderdash.at_level].cave_time
	self.diamonds_to_get          = levels[boulderdash.at_level].diamonds_to_get
	self.diamonds_are_worth       = levels[boulderdash.at_level].diamonds_are_worth
	self.extra_diamonds_are_worth = levels[boulderdash.at_level].extra_diamonds_are_worth
	self.one_second_timer         = reset_time()
	
	scoreboard.numbers_white_img = love.graphics.newImage( boulderdash.imgpath .. "numbers_white.png")

	for i=0, 32*(8-1), 32 do
		table.insert( self.images, love.graphics.newQuad(i, 0, 32, 32, 32*8, 32) )
	end
	
	
end

function scoreboard:update(dt)
	if (since(self.one_second_timer) > self.one_second) then
		self.countdown = self.countdown - 1
		self.one_second_timer = reset_time()
	end
end

function scoreboard:draw()
	-- draw a scoreboard on top
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0, 0, screen_width, 32 )
	
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 750, 10)
	
	if (boulderdash.diamonds >= self.diamonds_to_get) then
		if not boulderdash.flash then
			love.graphics.setBackgroundColor(255,255,255)
			boulderdash.flash=true
		end
	end
	
	love.graphics.print(self.diamonds_to_get .. " " .. self.diamonds_are_worth, 50, 10)
	love.graphics.print(boulderdash.diamonds, 100, 10)
	
	love.graphics.print("Score ".. tostring(self.score), 400, 10)
	
	love.graphics.print("Time " .. self.countdown, 600, 10)

	
end
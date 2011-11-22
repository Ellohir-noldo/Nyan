require('TEsound')

function love.load()

   -- nyan background
   love.graphics.setBackgroundColor(0,51,102)
   -- nyan sound
   TEsound.playLooping("nyan.wav")
  
    -- Initialize the pseudo random number generator
    math.randomseed( os.time() ) 
    math.random(); math.random(); math.random()
    -- done. :-)
  
   -- nyan cat player
   player_img = love.graphics.newImage("player_sprite.png")
   playerQ = {}
   playerQ[1] = love.graphics.newQuad(0, 0, 66, 64, 512, 64)
   playerQ[2] = love.graphics.newQuad(70, 0, 66, 64, 512, 64)
   playerQ[3] = love.graphics.newQuad(138, 0, 66, 64, 512, 64)
   playerQ[4] = love.graphics.newQuad(208, 0, 66, 64, 512, 64)
   playerQ[5] = love.graphics.newQuad(278, 0, 66, 64, 512, 64)
   playerQ[6] = love.graphics.newQuad(348, 0, 66, 64, 512, 64)
   player_sprite = 1
   
   -- nyan rainbow
   rainbow = love.graphics.newImage("rainbow2.png")
   rainbowQ = love.graphics.newQuad(0, 0, 16, 32, 32, 32)
   
   -- nyan firework
   firework_img = love.graphics.newImage("firework.png")
   fireworkQ = {}
   fireworkQ[1] = love.graphics.newQuad( 0, 0, 20, 40, 128, 64)
   fireworkQ[2] = love.graphics.newQuad( 20, 0, 20, 40, 128, 64)
   fireworkQ[3] = love.graphics.newQuad( 40, 0, 20, 40, 128, 64)
   fireworkQ[4] = love.graphics.newQuad( 60, 0, 20, 40, 128, 64)
   fireworkQ[5] = love.graphics.newQuad( 80, 0, 20, 40, 128, 64)
   fireworkQ[6] = love.graphics.newQuad(100, 0, 20, 40, 128, 64)
   
   fires = {}
   for i = 1, 20 do
       firework = {}
       firework.sprite = math.random(6)
       firework.x = math.random(800)
       firework.y = math.random(600)
       table.insert(fires, firework)
   end
   
   -- nyan position and speed
   x = 400
   y = 300
   speed = 20
   
   -- timed controls buffer Y, 
   -- blink controls player sprites, 
   -- reverse is rainbow movement on Y pos
   timed = 0
   blink = 0
   reverse = 2
   
   -- vampire slayer!
   bufy = {}
   -- initialize ALL THE POSITIONS!
   for i = 1, math.floor(800/16) do
        bufy[i] = 300 -- hidden
    end
   
end


function update_buffer_y()
    -- for all visible pieces of rainbow
    for i = 1, math.floor(x/16) do
        -- get the past next position and apply swinging
        bufy[i] = bufy[i+1] + reverse
    end
    
    for i = math.floor(x/16), math.floor(800/16) do
        bufy[i] = y
    end
    
    
    -- last one is current Y position
    bufy[math.floor(x/16) + 1] = y
end

function love.update(dt)
 
 
      -- sound management
      TEsound.cleanup()
 
     -- bufy updates every 1/10 seconds
    timed = timed + dt
    if timed > 0.1 then
        update_buffer_y()
        for i, firework in ipairs(fires) do
            -- we are traversing though space!
            -- and we leave behind the fireworks
            firework.x = firework.x - 15
        end
        timed = 0
    end

    -- player sprites and rainbow swings every 1/3 seconds
    blink = blink + dt
    if blink > 0.3 then
        -- swing
        reverse = - reverse
        -- sprite update
        if player_sprite > 5 then
            player_sprite = 1
        else 
            player_sprite = player_sprite + 1
        end
        -- firework sprite and creation on end
        for i, firework in ipairs(fires) do
            if firework.sprite > 5 then
                table.remove(fires, i)
                f = {}
                f.sprite = math.random(6)
                f.x = math.random(800)
                f.y = math.random(600)
                table.insert(fires, f)
            else 
                firework.sprite = firework.sprite + 1
            end
        end
        
        blink = 0
    end
    
    -- player movement controls
   if love.keyboard.isDown("right") then
      x = math.ceil(x + (speed * dt))
      if x > 790 then x = 790 end
   elseif love.keyboard.isDown("left") then
      x = math.floor(x - (speed * dt))
      if x < 0 then x = 0 end
   end
    
   if love.keyboard.isDown("down") then
      y = math.ceil(y + (speed/2 * dt))
      if y > 600 then y = 600 end
   elseif love.keyboard.isDown("up") then
      y = math.floor(y - (speed/2 * dt))
      if y < 0 then y = 0 end
   end   
   
end

function love.draw()
    -- draw rainbows
   for i = 1, math.floor(x/16) + 1 do
        love.graphics.drawq(rainbow, rainbowQ, (i -1)*16, bufy[i]-16, 0,1,1)
        --love.graphics.print(i*16, i*16, posy[i])
        --love.graphics.print(posy[i], i*16, posy[i]+16)
   end
      
   -- draw nyan cat
   love.graphics.drawq(player_img, playerQ[player_sprite], x-16, y-16, 0,1,1)
   --love.graphics.print(x.." "..y, x+20, y+40)
   
   -- draw nyan fireworks
   for i, firework in ipairs(fires) do
       love.graphics.drawq(firework_img, fireworkQ[firework.sprite], firework.x, firework.y, 0,1,1)
   end

end
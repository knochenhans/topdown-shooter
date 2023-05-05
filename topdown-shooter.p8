pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

tile_size = 8
player_map_x = 0
player_map_y = 0


function _init()
    setup_player()
    setup_enemy()

    printh(player.walk_anim[current_frame])
end

Character = {
    x = 0.0,
    y = 0.0,
    sprite = 0,
    flip_x = false,
    flip_y = false,
    speed = 1.0,
    walk_anim = {1},
    walking = false,
    current_frame = 1,
    anim_timer = 0,
    player_controlled = false
}

function Character:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Character:move(direction)
    local old_x = self.x
    local old_y = self.y
    local is_walking = false
    local sprite = self.sprite

    if direction == "left" then
        self.x -= self.speed
        sprite += 16
        self.flip_x = true
        is_walking = true
    elseif direction == "right" then
        self.x += self.speed
        sprite += 16
        self.flip_x = false
        is_walking = true
    elseif direction == "up" then
        self.y -= self.speed
        self.flip_y = false
        is_walking = true
    elseif direction == "down" then
        self.y += self.speed
        self.flip_y = true
        is_walking = true
    elseif direction == "up-left" then
        self.x -= self.speed / 2
        self.y -= self.speed / 2
        sprite += 32
        self.flip_x = true
        self.flip_y = false
        is_walking = true
    elseif direction == "down-left" then
        self.x -= self.speed / 2
        self.y += self.speed / 2
        sprite += 32
        self.flip_x = true
        self.flip_y = true
        is_walking = true
    elseif direction == "up-right" then
        self.x += self.speed / 2
        self.y -= self.speed / 2
        sprite += 32
        self.flip_x = false
        self.flip_y = false
        is_walking = true
    elseif direction == "down-right" then
        self.x += self.speed / 2
        self.y += self.speed / 2
        sprite += 32
        self.flip_x = false
        self.flip_y = true
        is_walking = true
    end

    if is_walking then
        self.sprite = self.walk_anim[1]
        self.walking = true
    else
        self.sprite = sprite
        self.walking = false
    end

    local character_map_x = flr((self.x + 4) / tile_size)
    local character_map_y = flr((self.y + 4) / tile_size)

    if fget(mget(character_map_x, character_map_y), 0) then
        self.x = old_x
        self.y = old_y
    end

    -- -- Update the timer
    -- self.anim_timer += 1

    -- -- If the timer has reached the animation speed, switch to the next frame
    -- if self.anim_timer >= 60 / 8 then
    --     self.anim_timer = 0
    --     self.current_frame = self.current_frame % #self.walk_anim + 1
    -- end
end

function setup_player()
    player = Character:new{
        x = 20.0,
        y = 20.0,
        sprite = 1,
        flip_x = true,
        flip_y = false,
        speed = 1.0,
        walk_anim = {1, 2},
        walking = false,
        player_controlled = true
    }
end

function setup_enemy()
    enemy = Character:new{
        x = 40.0,
        y = 40.0,
        sprite = 9,
        flip_x = true,
        flip_y = false,
        speed = 0.5,
        walk_anim = {1},
        walking = false,
        player_controlled = false
    }
end

function _update()
    -- player
    if btn(0) and btn(2) then -- up-left
        player:move("up-left")
    elseif btn(0) and btn(3) then -- down-left
        player:move("down-left")
    elseif btn(1) and btn(2) then -- up-right
        player:move("up-right")
    elseif btn(1) and btn(3) then -- down-right
        player:move("down-right")
    elseif btn(0) then -- left
        player:move("left")
    elseif btn(1) then -- right
        player:move("right")
    elseif btn(2) then -- up
        player:move("up")
    elseif btn(3) then -- down
        player:move("down")
    end

    enemy:move("right")
    
    
    -- if btn(0) or btn(1) or btn(2) or btn(3) then
    --     player.walking = true
    -- else
    --     player.walking = false
    -- end

    -- player_map_x = flr((player.x + 4) / tile_size)
    -- player_map_y = flr((player.y + 4) / tile_size)

    -- -- printh("Player is touching tile at map position (" .. player_map_x .. "," .. player_map_y .. ")")

    -- if fget(mget(player_map_x, player_map_y), 0) then
    --     player.x = old_x
    --     player.y = old_y
    -- end

    -- if check_collision(player.x + 4, player.y + 4) then
    --     printh("test " .. player.x .. "/" .. player.y)
    --     player.x = old_x
    --     player.y = old_y
    -- end

    -- enemy
    -- enemy.x += enemy.speed
end

-- function check_collision(x, y)
--     local box_a = abs_box(a)
--     local box_b = abs_box(b)
    
--     if box_a.x1 > box_b.x2 or
--        box_a.y1 > box_b.y2 or
--        box_b.x1 > box_a.x2 or
--        box_b.y1 > box_a.y2 then
--        return false
--     end
-- end

function _draw()
    cls()
    camera(-64 + player.x, -64 + player.y)

    -- map(player_map_x - 4, player_map_y - 4, 0, 0, player_map_x + 4, player_map_y + 4)
    map(0, 0, 0, 0)

    spr(enemy.sprite, enemy.x, enemy.y, 1, 1)
    
    -- if player.walking then
    --     spr(player.walk_anim[current_frame] + player.sprite, player.x, player.y, 1, 1, player.flip_x, player.flip_y)
    -- else
    spr(player.sprite, player.x, player.y, 1, 1, player.flip_x, player.flip_y)
    -- end
end
__gfx__
00000000000000000000000000000000500000560010101000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000f00ff00f000ff01ff10ff00000506005011d1d1100000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070011555511115555111155551105050500111111d000000000000000000000000000133100000000000000000000000000000000000000000000000000
00077000dd5555dddd5555dddd5555dd0050505001111111000000000000000000000000003bb300000000000000000000000000000000000000000000000000
000770001dd55dd11dd55dd11dd55dd105050600111111d0000000000000000000000000003bb300000000000000000000000000000000000000000000000000
00700700000000000f100000000001f0005050500111111100000000000000000000000000133100000000000000000000000000000000000000000000000000
00000000000000000010000000000100050505001111111000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000050101010000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001d1f00001d1000001d1f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000dd10000fdd100000dd110000100600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000d5500011d5500000d5500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000555f0000555f0000555f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000555f0000555f0000555f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000d5500000d5500011d5500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000dd100000dd11000fdd100000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001d1f00001d1f00001d100060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000ddf00000dd000000ddf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000001ddd5f00dddd5f001ddd5f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dd555f0fdd555f00dd555f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000d5555011d5555000d55550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000555df100555df000555d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000dddd0000dddd0000dddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000dd100000dd100001dd1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000100000001000011f10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0505050505050505050505050505050505050505050505050505050505050505050505050505040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040505050504040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040504040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040504050404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0504040404040404040404040404040404040404040404040404040404040404040404040405040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0505050505050505050505050505050505050505050505050505050505050505050505050505040404040404040404040404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414141414141414140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1414140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

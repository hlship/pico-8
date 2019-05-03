pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- Probably need to create a lerp for a vector instead of
-- a single value.
function lerp(l, h, t)
    return (1 - t) * l + (t * h)
end

-- moves t via speed and r
function vector_move(t)
    t.x += t.speed * cos(t.r) / 60
    t.y += t.speed * sin(t.r) / 60
end


-- rather than worry about z-order, we just have different tables
-- and set render order in code

particles = {}
sprites = {}

-- update methods return true iff sprite/particle/etc. can be deleted

function particle_update(self)
    if (self.age > 60) return true

    self.age +=1

    vector_move(self)
end

-- draw..... methods draw stuff, and return nothing

function particle_draw(self)
    local c = 7
    if (self.age>10) c=6
    if (self.age>20) c=13

    if (self.age>40) c=1

    pset(self.x, self.y, c)
end

function new_particle(x, y, speed, r)
    return {x=x, y=y, age=0, speed=speed, r=r, 
            update=particle_update, draw=particle_draw}
end

function foreachm(coll, method_name)
    for e in all(coll) do
        e[method_name](e)
    end
end

function draw_all(coll)
    foreachm(coll, "draw")
end

function update_all(coll)
    for t in all(coll) do
        if(t:update()) del(coll, t)
    end
end

-- adds vectors a (magnitude and rotation) and b
-- returns mag and rot
function add_vectors(amag, arot, bmag, brot)
    local ax = amag * cos(arot)
    local ay = amag * sin(arot)
    local bx = bmag * cos(brot)
    local by = bmag * sin(brot)
    local rx = ax + bx
    local ry = ay + by
    local r = sqrt(rx * rx + ry * ry)
    return r, atan2(rx, ry)
end


-- The camera moves to follow the ship, the camera will try
-- adto keep the ship centered
viewtrack = {x = 0, y = 0}

-- x,y screen location
-- pgap used to track how often to emit a thrust particle
-- speed pixels/second in direction d
-- r angle of movement
-- d angle of direction (way ship is pointing)
ship = {x = 64, y = 64, pgap = 0, d = .87, speed = 0}

rotspeed = 1 / 60 -- 1 second for full rotation
thrustpower = .5

function ship:update()

    if (btn(➡️)) self.d -= rotspeed
    if (btn(⬅️)) self.d += rotspeed
    local thrust = btn(4)
    
    if thrust then
        self.speed, self.r = add_vectors(self.speed, self.r, thrustpower, self.d)
    else
        -- At slow speeds, apply a damper to stop the ship
        if (self.speed < 10) self.speed=max(0, self.speed - .25)
    end

    vector_move(self)

    if thrust then
        local pspeed, pr = add_vectors(self.speed, self.r, 20, self.d + .5)
        add(particles, new_particle(self.x - 4 * cos(self.d), 
                                    self.y - 4 * sin(self.d),
                                    pspeed, pr))
    end
end

function ship:draw()
    -- print("s=" .. self.speed ..
    --       " d=" .. self.d ..
    --       " r=" .. self.r, 0, 0, 12)

    local cosd = cos(self.d)
    local sind = sin(self.d)

    line(self.x - 3 * cosd, 
         self.y - 3 * sind, 
         self.x + 3 * cosd, 
         self.y + 3 * sind,
         6)
    pset(self.x -4 * cosd, self.y - 4 * sind, 8)

end

function _init()
    ship.r = ship.d

    add(sprites, ship)
end

track_speed = .025

function _update60()
    update_all(particles)
    update_all(sprites)

    -- Have the view track the ship
    viewtrack.x = lerp(viewtrack.x, ship.x - 64, track_speed)
    viewtrack.y = lerp(viewtrack.y, ship.y - 64, track_speed)
end

show_grid = false

function _draw()
    cls() 
    
    camera(viewtrack.x, viewtrack.y)

    color(5)
    
    for i = -1000, 1000, 30 do
        line(i, -1000, i, 1000)
        line(-1000, i, 1000, i)
    end


    draw_all(particles)
    draw_all(sprites)

    camera()
    -- print("speed=" .. ship.speed, 0, 0, 12)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000067000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c6660000666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0086c66700cc60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c6660006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

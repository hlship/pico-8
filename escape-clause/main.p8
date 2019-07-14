pico-8 cartridge // http://www.pico-8.com
version 18
__lua__


-- rather than worry about z-order, we just have different tables
-- and set render order in code

particles = {}
sprites = {}

camera_track = {}

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

    if (btn(5)) self.speed = 0 -- temporary
    
    if thrust then
        self.speed, self.r = add_vectors(self.speed, self.r, thrustpower, self.d)
        self.speed = min(self.speed, 150)

        local pspeed, pr = add_vectors(self.speed, self.r, 20, self.d + .5)

        local r1 = 5 * (rnd(2) - 1)
        local r2 = .01 * (rnd(2) - 1)

        add(particles, new_particle(self.x - 4 * cos(self.d), 
                                    self.y - 4 * sin(self.d),
                                    pspeed + r1, pr + r2))

        if (not (self.thrusting)) sfx(0, 0)
    else
        if (self.thrusting) sfx(-2, 0)
        -- At slow speeds, apply a damper to stop the ship
        if (self.speed < 10) self.speed=max(0, self.speed - .25)
    end

    vector_move(self)

    self.thrusting = thrust
end

function ship:draw()
    local cosd = cos(self.d)
    local sind = sin(self.d)

    line(self.x - 3 * cosd, 
         self.y - 3 * sind, 
         self.x + 3 * cosd, 
         self.y + 3 * sind,
         6)
    pset(self.x -4 * cosd, self.y - 4 * sind, 8)

end

function update_camera()
    local dx = ship.x - 64 - camera_track.x
    local dy = ship.y - 64 - camera_track.y

    local dist = sqrt(dx * dx + dy * dy)

    if (dist < 20) return

    local d = atan2(dx, dy)

    camera_track.x += flr(cos(d) * dist / 20)
    camera_track.y += flr(sin(d) * dist / 20)

end

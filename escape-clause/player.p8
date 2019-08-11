pico-8 cartridge // http://www.pico-8.com
version 18
__lua__


-- x,y screen location
-- speed pixels/second in direction d
-- r angle of movement
-- d angle of direction (way ship is pointing)
ship = {}

function ship:init()
 self.x = 64
 self.y = 64
 self.d = 0
 self.r = 0
 self.speed = 0
end

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

        add(particles, new_particle(self.x - 8 * cos(self.d), 
                                    self.y - 8 * sin(self.d),
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
    spr(0, ship.x - 8, ship.y - 8, 2, 2)
end

function ship:move_camera()
    camera(ship.x - 64, ship.y - 64)
end

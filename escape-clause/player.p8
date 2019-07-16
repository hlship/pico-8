pico-8 cartridge // http://www.pico-8.com
version 18
__lua__


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

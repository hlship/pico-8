pico-8 cartridge // http://www.pico-8.com
version 18
__lua__


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
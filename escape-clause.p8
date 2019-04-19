pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- rather than worry about z-order, we just have different tables
-- and set render order in code

particles = {}
sprites = {}


-- update methods return true iff sprite/particle/etc. can be deleted

function particle_update(self)
    if (self.age > 30) return true

    self.age +=1
end

-- draw methods draw stuff, and return nothing

function particle_draw(self)
    local c = 7
    if (self.age>10) c=6
    if (self.age>20) c=13

    pset(self.x, self.y, c)
end

function new_particle(x, y)
    return {x=x, y=y, age=0, update=particle_update, draw=particle_draw}
end

function do_draw(e) e:draw() end

function draw_all(coll)
    foreach(coll, do_draw)
end

function update_all(coll)
    for t in all(coll) do
        if(t:update()) del(coll, t)
    end
end

ship = {x = 64, y = 64, pgap = 0}

function ship:update()
    local moved = false

    if (btn(➡️)) then moved = true; self.x += 1 end
    if (btn(⬅️)) then moved = true; self.x -= 1 end
    if (btn(⬆️)) then moved = true; self.y -= 1 end
    if (btn(⬇️)) then moved = true; self.y += 1 end

    self.pgap += 1

    if self.pgap > 1 then
        if moved then
            add(particles, new_particle(self.x, self.y))
        end
        self.pgap = 0
    end
end

function ship:draw()
    spr(0, self.x - 4, self.y - 4)
end

function _init()
    add(sprites, ship)
end

function _update60()
    update_all(particles)
    update_all(sprites)
end

function _draw()
    cls()
    color(1)
    print(#particles .. " particles, " .. #sprites .. " sprites", 0, 0)
    draw_all(particles)
    draw_all(sprites)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000667000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c6060000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0866c66700cc06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c6060006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

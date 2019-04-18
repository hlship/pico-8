pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

particles = {}

ship =
    {x = 64, y = 64, pgap = 0,
     update = function(t)
        
        moved = false

        if (btn(1)) then moved = true; t.x += 1 end
        if (btn(0)) then moved = true; t.x -= 1 end
        if (btn(2)) then moved = true; t.y -= 1 end
        if (btn(3)) then moved = true; t.y += 1 end

        t.pgap += 1

        if t.pgap > 1 then
            if moved then
                add(particles, {x = t.x, y = t.y, age=0})
            end
            t.pgap = 0
        end
     end,
     draw = function(t)
        spr(0, t.x - 4, t.y - 4)
    end}

function update_particles()
    for p in all(particles) do
        if p.age > 30 then del(particles, p)
        else
            p.age += 1
        end
    end
end

function draw_particles()
    for p in all(particles) do
        c = 7
        if (p.age>10) c = 6
        if (p.age>20) c = 13

        pset(p.x, p.y, c)
    end
end
    
function _init()

end

-->8
function _update60()
    update_particles()
    ship:update()
end

-->8
function _draw()
    cls()
    --color(7)
    --print(count(particles) .. " particles", 0, 0)
    draw_particles()
    ship:draw()
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000667000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c6060000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0866c66700cc06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c6060006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

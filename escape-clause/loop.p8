pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
    sprites = {}
    particles = {}

    ship:init()

    add(sprites, ship)
end

function _update60()
    update_all(particles)
    update_all(sprites)
end

function _draw()
    cls() 
    color(1)
    
    for i = -1000, 1000, 30 do
        line(i, -1000, i, 1000)
        line(-1000, i, 1000, i)
    end

    ship:move_camera()

    draw_all(particles)
    draw_all(sprites)
end

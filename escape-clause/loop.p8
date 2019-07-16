pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function _init()
    ship.r = ship.d

    add(sprites, ship)

    camera_track.x = ship.x - 64
    camera_track.y = ship.y - 64
end

function _update60()
    update_all(particles)
    update_all(sprites)
    update_camera()
end

function _draw()
    cls() 

    camera(camera_track.x, camera_track.y)
    color(5)
    
    for i = -1000, 1000, 30 do
        line(i, -1000, i, 1000)
        line(-1000, i, 1000, i)
    end


    draw_all(particles)
    draw_all(sprites)

    camera()
end
pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
 
camera_track = {dx=0, dy=0, dist=0, d= 0}

function update_camera()
    local dx = ship.x - 64 - camera_track.x
    local dy = ship.y - 64 - camera_track.y

    local dist = sqrt(dx * dx + dy * dy)

    -- if (dist < 5) return

    local d = atan2(dx, dy)
    local sd = dist / 20 -- scaled distance
    -- / 20 = get there in 20 frames, or 1/3 second

    camera_track.x += cos(d) * sd
    camera_track.y += sin(d) * sd

end
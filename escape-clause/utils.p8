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

function distance(x0, y0, x1, y1)
    local dx = x1 - x0
    local dy = y1 - y0
    return sqrt(dx * dx + dy * dy)
end
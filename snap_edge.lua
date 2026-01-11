-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

beautiful.border_width  = 6
beautiful.border_focus  = "#ff0000"

-- where can be 'left' 'right' 'top' 'bottom' 'center' 'topleft' 'topright' 'bottomleft' 'bottomright' nil
function snap_edge(c, where, geom)
    local sg = screen[c.screen].geometry --screen geometry
    local sw = screen[c.screen].workarea --screen workarea
    local workarea = { x_min = sw.x, x_max=sw.x + sw.width, y_min = sw.y, y_max = sw.y + sw.height } 
    local cg = geom or c:geometry()
    local border   = c.border_width
    local cs = c:struts()
    cs['left'] = 0 cs['top'] = 0 cs['bottom'] = 0 cs['right'] = 0
	if where ~= nil then
		c:struts(cs) -- cancel struts when snapping to edge
	end
    if where == 'right' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height - 12
        cg.x = workarea.x_max - cg.width
        cg.y = workarea.y_min + 24    
    elseif where == 'left' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height - 12
        cg.x = workarea.x_min
        cg.y = workarea.y_min + 24
    elseif where == 'bottom' then
        cg.width  = sw.width
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_min
        cg.y = workarea.y_max - cg.height + 12
        awful.placement.center_horizontal(c)
    elseif where == 'top' then
        cg.width  = sw.width
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_min
        cg.y = workarea.y_min
        awful.placement.center_horizontal(c)
    elseif where == 'topright' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_max - cg.width
        cg.y = workarea.y_min
    elseif where == 'topleft' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_min
        cg.y = workarea.y_min
    elseif where == 'bottomright' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_max - cg.width
        cg.y = workarea.y_max - cg.height + 12
    elseif where == 'bottomleft' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_min
        cg.y = workarea.y_max - cg.height + 12
    elseif where == 'center' then
        c.maximized = not c.maximized
    elseif where == nil then
        c:struts(cs)
        c:geometry(cg)
        return
    end
    c.floating = true
    if c.maximized then c.maximized = false end
    c:geometry(cg)
    awful.placement.no_offscreen(c)
    c:raise()
    return
end


-- gets position in a 3x3 grid (topleft, top, topright....)
local function get_quadrant(cg, wa)
    -- center of the client
    local cx = cg.x + cg.width  / 2
    local cy = cg.y + cg.height / 2
    
    local is_left  = cx < wa.x + wa.width  / 3
    local is_right = cx > wa.x + wa.width  * 2 / 3
    local is_top   = cy < wa.y + wa.height / 3
    local is_bottom = cy > wa.y + wa.height * 2 / 3

    if is_top and is_left then
        return "topleft"
    elseif is_top and is_right then
        return "topright"
    elseif is_top then
        return "top"
    elseif is_bottom and is_left then
        return "bottomleft"
    elseif is_bottom and is_right then
        return "bottomright"
    elseif is_bottom then
        return "bottom"
    elseif is_left then
        return "left"
    elseif is_right then
        return "right"
    else
        return "center"
    end
end

-- where can be 'left' 'right' 'top' 'bottom' nil
function snap_edge_4d(c, where, geom)
    local sg = screen[c.screen].geometry --screen geometry
    local sw = screen[c.screen].workarea --screen workarea
    local workarea = { x_min = sw.x, x_max=sw.x + sw.width, y_min = sw.y, y_max = sw.y + sw.height } 
    local cg = geom or c:geometry()
    local border   = c.border_width
    local cs = c:struts()
    cs['left'] = 0 cs['top'] = 0 cs['bottom'] = 0 cs['right'] = 0
	if where ~= nil then
		c:struts(cs) -- cancel struts when snapping to edge
	end
    
    -- determine on a 3x3 grid, where is the screen currently
    local prev = get_quadrant(cg,sw)
    
    -- half-screen cases
    if prev == 'top' then
        if where == 'right' then 
            where = 'topright'
        elseif where == 'left' then 
            where = 'topleft'
        end
    elseif prev == 'bottom' then
        if where == 'right' then
            where = 'bottomright'
        elseif where == 'left' then
            where = 'bottomleft'
        end
    elseif prev == 'left' then
        if where == 'top' then
            where = 'topleft'
        elseif where == 'bottom' then
            where = 'bottomleft'
        end
    elseif prev == 'right' then
        if where == 'top' then
            where = 'topright'
        elseif where == 'bottom' then
            where = 'bottomright'
        end
    -- corner cases
    elseif prev == 'topleft' then
        if where == 'right' then
            where = 'top'
        elseif where == 'bottom' then
            where = 'left'
        end
    elseif prev == 'topright' then
        if where == 'left' then
            where = 'top'
        elseif where == 'bottom' then
            where = 'right'
        end
    elseif prev == 'bottomleft' then
        if where == 'right' then
            where = 'bottom'
        elseif where == 'top' then
            where = 'left'
        end
    elseif prev == 'bottomright' then
        if where == 'left' then
            where = 'bottom'
        elseif where == 'top' then
            where = 'right'
        end

    -- if center it is fine to move it to the respective half
    elseif where == nil then
        c:struts(cs)
        c:geometry(cg)
        return
    end


    if where == 'right' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height - 12
        cg.x = workarea.x_max - cg.width
        cg.y = workarea.y_min + 24    
    elseif where == 'left' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height - 12
        cg.x = workarea.x_min
        cg.y = workarea.y_min + 24
    elseif where == 'bottom' then
        cg.width  = sw.width
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_min
        cg.y = workarea.y_max - cg.height + 12
        awful.placement.center_horizontal(c)
    elseif where == 'top' then
        cg.width  = sw.width
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_min
        cg.y = workarea.y_min
        awful.placement.center_horizontal(c)
    elseif where == 'topright' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_max - cg.width
        cg.y = workarea.y_min
    elseif where == 'topleft' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_min
        cg.y = workarea.y_min
    elseif where == 'bottomright' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_max - cg.width
        cg.y = workarea.y_max - cg.height + 12
    elseif where == 'bottomleft' then
        cg.width  = sw.width / 2 - 2*border
        cg.height = sw.height / 2 - 2*border
        cg.x = workarea.x_min
        cg.y = workarea.y_max - cg.height + 12
    elseif where == 'center' then
        c.maximized = not c.maximized
    elseif where == nil then
        c:struts(cs)
        c:geometry(cg)
        return
    end
    c.floating = true
    if c.maximized then c.maximized = false end
    c:geometry(cg)
    awful.placement.no_offscreen(c)
    c:raise()
    return
end



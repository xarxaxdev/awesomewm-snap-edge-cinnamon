# awesomewm-snap-edge-cinnamon

Awesomewm keybinding config for replicating cinnamon desktop's directional tiling (Super + Arrow). 

To do this, there are two functions:
- `snap_edge` is what you will find with a short Github search, tiles to the edge of the screen given one of 9 directions given as input (useful for the numpad).
- `snap_edge_4d` is what I have implemented, tiles to the edge of the screen given one of 4 directions + the position of the window given a 3x3 grid (useful for arrow keys). E.g. if a program you have is tiled to the right, and you tile upwards, it will return topright. If you then tile down, it will return right.

Just download:

`curl -o redshift.lua https://raw.githubusercontent.com/xarxaxdev/awesomewm-redshift/refs/heads/main/redshift.lua`

And import on rc.lua:

`local snap_edge = require("snap_edge")`

If you want to make things cinnamon-like, here is how:

`-- Snap to edge/corner - Use numpad
awful.key({ modkey,  }, "#" .. numpad_map[1], function (c) snap_edge(c, 'bottomleft') end),
awful.key({ modkey,  }, "#" .. numpad_map[2], function (c) snap_edge(c, 'bottom') end),
awful.key({ modkey,  }, "#" .. numpad_map[3], function (c) snap_edge(c, 'bottomright') end),
awful.key({ modkey,  }, "#" .. numpad_map[4], function (c) snap_edge(c, 'left') end),
awful.key({ modkey,  }, "#" .. numpad_map[5], function (c) snap_edge(c, 'center') end),
awful.key({ modkey,  }, "#" .. numpad_map[6], function (c) snap_edge(c, 'right') end),
awful.key({ modkey,  }, "#" .. numpad_map[7], function (c) snap_edge(c, 'topleft') end),
awful.key({ modkey,  }, "#" .. numpad_map[8], function (c) snap_edge(c, 'top') end),
awful.key({ modkey,  }, "#" .. numpad_map[9], function (c) snap_edge(c, 'topright') end),
`

`-- Snap to edge/corner - Use arrow keys
awful.key({ modkey,  }, "Down",  function (c) snap_edge_4d(c, 'bottom') end),
awful.key({ modkey,  }, "Left",  function (c) snap_edge_4d(c, 'left') end),
awful.key({ modkey,  }, "Right", function (c) snap_edge_4d(c, 'right') end),
awful.key({ modkey,  }, "Up",    function (c) snap_edge_4d(c, 'top') end),
`

In case you want the "dragging" shortcuts (unrelated to this function) here they are as well:

`-- Move focused client to next tag
awful.key({ "Control", "Shift", "Mod1" }, "Right",
	function(c)
		if not c then return end
        local s = c.screen
        local tags = s.tags
        local current = s.selected_tag
        if not current then return end
        local idx = gears.table.hasitem(tags, current)
        if not idx then return end
        if idx < #tags then
        	local target = tags[idx % #tags + 1]
            c:move_to_tag(target)
            target:view_only() -- optional
        end
    end),
-- Move focused client to previous tag
awful.key({ "Control", "Shift", "Mod1" }, "Left",
	function(c)
    	if not c then return end
        local s = c.screen
        local tags = s.tags
        local current = s.selected_tag
        if not current then return end
        local idx = gears.table.hasitem(tags, current)
        if not idx then return end

        if idx > 1 then
        	local target = tags[(idx - 2) % #tags + 1]
            c:move_to_tag(target)
            target:view_only() -- remove if you don't want to switch
        end
    end,
    {description = "move window to previous workspace", group = "client"}
),
 `


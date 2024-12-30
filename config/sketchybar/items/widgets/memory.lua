local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "memory_update" for
-- the memory load data, which is fired every 1.0 second.
sbar.exec(
	"killall memory_load >/dev/null; $CONFIG_DIR/helpers/event_providers/memory_load/bin/memory_load memory_update 1.0"
)

local memory = sbar.add("graph", "widgets.memory", 42, {
	
    position = "right",
    padding_right = 5,
    padding_left = 5,
    y_offset = 2,
	
    graph = {

		color = colors.blue,
        
	},

    icon = {

        string = "MEM",
        color = colors.white,
        y_offset = 3,

        font = {
            size = 12.0,
        },

        background = {

            color = colors.transparent,
            border_color = colors.transparent,

        },
    },

    background = {

        height = 22,
        color = { alpha = 0 },
        border_color = { alpha = 0 },
        drawing = true,
        corner_radius = 9,

    }
})

local memory_percent = sbar.add("item", "widgets.memory_percent", {

    position = "right",
    
    y_offset = -5,
    width = 0,
    padding_right = -34,

    label = {

        string = "???%",
        color = colors.white,
        align = "left",

        font = {

            family = settings.font.text_mono,
            size = 9.0,

        },

        background = {

            color = colors.transparent,
            border_color = colors.transparent,
            height = 12,

        }
    },

    background = {

        height = 12,
        color = colors.transparent,
        border_color = colors.transparent,

    }
})

-- Background around the memory item
sbar.add("bracket", "widgets.memory.bracket", { memory.name, memory_percent.name }, {
    
    background = {

        height = 22,
        color = colors.bg2,
        border_color = colors.grey,
        border_width = 1,
        corner_radius = 9,
        
    },
    
})

memory:subscribe("memory_update", function(env)
	-- Fetch the used memory percentage from the event provider
	local used_percentage = tonumber(env.used_percentage)
	-- Due what height is not enabled to be set in the graph, divide the value by 150.0
	memory:push({ used_percentage / 150.0 })

	memory_percent:set({
		label = {
			string = string.format("%d", math.floor(used_percentage)) .. "%",
			color = color,
		},

		icon = { color = color },
	})
	-- bracket:set({ background = { border_color = color } })
end)

memory:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a 'Activity Monitor'")
end)

local widget_spacing = sbar.add("item", {
    width = 5,
    label = { drawing = false },
    position = "right",
    background = {
      color = colors.transparent,
      border_color = colors.transparent,
    }
  })
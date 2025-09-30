local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")


local cpu = sbar.add("graph", "widgets.cpu" , 42, {
  
  position = "right",
  -- width = 46,           -- width needs to be hard set in order for the CPU percentage to be under "icon"
  padding_right = 5,
  padding_left = 5,
  y_offset = 2,
  
  graph = {

    color = colors.blue,

  },
  
  icon = {
    
    string = "CPU",
    color = colors.white,
    -- width = 25,
    -- align = "right",
    y_offset = 3,
    -- padding_left = 5,     -- I have no idea why padding_left works here but not for the whole item but padding_right works fine
    
    font = {
      size = 12.0,
    },
    
    background = {
      
      color = colors.transparent,
      border_color = colors.transparent,
      
    }
    
  },
  
  background = {
    
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
    corner_radius = 9,
  
  },

})

-- new item is needed just for the CPU percentage because adding a label to the cpu item will put the string on the right of the graph
local cpu_percent = sbar.add("item", "widgets.cpu_percent", {
  
    position = "right",
    y_offset = -5,
    width = 0,            -- no fucking idea why this fixes the widget to the left from overlapping this widget
    padding_right = -32,

  label = {
    
    string = "???%",
    color = colors.white,
    width = 24,
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

  },

})

cpu:subscribe("cpu_update", function(env)
  -- Also available: env.user_load, env.sys_load
  local load = tonumber(env.total_load)
  cpu:push({ load / 125. })

  local color = colors.blue
  if load > 30 then
    if load < 60 then
      color = colors.yellow
    elseif load < 80 then
      color = colors.orange
    else
      color = colors.red
    end
  end

  env.total_load = string.format("%d", load)

  cpu_percent:set({
    label = string.format("%3d%%", tonumber(env.total_load)),
  })
end)

cpu:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Background around the cpu item
sbar.add("bracket", "widgets.cpu.bracket", { cpu.name, cpu_percent.name }, {
  
  background = {

    height = 22,
    color = colors.bg2,
    border_color = colors.grey,
    border_width = 1,
    corner_radius = 9,

  },

})

local widget_spacing = sbar.add("item", {
  width = 5,
  label = { drawing = false },
  position = "right",
  background = {
    color = colors.transparent,
    border_color = colors.transparent,
  }
})
local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("item", "widgets.battery", {
  position = "right",
  update_freq = 180,
  
  icon = {
    
    -- paddings CAN get wonky when having a set width

    -- width = 40,
    -- align = "right",
    padding_left = 5,   -- padding so the battery icon doesnt stick out
    padding_right = 3,  -- padding between the icon and the label

    font = {

      style = settings.font.style_map["Regular"],
      size = 19.0,

    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 1,
      height = 22,
      corner_radius = 9,

    }

  },
  
  label = {

    -- string = "??%",
    -- width = 45,
    -- align = "left",
    color = colors.white,
    padding_right = 8,  -- padding so the label doesnt stick out
    padding_left = 3,   -- padding so the icon and label do not touch each other

    font = {

      family = settings.font.numbers,

    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 1,
      height = 22,

    }
  },
  

  -- for the double border effect
  background = {

    color = colors.bg2,
    border_color = colors.black,
    border_width = 2,
    height = 22,
    corner_radius = 9,

  },

  popup = {
    align = "center"
  },
})

local remaining_time = sbar.add("item", {
  
  position = "popup." .. battery.name,

  icon = {
    
    string = "Time remaining:",
    -- width = 100,
    align = "left",
    color = colors.white,
    padding_right = 5,  -- the semicolon is being cut off by the label border so we need to add some padding
    padding_left = 10,

    font = {

      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 14.0,

    },

    background = {

      corner_radius = 9,
      height = 22,
      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 2,

      image = {

        corner_radius = 9,
        -- border_color = colors.grey,
        -- border_width = 1

      },

    },

  },

  label = {
    
    string = "??:??h",
    width = 100,
    align = "right",
    color = colors.white,
    padding_right = 10,

    font = {

      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 13.0,

    },

    background = {

      corner_radius = 9,
      height = 22,
      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 2,

      image = {

        corner_radius = 9,
        -- border_color = colors.grey,
        -- border_width = 1

      },

    },

  },

  background = {

    color = colors.bg2,
    border_color = colors.popup.border,
    border_width = 2,
    height = 28,
    corner_radius = 9,

    image = {

      corner_radius = 9,
      border_color = colors.grey,
      border_width = 1

    }

  },

  popup = {
    
    blur_radius = 50,

    background = {

      border_width = 2,
      corner_radius = 9,
      border_color = colors.popup.border,
      color = colors.popup.bg,
      shadow = { drawing = true },

    },
    
  }

})


battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = "!"
    local label = "?"

    local found, _, charge = batt_info:find("(%d+)%%")
    if found then
      charge = tonumber(charge)
      label = charge .. "%"
    end

    local color = colors.green
    local charging, _, _ = batt_info:find("AC Power")

    if charging then
      icon = icons.battery.charging
    else
      if found and charge > 80 then
        icon = icons.battery._100
      elseif found and charge > 60 then
        icon = icons.battery._75
      elseif found and charge > 40 then
        icon = icons.battery._50
      elseif found and charge > 20 then
        icon = icons.battery._25
        color = colors.orange
      else
        icon = icons.battery._0
        color = colors.red
      end
    end

    local lead = ""
    if found and charge < 10 then
      lead = "0"
    end

    battery:set({
      icon = {
        string = icon,
        color = color
      },
      label = {
        string = lead .. label
      },
    })
  end)
end)

battery:subscribe("mouse.clicked", function(env)
  local drawing = battery:query().popup.drawing
  battery:set( { popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("pmset -g batt", function(batt_info)
      local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
      local label = found and remaining .. "h" or "No estimate"
      remaining_time:set( { label = label })
    end)
  end
end)

sbar.add("bracket", "widgets.battery.bracket", { battery.name }, {
  background = {
    color = colors.transparent,
    border_color = colors.grey,
    border_width = 2,
    height = 22,
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
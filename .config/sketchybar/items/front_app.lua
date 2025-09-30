local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = {
    drawing = false,
    background = {
      color = colors.transparent,
      border_color = colors.transparent,
    },
  },
  label = {
    color = colors.white,
    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    },

    background = {
      color = colors.transparent,
      border_color = colors.transparent,
    }
  },

  background = {

    color = colors.transparent,
    border_color = colors.transparent,

  },

  updates = true,
})

front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)

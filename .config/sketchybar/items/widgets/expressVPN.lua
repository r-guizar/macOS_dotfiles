local colors = require("colors")

sbar.add("alias", "ExpressVPN,Item-0", {
    position = "right",

    alias = {
        color = colors.white,
        update_freq = 1,
        scale = 1,
    },

    background = {
        height = 22,
        color = colors.bg2,
        border_color = colors.grey,
        border_width = 1,
        corner_radius = 9,
    }
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
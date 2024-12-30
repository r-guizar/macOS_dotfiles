local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", {
  width = 5,

  background = {

    color = colors.transparent,
    border_color = colors.transparent,

  }
})

local apple = sbar.add("item", {
  icon = {
    string = icons.apple,
    color = colors.white,
    width = 24,
    align = "center",
    -- padding_right = 5,
    -- padding_left = 5,
    
    font = {
      size = 15.0
    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,

    }
  },
  label = { drawing = false },
  background = {
    color = colors.bg2,
    border_color = colors.black,
    border_width = 12
  },
  padding_left = 1,
  padding_right = 1,
  click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0"
})

-- Double border for apple using a single item bracket
sbar.add("bracket", { apple.name }, {
  background = {
    color = colors.transparent,
    height = 24,
    border_color = colors.grey,
    corner_radius = 5,
  }
})

-- Padding item required because of bracket
sbar.add("item", {
  width = 7,
  background = {

    color = colors.transparent,
    border_color = colors.transparent,

  }
})

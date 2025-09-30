local settings = require("settings")
local colors = require("colors")

local cal = sbar.add("item", {
  
  -- width = dynamic,
  -- align = "center",

  icon = {

    -- width = dynamic,
    -- align = "center",
    color = colors.white,
    padding_right = 2,
    padding_left = 5,

    background = {
      height = 16,
      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 1,
    },

    font = {
      style = settings.font.style_map["Black"],
      size = 12.0,
    }

  },

  label = {

    -- width = dynamic,
    -- align = "center",
    color = colors.white,
    padding_left = 2,
    padding_right = 5,

    background = {
      height = 16,
      color = colors.transparent,
      border_color = colors.transparent,
    },

  },

  -- for the double border effect
  background = {
    height = 22,
    color = colors.bg2,
    border_color = colors.grey,
    border_width = 1,
    corner_radius = 9,
  },

  position = "right",
  update_freq = 30,

})

-- -- Adds a double border effect on the background
-- sbar.add("bracket", { cal.name }, {

--   background = {

--     height = 22,
--     color = colors.transparent,
--     border_color = colors.grey,
--     border_width = 1,
--     corner_radius = 9,

--   }

-- })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({ icon = os.date("%a. %b. %d"), label = os.date("%H:%M") })
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
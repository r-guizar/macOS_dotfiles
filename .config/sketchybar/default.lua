local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({

  updates = "when_shown",

  icon = {

    color = colors.red,
    padding_left = 0,
    padding_right = 0,
    
    font = {

      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 14.0,

    },

    background = {

      color = colors.green,
      border_color = colors.magenta,
      border_width = 1,
      
      -- image = {

      --   corner,_radius = 9

      -- }

    },
    
  },
  
  label = {
    
    color = colors.orange,
    padding_left = 0,
    padding_right = 0,

    font = {

      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 13.0,

    },

    background = {

      color = colors.blue,
      border_color = colors.yellow,
      border_width = 1,

      -- image = {

      --   corner_radius = 9

      -- },

    },

  },

  background = {

    color = colors.white,
    border_width = 1,
    border_color = colors.sky_blue,
    
    image = {

      -- corner_radius = 9,
      border_color = colors.white,
      border_width = 1

    },

  },

  popup = {

    background = {

      border_width = 1,
      -- corner_radius = 9,
      border_color = colors.red,
      color = colors.popup.sky_blue,
      
      shadow = {

        drawing = true,

      },

    },

    blur_radius = 50,

  },

  scroll_texts = true,

})
local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local popup_width = 250

local volume_icon = sbar.add("item", "widgets.volume2", {
  
  position = "right",
  
  icon = {
    
    -- width to prevent the item border from changing sizes when the icon changes
    width = 35,
    align = "right",
    color = colors.grey,
    padding_left = 10,
    padding_right = 10,
    
    font = {
      style = settings.font.style_map["Regular"],
      size = 14.0,
    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 1,
      corner_radius = 9,
      height = 22,

    },

  },

  label = {
    
    string = "???%",
    -- width = 0,
    -- align = "left",
    color = colors.white,
    -- padding_left = 15,
    padding_right = 10,
    
    font = {
      family = settings.font.numbers,
    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 1,
      corner_radius = 9,
      height = 22,

    }

  },

  background = {

    color = colors.bg2,
    border_color = colors.grey,
    border_width = 1,
    corner_radius = 9,
    height = 22,

  },

  -- slider popup background
  popup = {

    align = "center",

    background = {

      color = colors.popup.bg,
      border_color = colors.popup.border,
      border_width = 2,
      corner_radius = 9,

      shadow = {
        drawing = true,
      },

    },

  }

})

local volume_slider = sbar.add("slider", popup_width, {
  
  position = "popup." .. volume_icon.name,
  
  slider = {
    
    highlight_color = colors.blue,
    
    background = {
      height = 6,
      corner_radius = 3,
      color = colors.bg2,
    },
    
    knob= {
      string = "􀀁",
      drawing = true,
    },

  },
  
  background = {
    
    -- idk what these colros are for
    -- color = colors.green,
    -- border_color = colors.magenta,
    border_width = 1,
    height = 2,
    y_offset = -20,
    padding_left = 10,    -- padding so the slider does not touch the edge of the popup
    padding_right = 10,
  
  },
  
  click_script = 'osascript -e "set volume output volume $PERCENTAGE"'
  
})

volume_icon:subscribe("volume_change", function(env)
  local volume = tonumber(env.INFO)
  local icon = icons.volume._0
  if volume > 60 then
    icon = icons.volume._100
  elseif volume > 30 then
    icon = icons.volume._66
  elseif volume > 10 then
    icon = icons.volume._33
  elseif volume > 0 then
    icon = icons.volume._10
  end

  local lead = ""
  -- if volume < 10 then
  --   lead = "0"
  -- end

  volume_icon:set({
    icon = icon ,
    label = lead .. volume .. "%",
  })
  volume_slider:set({ slider = { percentage = volume } })
end)

local function volume_collapse_details()
  local drawing = volume_icon:query().popup.drawing == "on"
  if not drawing then return end
  volume_icon:set({ popup = { drawing = false } })
  sbar.remove('/volume.device\\.*/')
end

local current_audio_device = "None"
local function volume_toggle_details(env)
  if env.BUTTON == "right" then
    sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
    return
  end

  local should_draw = volume_icon:query().popup.drawing == "off"
  if should_draw then
    volume_icon:set({ popup = { drawing = true } })
    sbar.exec("SwitchAudioSource -t output -c", function(result)
      current_audio_device = result:sub(1, -2)
      sbar.exec("SwitchAudioSource -a -t output", function(available)
        current = current_audio_device
        local color = colors.grey
        local counter = 0

        for device in string.gmatch(available, '[^\r\n]+') do
          local color = colors.grey
          if current == device then
            color = colors.white
          end
          sbar.add("item", "volume.device." .. counter, {
            
            position = "popup." .. volume_icon.name,
            width = popup_width,
            align = "center",
            
            label = { 
              
              string = device,
              color = color,
              
              background = {
                
                color = colors.transparent,
                border_color = colors.transparent,

              },

            },
            
            background = {
              
              color = colors.transparent,
              border_color = colors.transparent,
              border_width = 1,

            },

            click_script = 'SwitchAudioSource -s "' .. device .. '" && sketchybar --set /volume.device\\.*/ label.color=' .. colors.grey .. ' --set $NAME label.color=' .. colors.white

          })
          counter = counter + 1
        end
      end)
    end)
  else
    volume_collapse_details()
  end
end

local function volume_scroll(env)
  local delta = env.SCROLL_DELTA
  sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end

volume_icon:subscribe("mouse.clicked", volume_toggle_details)
volume_icon:subscribe("mouse.scrolled", volume_scroll)
volume_icon:subscribe("mouse.exited.global", volume_collapse_details)

local widget_spacing = sbar.add("item", {
  width = 5,
  label = { drawing = false },
  position = "right",
  background = {
    color = colors.transparent,
    border_color = colors.transparent,
  }
})
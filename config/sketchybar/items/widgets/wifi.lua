local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "network_update"
-- for the network interface "en0", which is fired every 2.0 seconds.
sbar.exec("killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0")

local popup_width = 250

local wifi = sbar.add("item", "widgets.wifi.ssid_fix", {
  position = "left",
  width = 0,
  label = { drawing = false },
})

local wifi_down_graph = sbar.add("graph", "widgets.wifi_down", 42, {
  
  position = "right",
  -- align = "left",
  padding_left = 2,    -- stupid ass graph doesn't wanna align left so I gotta fix it like this 
  padding_right = 5,
  y_offset = -4,
  
  graph = {
    
    color = colors.blue,
    fill_color = colors.blue,
    line_width = 1,

  },

  background = {

    height = 10,
    color = colors.transparent,
    border_color = colors.transparent,

  }

})

local wifi_down_value = sbar.add("item", "widgets.wifi_down_value", {
  
  position = "right",
  align = "left",
  y_offset = -4,
  width = 0,          -- width to 0 to make the download value be directly below the upload value
  
  label = {
    
    string = "",
    
    font = {
      family = settings.font.text_mono,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },

    background = {

      height = 5,
      color = colors.transparent,
      border_color = colors.transparent,

    }

  },

  background = {

    height = 10,
    color = colors.transparent,
    border_color = colors.transparent,

  },

})

local wifi_up_value = sbar.add("item", "widgets.wifi_up_value", {
  
  position = "right",
  align = "left",
  y_offset = 5,
  width = 0,
  
  label = {
    
    string = "",
    
    font = {
      
      family = settings.font.text_mono,
      style = settings.font.style_map["Bold"],
      size = 9.0,

    },

    background = {

      height = 15,
      color = colors.transparent,
      border_color = colors.transparent,

    }

  },

  background = {

    height = 10,
    color = colors.transparent,
    border_color = colors.transparent,

  },
})

local wifi_up_graph = sbar.add("graph", "widgets.wifi_up", 42, {
  
  position = "right",
  -- align = "right",
  padding_left = 3,
  padding_right = 55,
  y_offset = -4,
  
  graph = {
    
    color = colors.red,
    fill_color = colors.red,
    line_width = 1,

  },

  background = {

    height = 10,
    color = colors.transparent,
    border_color = colors.transparent,

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

-- local native_wifi = sbar.add("alias", "Control Center,WiFi", {
  
--   position = "right",
--   y_offset = -1,
--   padding_left = -8,
--   click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",

--   alias = {
--       color = colors.white,
--       update_freq = 1,
--       scale = 0.8,
--   },

--   background = {
--       height = 22,
--       color = colors.transparent,
--       border_color = colors.transparent,
--       border_width = 1,
--       corner_radius = 9,
--   }
-- })

local wifi_up = sbar.add("item", "widgets.wifi1", {
  
  position = "right",
  -- padding_left = 10,
  -- padding_right = 10,
  
  icon = {

    color = colors.red,
    string = "Unknown SSID",
    
    font = {
      
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 10.0,

    },

    background = {

      height = 10,
      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 1,

    },

  },

  label = {

    -- string = icons.wifi.connected,
    padding_right = 5,
    y_offset = 1,
    align = "center",

    font = {

      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 12.0,

    },

    background = {

      height = 12,
      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 1,

    }

  },

  background = {

    height = 22,
    color = colors.bg2,
    border_color = colors.grey,
    -- color = colors.transparent,
    -- border_color = colors.transparent,
    border_width = 1,
    corner_radius = 9,

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

-- local wifi_bracket = sbar.add("bracket", "widgets.wifi_bracket", { wifi_up.name, native_wifi.name }, {

--   background = {
    
--     height = 22,
--     color = colors.bg2,
--     border_color = colors.grey,
--     border_width = 1,
--     corner_radius = 9,

--   },

-- })

wifi_up:subscribe({"wifi_change", "system_woke"}, function(env)
  
  sbar.exec("ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'", function(result)
    
    local ssid = result:gsub("\n", "")
    
    wifi_up:set({
      
      icon = {
        
        string = ssid,
        color = colors.white,

      },

    })
  end)

  sbar.exec("ipconfig getifaddr en0", function(ip)
    
    local connected = not (ip == "")
    
    wifi_up:set({
      
      icon = {

        width = connected and "dynamic" or 0,
        padding_left = connected and 5 or 0,
        padding_right = connected and 3 or 0,

      },

      label = {
        
        padding_left = connected and 0 or 4,
        string = connected and icons.wifi.connected or icons.wifi.disconnected,
        color = connected and colors.white or colors.red,

      },

    })

    -- native_wifi:set({
      
    --   padding_left = connected and -8 or 0,

    --   alias = { 
    --     color = connected and colors.white or colors.red,
    --   }

    -- })

  end)
end)

local graph_bracket = sbar.add("bracket", "widgets.wifi_upload.bracket", { wifi_down_graph.name, wifi_down_value.name, wifi_up_value.name, wifi_up_graph.name }, {

  background = {
    
    height = 22,
    color = colors.bg2,
    border_color = colors.grey,
    corner_radius = 9,

  },

})

-- Wifi details when clicked
local hostname = sbar.add("item", {
  
  position = "popup." .. wifi_up.name,
  
  icon = {

    color = colors.white,
    padding_left = 7,
    padding_right = 3,
    align = "left",
    string = "Hostname:",
    width = popup_width / 2,

    font = {

      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 14.0

    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,

      image = { 
        corner_radius = 9,
      },

    },
  },

  label = {
    
    color = colors.white,
    padding_right = 7,
    padding_left = 3,
    max_chars = 20,
    string = "????????????",
    width = popup_width / 2,
    align = "right",

    font = {

      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 13.0,

    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 1,

    },
  },
  
  background = {

    color = colors.transparent,
    border_color = colors.transparent,
    border_width = 1,

  }
})

local ip = sbar.add("item", {
  
  position = "popup." .. wifi_up.name,
  
  icon = {

    color = colors.white,
    padding_left = 7,
    padding_right = 3,
    align = "left",
    string = "IP:",
    width = popup_width / 2,

    font = {

      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 14.0,

    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,

      image = { 
        corner_radius = 9,
      },

    },
  },

  label = {
    
    color = colors.white,
    padding_right = 7,
    padding_left = 3,
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",

    font = {

      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 13.0,

    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 1,

    },
  },

  background = {

    color = colors.transparent,
    border_color = colors.transparent,
    border_width = 1,

  },
})

local mask = sbar.add("item", {
  
  position = "popup." .. wifi_up.name,
  
  icon = {
    
    color = colors.white,
    padding_left = 7,
    padding_right = 3,
    align = "left",
    string = "Subnet mask:",
    width = popup_width / 2,

    font = {

      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 14.0,

    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,

      image = { 
        corner_radius = 9,
      },
      
    },
  },

  label = {
    
    color = colors.white,
    padding_right = 7,
    padding_left = 3,
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",

    font = {

      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 13.0,

    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 1,

    },

  },

  background = {

    color = colors.transparent,
    border_color = colors.transparent,
    border_width = 1,

  }

})

local router = sbar.add("item", {
  
  position = "popup." .. wifi_up.name,
  
  icon = {
    
    color = colors.white,
    padding_left = 7,
    padding_right = 3,
    align = "left",
    string = "Router:",
    width = popup_width / 2,

    font = {

      family = settings.font.text,
      style = settings.font.style_map["Bold"],
      size = 14.0

    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,

      image = { 
        corner_radius = 9,
      },

    },
  },

  label = {
    
    color = colors.white,
    padding_right = 7,
    padding_left = 3,
    string = "???.???.???.???",
    width = popup_width / 2,
    align = "right",

    font = {

      family = settings.font.text,
      style = settings.font.style_map["Semibold"],
      size = 13.0,

    },

    background = {

      color = colors.transparent,
      border_color = colors.transparent,
      border_width = 1,

    },

  },

  background = {

    color = colors.transparent,
    border_color = colors.transparent,
    border_width = 1,

  },

})

wifi_up_graph:subscribe("network_update", function(env)

  local function strip_leading_zeroes(value)
    if not value or value == "" then
      return "0"
    end
    value = value:gsub("^0+", "")
    return value == "" and "0" or value
  end

  local upload_value, upload_init = env.upload:match("^(%d+)%s*([KMG]?)")
  local download_value, download_init = env.download:match(("^(%d+)%s*([KMG]?)"))

  local final_upload_value = upload_value
  local final_download_value = download_value

  local unit_multiplier = {
    K = 1024,
    M = 1024 ^ 2,
    G = 1024 ^ 3,
  }

  if upload_init and unit_multiplier[upload_init] then
    upload_value = upload_value * unit_multiplier[upload_init]
  end

  if download_init and unit_multiplier[download_init] then
    download_value = download_value * unit_multiplier[download_init]
  end

  local up_color = colors.red
  local down_color = colors.blue

  wifi_up_graph:push({ upload_value / (2 * 100 * 1024 ^ 2) })
  wifi_down_graph:push({ download_value / (2 * 100 * 1024 ^ 2) })

  local printed_upload = strip_leading_zeroes(final_upload_value) .. " " .. upload_init .. "Bps"
  local printed_download = strip_leading_zeroes(final_download_value) .. " " .. download_init .. "Bps"

  wifi_up_value:set({
		
    label = {
			
      string = string.format("%s%3s %4s", icons.network.upload, strip_leading_zeroes(final_upload_value), upload_init .. "Bps"),
			color = up_color,

		},
	})

  wifi_down_value:set({
    
    label = {
      
      string = string.format("%s%3s %4s", icons.network.download, strip_leading_zeroes(final_download_value), download_init .. "Bps"),
      color = down_color,
    }

  })
end)

local function hide_details()
  wifi_up:set({ popup = { drawing = false } })
end

local function toggle_details()
  local should_draw = wifi_up:query().popup.drawing == "off"
  if should_draw then
    wifi_up:set({ popup = { drawing = true }})
    sbar.exec("networksetup -getcomputername", function(result)
      hostname:set({ label = result })
    end)
    sbar.exec("ipconfig getifaddr en0", function(result)
      ip:set({ label = result })
    end)
    sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'", function(result)
      mask:set({ label = result })
    end)
    sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
      router:set({ label = result })
    end)
  else
    hide_details()
  end
end

wifi_up:subscribe("mouse.clicked", toggle_details)
-- wifi:subscribe("mouse.clicked", toggle_details)
wifi_up:subscribe("mouse.exited.global", hide_details)

local function copy_label_to_clipboard(env)
  local label = sbar.query(env.NAME).label.value
  sbar.exec("echo \"" .. label .. "\" | pbcopy")
  sbar.set(env.NAME, { label = { string = icons.clipboard, align="center" } })
  sbar.delay(1, function()
    sbar.set(env.NAME, { label = { string = label, align = "right" } })
  end)
end

hostname:subscribe("mouse.clicked", copy_label_to_clipboard)
ip:subscribe("mouse.clicked", copy_label_to_clipboard)
mask:subscribe("mouse.clicked", copy_label_to_clipboard)
router:subscribe("mouse.clicked", copy_label_to_clipboard)

local widget_spacing = sbar.add("item", {
  width = 5,
  label = { drawing = false },
  position = "right",
  background = {
    color = colors.transparent,
    border_color = colors.transparent,
  }
})
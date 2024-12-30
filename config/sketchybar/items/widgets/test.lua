local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local test1 = sbar.add("item", "test_name1", {
    label = {
        string = "First Line",
        font = {
            size = 12,
        },
        color = colors.white,
    },
    width = 0,
    y_offset = 5,
    position = "left",
    -- padding_right = 50,
})

local test2 = sbar.add("item", "test_name2", {
    label = {
        string = "Second Line",
        font = {
            size = 12,
        },
        color = colors.white,
    },
    -- width = 5,
    y_offset = -5,
    position = "left",
    -- padding_right = 50,
})

local test_bracket = sbar.add("bracket", "test_bracket", {
    test1.name,
    test2.name,
}, {
    background = { color = colors.bg1 },
})

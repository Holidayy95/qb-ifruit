Config = Config or {}

-- Set to true or false or GetConvar('UseTarget', 'false') == 'true' to use global option or script specific
-- These have to be a string thanks to how Convars are returned.
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

Config.Doorlock = "ox" -- qb or ox
Config.DoorName = "doorID"

Config.Timeout = 30 * (60 * 2000)
Config.RequiredCops = 2
Config.IfruitLocation = {
    ["coords"] = vector3(370.63, 103.85, 103.13),
}

Config.FruitRewards = {
    [1] = {
        ["item"] = "laptop",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 8
        },
    },
    [2] = {
        ["item"] = "samsungphone",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 8
        },
    },
    [3] = {
        ["item"] = "tablet",
        ["amount"] = {
            ["min"] = 1,
            ["max"] = 8
        },
    },
}

Config.Locations = {
    [1] = {
        ["coords"] = vector3(370.57, 96.58, 103.2),
        ["isOpened"] = false,
        ["isBusy"] = false,
    },
    [2] = {
        ["coords"] = vector3(371.25, 95.49, 103.2),
        ["isOpened"] = false,
        ["isBusy"] = false,
    },
    [3] = {
        ["coords"] = vector3(370.64, 94.12, 103.2),
        ["isOpened"] = false,
        ["isBusy"] = false,
    },
    [4] = {
        ["coords"] = vector3(363.39, 96.41, 103.2),
        ["isOpened"] = false,
        ["isBusy"] = false,
    },
}

Config.MaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [18] = true, [26] = true, [52] = true, [53] = true, [54] = true, [55] = true, [56] = true, [57] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [112] = true, [113] = true, [114] = true, [118] = true, [125] = true, [132] = true,
}

Config.FemaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [19] = true, [59] = true, [60] = true, [61] = true, [62] = true, [63] = true, [64] = true, [65] = true, [66] = true, [67] = true, [68] = true, [69] = true, [70] = true, [71] = true, [129] = true, [130] = true, [131] = true, [135] = true, [142] = true, [149] = true, [153] = true, [157] = true, [161] = true, [165] = true,
}

Config.Ifruit = {
    ["thermite"] = {
        {coords = vector4(363.49, 74.56, 98.0, 339.61), anim = vector4(363.49, 74.56, 98.0, 339.61), effect = vector3(363.49, 74.56, 98.0), isOpen = false},
    },
}
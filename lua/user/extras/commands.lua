return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = { preset = "icons" },
    },
    {
        "mrjones2014/legendary.nvim",
        priority = 10000,
        lazy = false,
        -- Legendary handles command palette and keybinding discovery
        opts = { extensions = { which_key = { auto_register = true } } },
    },
}

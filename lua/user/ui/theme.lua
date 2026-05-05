return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- back to the dark mocha look
            transparent_background = false,
            term_colors = true,
            integrations = {
                treesitter = true,
                nvimtree = true,
                lualine = true,
                render_markdown = true, -- Added this since you use it!
            },
        })

        vim.cmd.colorscheme("catppuccin")
    end,
}

return {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
        -- Better commenting (gc)
        require("mini.comment").setup()

        -- Autopairs
        require("mini.pairs").setup()

        -- Surrounding actions (sa, sd, sr)
        require("mini.surround").setup()

        -- Highlight word under cursor
        require("mini.cursorword").setup()
        -- Nice indent guides
        require("mini.indentscope").setup({ symbol = "│" })
    end,
}

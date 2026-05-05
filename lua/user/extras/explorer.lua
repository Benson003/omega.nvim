return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false, -- Needs to be false to hijack netrw on startup
    opts = {
        -- Default keymaps
        keymaps = {
            ["g?"] = "show_help",
            ["<CR>"] = "actions.select",
            ["<C-t>"] = "actions.select_tab",
            ["<C-p>"] = "actions.preview",
            ["<C-c>"] = "actions.close",
            ["<C-l>"] = "actions.refresh",
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["gs"] = "actions.change_sort",
            ["gx"] = "actions.open_external",
            ["g."] = "actions.toggle_hidden",
            ["g\\"] = "actions.toggle_trash",
        },
        -- Configuration for the floating window
        view_options = {
            -- Show files and directories that start with "."
            show_hidden = true,
        },
        -- Use default netrw hijack behavior
        default_file_explorer = true,
    },
    config = function(_, opts)
        require("oil").setup(opts)

        -- Map '-' to open Oil in the current directory
        -- This is the "standard" Oil workflow
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
}

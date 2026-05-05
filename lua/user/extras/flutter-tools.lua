return {

    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    priorty = 1000,
    -- This tells Lazy to load it if a pubspec is in the current directory
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
    config = function()
        require("flutter-tools").setup({
            -- Settings here
        })

        -- Your Which-key registration
        local wk = require("which-key")
        wk.add({
            { "<leader>f",  group = "Flutter" },
            { "<leader>fr", "<cmd>FlutterRun<cr>",       desc = "Run App" },
            { "<leader>fR", "<cmd>FlutterRestart<cr>",   desc = "Hot Restart" },
            { "<leader>fl", "<cmd>FlutterLogToggle<cr>", desc = "Toggle Logs" },
            { "<leader>fd", "<cmd>FlutterDevices<cr>",   desc = "Devices" },
        })
    end,
}

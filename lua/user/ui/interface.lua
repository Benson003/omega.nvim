return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        -- UI Components
        dashboard = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 3000,
            style = "compact", -- Keeps them small and out of the way
        },
        input = { enabled = true },

        -- Extra Functionality
        picker = { enabled = true },
        words = { enabled = true },

        -- Custom styles for a "Halo" feel
        styles = {
            notification = {
                wo = { wrap = true } -- Ensures long Flutter error logs don't cut off
            }
        }
    },
    keys = {
        -- Picker Keymaps
        { "<leader>ff", function() Snacks.picker.files() end,          desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.grep() end,           desc = "Grep" },
        { "<leader>fb", function() Snacks.picker.buffers() end,        desc = "Buffers" },

        -- Notification History (Essential for managing your toasts)
        { "<leader>un", function() Snacks.notifier.show_history() end, desc = "Notification History" },
        { "<leader>ud", function() Snacks.notifier.hide() end,         desc = "Dismiss All Notifications" },

        -- Words (jump between variable occurrences)
        { "[[",         function() Snacks.words.jump(-1) end,          desc = "Prev Reference" },
        { "]]",         function() Snacks.words.jump(1) end,           desc = "Next Reference" },
    },
}

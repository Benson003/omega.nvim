return  {
    "HiPhish/rainbow-delimiters.nvim",
    submodules = false,
    config = function()
        local rb = require("rainbow-delimiters")
        vim.g.rainbow_delimiters = {
            strategy = {
                [""] = rb.strategy["global"], -- Use global strategy by default
            },
            query = {
                [""] = "rainbow-delimiters",
            },
        }
    end,
}
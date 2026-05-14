local M = {}
local state = require("omega.core.state")

function M.init()
    -- 1. Setup the core engine first
    require("omega.core.registry").init()
    require("omega.core.shim").install()

    -- 2. Baseline: Load internal defaults with instrumentation OFF
    -- This ensures defaults populate the state table directly via editor.lua
    state.disable_instrumentation()
    require("omega.core.default").init()

    -- 3. Enable Instrumentation BEFORE loading external configs
    -- This allows the shim to catch standard vim.keymap/vim.opt calls
    state.enable_instrumentation()

    -- 4. Load dynamic content (These will now be caught by the shim)
    require("omega.infra").init()
    require("omega.core.overrides").load()

    -- 5. Finalize: Flush the gathered state to Neovim
    require("omega.core.editor").apply()

    -- 6. Background tasks (Keep this last and deferred)
    vim.defer_fn(function()
        local reg = require("omega.core.registry")

        -- 1. Async Mason Installation
        local tools = reg.get_all_mason_tools()
        local ok_m, mason_reg = pcall(require, "mason-registry")

        if ok_m then
            for _, tool in ipairs(tools) do
                mason_reg.refresh(function()
                    local ok_p, p = pcall(mason_reg.get_package, tool)
                    if ok_p and not p:is_installed() then
                        p:install()
                    end
                end)
            end
        end

        -- 2. Treesitter Parsers
        local parsers = reg.get_all_treesitter_parsers()
        for _, p in ipairs(parsers) do
            local has_parser = #vim.api.nvim_get_runtime_file("parser/" .. p .. ".*", false) > 0
            if not has_parser then
                vim.schedule(function()
                    local cmd = string.format("TSInstall %s", p)
                    pcall(vim.cmd, cmd)
                end)
            end
        end
    end, 200)
end

return M

local M = {}
local state = require("omega.core.state")

function M.init()
    -- 1. Setup the core engine (Must be immediate)
    require("omega.core.registry").init()
    require("omega.core.shim").install()

    -- 2. Baseline: Load internal defaults with instrumentation OFF
    -- This is safe to do immediately as it has no external dependencies
    state.disable_instrumentation()
    require("omega.core.default").init()
    state.enable_instrumentation()

    -- 3. THE FIX: Schedule the "Heavy Lifting"
    -- This moves Step 4 & 5 to the next event loop tick.
    -- By then, Lazy.nvim will have initialized the Runtime Path (rtp).
    vim.schedule(function()
        -- Load dynamic content (Caught by shim)
        -- This will now find 'snacks' and 'blink' because rtp is ready
        require("omega.infra").init()
        require("omega.core.overrides").load()

        -- Finalize: Flush everything to Neovim
        require("omega.core.editor").apply()
    end)

    -- 4. Background tasks (Keep this deferred as is)
    vim.defer_fn(function()
        local reg = require("omega.core.registry")

        -- Async Mason Installation
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

        -- Treesitter Parsers
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

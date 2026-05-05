
-- lsp.handler
local M = {}

function M.attach(bufnr, servers)
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    for name, opts in pairs(servers) do
        -- 1. Use Registry opts, then Neovim internal config, then name as fallback
        local base_config = vim.lsp.config[name] or {}
        local cmd = opts.cmd or base_config.cmd or { name }

        local final_config = {
            name = name,
            cmd = cmd,
            settings = opts.settings or base_config.settings or {},
            capabilities = capabilities,
            env = opts.cmd_env or {},
        }

        vim.lsp.start(final_config, { bufnr = bufnr })
    end
end

return M


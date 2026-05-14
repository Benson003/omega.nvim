-- lsp.handler
local M = {}

function M.attach(bufnr, servers)
    -- 1. Defensive check for blink.cmp
    local has_blink, blink = pcall(require, 'blink.cmp')

    -- Fallback capabilities if blink isn't loaded yet
    local capabilities = has_blink
        and blink.get_lsp_capabilities()
        or vim.lsp.protocol.make_client_capabilities()

    for name, opts in pairs(servers) do
        -- 2. Use Registry opts, then Neovim internal config, then name as fallback
        local base_config = vim.lsp.config[name] or {}
        local cmd = opts.cmd or base_config.cmd or { name }

        local final_config = {
            name = name,
            cmd = cmd,
            settings = opts.settings or base_config.settings or {},
            capabilities = capabilities,
            env = opts.cmd_env or {},
        }

        -- 3. Start the LSP
        vim.lsp.start(final_config, { bufnr = bufnr })
    end
end

return M

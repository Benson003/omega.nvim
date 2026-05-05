local M = {}

function M.attach(bufnr, ts_spec)
    if not ts_spec or not ts_spec.host then return end

    -- Activate highlighting for the specific host language
    local ok, _ = pcall(vim.treesitter.start, bufnr, ts_spec.host)
    if not ok then
        return
    end
    -- Injections are handled automatically by Neovim if the parsers
    -- are present in the rtp, which our provisioner ensures.
end

return M

local M = {}

function M.attach(bufnr, ts_spec)
    if not ts_spec or not ts_spec.host then return end

    -- Check if parser is actually available in the runtime path
    local has_parser = #vim.api.nvim_get_runtime_file("parser/" .. ts_spec.host .. ".*", false) > 0
    if not has_parser then return end

    pcall(vim.treesitter.start, bufnr, ts_spec.host)
end

return M

local M = {}

function M.attach(bufnr)
    -- This is safe; it's standard Neovim
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Only reload blink if it's actually loaded
    local ok, blink = pcall(require, "blink.cmp")
    if ok then
        pcall(blink.reload) -- Uncomment if you need the force refresh
    end
end

return M

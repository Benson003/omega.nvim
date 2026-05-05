
local M = {}


function M.attach(bufnr)
    -- Ensure the LSP is the primary source for this buffer
    -- This helps blink coordinate with the LSP attached by your resolver
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    
    -- Optional: If you want to force a blink refresh when the resolver attaches
    -- pcall(require('blink.cmp').reload) 
end

return M


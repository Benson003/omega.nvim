
local M = {}

function M.init()
    -- Add Mason's bin folder to the path so vim.lsp.start can find gopls, etc.
    local mason_path = vim.fn.stdpath("data") .. "/mason/bin"
    vim.env.PATH = mason_path .. ":" .. vim.env.PATH

    require("omega.infra.resolver").setup()

    if vim.bo.filetype ~= "" then
        require("omega.infra.resolver").resolve(vim.api.nvim_get_current_buf())
    end
end

return M


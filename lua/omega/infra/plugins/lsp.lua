return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        -- Core logic for LSP will live here later,
        -- but it will be triggered by BufAttach/FileType
    end
}

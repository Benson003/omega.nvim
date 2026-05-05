return {
    "typescript",
    filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    treesitter = { host = "typescript", injections = { "tsx" } },
    lsp = {
        servers = { 
            vtsls = { 
                settings = { completeFunctionCalls = true } 
            } 
        }
    },
    tools = {
        mason = { ensure_installed = { "vtsls", "prettierd" } },
        formatter = { preferred = { "prettierd" } }
    }
}

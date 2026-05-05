return {
    "go",
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    treesitter = { host = "go" },
    lsp = {
        servers = {
            gopls = {
                settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } }
            }
        }
    },
    tools = {
        mason = { ensure_installed = { "gopls", "goimports", "golines" } },
        formatter = { preferred = { "goimports", "golines" } },
    }
}

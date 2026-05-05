return {
    "web",
    filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },

    treesitter = {
        host = "javascript",
        injections = { "html", "css" },
    },

    lsp = {
        servers = {
            html = {},
            cssls = {},
            tsserver = {
                settings = {
                    completions = {
                        completeFunctionCalls = true,
                    },
                },
            },
        },
    },

    tools = {
        mason = {
            ensure_installed = {
                "html-lsp",
                "css-lsp",
                "typescript-language-server",
                "prettier",
            },
        },

        formatter = {
            preferred = { "prettier" },
        },
    },
}

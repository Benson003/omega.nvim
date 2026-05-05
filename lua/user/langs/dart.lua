return {
    "dart",
    filetypes = { "dart" },
    treesitter = { host = "dart" },
    lsp = {
        servers = {
            dartls = {
                settings = {
                    dart = { completeFunctionCalls = true, showTodos = true }
                }
            }
        }
    },
    tools = {
        formatter = { preferred = { "dart_format" } },
    }
}

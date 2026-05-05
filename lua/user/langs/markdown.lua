return {
    "markdown",
    filetypes = { "markdown" },
    treesitter = { host = "markdown", injections = { "markdown_inline" } },
    lsp = {
        servers = { marksman = {} }
    },
    tools = {
        formatter = { preferred = { "prettierd" } }
    }
}

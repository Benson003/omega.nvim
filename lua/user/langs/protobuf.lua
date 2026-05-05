return {
    "proto",
    filetypes = { "proto" },
    treesitter = { host = "proto" },
    lsp = {
        servers = { bufls = {} }
    },
    tools = {
        mason = { ensure_installed = { "buf" } },
        formatter = { preferred = { "buf" } }
    }
}

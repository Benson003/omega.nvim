return {
    "zig",
    filetypes = { "zig" },
    treesitter = { host = "zig" },
    lsp = {
        servers = { zls = {} }
    },
    tools = {
        mason = { ensure_installed = { "zls" } },
        formatter = { preferred = { "zigfmt" } }
    }
}

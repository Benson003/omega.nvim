return {
    "c/cpp",
    filetypes = { "c", "cpp", "objc", "objcpp" },
    treesitter = { host = "cpp" },
    lsp = {
        servers = { clangd = { capabilities = { offsetEncoding = { "utf-16" } } } }
    },
    tools = {
        mason = { ensure_installed = { "clangd", "clang-format" } },
        formatter = { preferred = { "clang-format" } }
    }
}

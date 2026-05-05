return {
    "lua",
    filetypes = { "lua" },

    treesitter = {
        host = "lua",
        injections = { "luadoc", "vimdoc" },
    },

    lsp = {
        servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            checkThirdParty = false,
                            -- This is the magic line for completion:
                            library = {
                                vim.env.VIMRUNTIME,
                                -- Also include the 'lua' directory of your config
                                vim.fn.stdpath("config") .. "/lua"
                            },
                        },
                    },
                },
            },
        },
    },

    tools = {
        mason = {
            ensure_installed = { "lua-language-server", "stylua", "selene" },
        },
        formatter = {
            preferred = { "stylua" },
        },
        linter = {
            preferred = { "selene" },
        },
    },
}

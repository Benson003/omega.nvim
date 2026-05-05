return {
    "svelte",
    filetypes = { "svelte" },
    treesitter = { host = "svelte" },
    lsp = {
        servers = {
            svelte = {
                settings = {
                    svelte = {
                        plugin = {
                            svelte = { enabled = true },
                            typescript = { enabled = true },
                            -- Disable semantic tokens inside the server settings too
                            -- Treesitter is better at this anyway
                            semanticTokens = { enabled = false }
                        }
                    },
                    -- Add this to stabilize the TS service inside Svelte
                    typescript = {
                        updateImportsOnFileMove = { enabled = "always" }
                    }
                },

                -- Force Neovim to ignore semantic tokens for this client
                -- This prevents the "death mid-way" because Nvim stops asking for them
                on_attach = function(client, bufnr)
                    client.server_capabilities.semanticTokensProvider = nil
                end,
            }
        }
    }
}

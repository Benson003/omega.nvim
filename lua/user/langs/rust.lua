return {
    name = "rust",
    filetypes = { "rust" },
    treesitter = {
        host = "rust",
        -- Ensure we get comment highlights and doc-test support
        injections = { "rust", "comment","toml" }
    },
    lsp = {
        servers = {
            rust_analyzer = {
                -- Inlay hints are now a top-level concern in Neovim 0.10+
                on_attach = function(client, bufnr)
                    if vim.lsp.inlay_hint then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    end
                end,
                settings = {
                    ["rust-analyzer"] = {
                        -- Use Bacon for background checking if installed,
                        -- otherwise clippy is the standard baseline.
                        checkOnSave = true,
                        -- Enhanced Hints for better "Hard Mode" context
                        inlayHints = {
                            bindingModeHints = { enabled = true },
                            chainingHints = { enabled = true },
                            closingBraceHints = { enabled = true },
                            parameterHints = { enabled = true },
                            typeHints = { enabled = true },
                        },
                        procMacro = { enabled = true },
                        diagnostics = {
                            enable = true,
                            -- Prevents the LSP from fighting with Bacon
                            disabled = { "unresolved-proc-macro" },
                        },
                    }
                }
            }
        }
    },
    tools = {
        mason = {
            ensure_installed = { "rust-analyzer", "bacon", "rustfmt" }
        },
        formatter = {
            preferred = { "rustfmt" }
        },
    }
}

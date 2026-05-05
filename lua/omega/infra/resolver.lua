local M = {}
local registry = require("omega.core.registry")
local active_buffers = {} -- bufnr -> spec_names[]

function M.detach(bufnr)
    if not active_buffers[bufnr] then return end

    -- Clean up buffer-local variables or tool states if necessary
    -- (LSPs handle their own detachment usually, but we stop tracking here)
    active_buffers[bufnr] = nil
end

function M.resolve(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then return end

    local ft = vim.bo[bufnr].filetype
    if ft == "" then return end

    local specs = registry.get_specs(ft)
    if #specs == 0 then return end

    -- Mark this buffer as active
    active_buffers[bufnr] = {}

    for _, spec in ipairs(specs) do
        table.insert(active_buffers[bufnr], spec.name)

        -- 1. Treesitter (Handled natively, but we ensure it's started)
        require("omega.infra.handlers.treesitter").attach(bufnr, spec.treesitter)

        -- 2. LSP (Using LspStart logic to keep it reactive)
        if spec.lsp and spec.lsp.servers then
            require("omega.infra.handlers.lsp").attach(bufnr, spec.lsp.servers)
        end
        require("omega.infra.handlers.completion").attach(bufnr)


        if spec.tools then
            require("omega.infra.handlers.tools").attach(bufnr, spec.tools)
            M.setup_tool_triggers(bufnr, spec.tools)
        end
    end
end

function M.setup_tool_triggers(bufnr, tools_spec)
    local group = vim.api.nvim_create_augroup("OmegaAutoTools_" .. bufnr, { clear = true })

    -- 1. Auto-Format on Save

-- Inside setup_tool_triggers
if tools_spec.formatter and tools_spec.formatter.format_on_save then
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        buffer = bufnr,
        callback = function()
            -- Force sync formatting to ensure it finishes before write
            require("conform").format({ 
                bufnr = bufnr, 
                lsp_fallback = true,
                quiet = false -- Set to false to see error messages
            })
        end,
    })
end
    -- 2. Lint on Save / Text Changed
    if tools_spec.linter then
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
            group = group,
            buffer = bufnr,
            callback = function()
                require("lint").try_lint()
            end,
        })
    end
end

function M.setup()
    local group = vim.api.nvim_create_augroup("OmegaResolver", { clear = true })

    -- Triggered when a filetype is set or changed
    vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
        group = group,
        callback = function(args)
            M.resolve(args.buf)
        end,
    })

    -- Clean up when the buffer is removed from memory
    vim.api.nvim_create_autocmd("BufUnload", {
        group = group,
        callback = function(args)
            M.detach(args.buf)
        end,
    })
end

return M

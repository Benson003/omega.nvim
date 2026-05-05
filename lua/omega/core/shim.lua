local editor = require("omega.core.editor")
local state = require("omega.core.state")
local M = {}

local original = {
    keymap_set = vim.keymap.set,
    create_cmd = vim.api.nvim_create_user_command,
    create_autocmd = vim.api.nvim_create_autocmd,
}

-- A private lock to prevent the shim from calling itself
local is_applying = false

function M.install()
    -- Keymaps
    vim.keymap.set = function(mode, lhs, rhs, opts)
        if state.instrumentation and not is_applying then
            is_applying = true
            editor.keymap(mode, lhs, rhs, opts)
            is_applying = false
        end
        return original.keymap_set(mode, lhs, rhs, opts)
    end

    -- User Commands
    vim.api.nvim_create_user_command = function(name, fn, opts)
        if state.instrumentation and not is_applying then
            is_applying = true
            editor.command(name, fn, opts)
            is_applying = false
        end
        return original.create_cmd(name, fn, opts)
    end

    -- Autocommands
    vim.api.nvim_create_autocmd = function(event, opts)
        if state.instrumentation and not is_applying then
            is_applying = true
            editor.autocmd(event, opts)
            is_applying = false
        end
        return original.create_autocmd(event, opts)
    end

    -- Options (vim.opt)
    -- Note: This only catches direct assignments like vim.opt.number = true
    setmetatable(vim.opt, {
        __newindex = function(_, key, value)
            if state.instrumentation and not is_applying then
                editor.opt(key, value)
            end
            -- We don't need a lock for opt because editor.apply 
            -- should use nvim_set_option_value directly
        end,
    })
end

return M
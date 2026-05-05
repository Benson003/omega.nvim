-- Disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- Use system clipboard

-- Fix for Wayland (wl-copy)
if os.getenv("WAYLAND_DISPLAY") then
    vim.g.clipboard = {
        name = "wl-utils",
        copy = {
            ["+"] = "wl-copy",
            ["*"] = "wl-copy",
        },
        paste = {
            ["+"] = "wl-paste",
            ["*"] = "wl-paste",
        },
        cache_enabled = 1,
    }
end

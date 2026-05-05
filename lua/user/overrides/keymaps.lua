local modes = { "n", "v" }
local arrows = { "<Up>", "<Down>", "<Left>", "<Right>" }

-- Hard Mode
for _, mode in ipairs(modes) do
    for _, arrow in ipairs(arrows) do
        vim.keymap.set(mode, arrow, function()
            vim.notify("Use HJKL to move!", vim.log.levels.WARN, { title = "Hard Mode" })
        end, { desc = "Force HJKL" })
    end
end

-- Stay in visual mode while indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- File Management
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")


-- Move selected lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- "Greatest Paste"
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Git Hunks (Fixed: Removed the undefined 'bufnr' variable)
vim.keymap.set('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
vim.keymap.set('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

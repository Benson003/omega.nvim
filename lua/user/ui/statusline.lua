return {
    "rebelot/heirline.nvim",
    lazy = false,
    priority = 1000,
    dependencies = {
        {
            "lewis6991/gitsigns.nvim",
            event = { "BufReadPre", "BufNewFile" },
            opts = { diff_opts = { internal = true } }
        }
    },
    config = function()
        local heirline = require("heirline")
        local utils = require("heirline.utils")

        local setup_colors = function()
            return {
                bg_dark  = utils.get_highlight("StatusLine").bg,
                bg_light = utils.get_highlight("Folded").bg,
                fg       = utils.get_highlight("StatusLine").fg,
                blue     = utils.get_highlight("Function").fg,
                green    = utils.get_highlight("String").fg,
                purple   = utils.get_highlight("Statement").fg,
                orange   = utils.get_highlight("DiagnosticWarn").fg,
                red      = utils.get_highlight("DiagnosticError").fg,
                cyan     = utils.get_highlight("Special").fg,
            }
        end

        local ViMode = {
            init = function(self) self.mode = vim.fn.mode(1) end,
            static = {
                mode_map = {
                    n = { "NORMAL", "blue" }, i = { "INSERT", "green" },
                    v = { "VISUAL", "purple" }, V = { "V-LINE", "purple" },
                    c = { "COMMAND", "orange" }, R = { "REPLACE", "red" },
                }
            },
            provider = function(self)
                local m = self.mode:sub(1, 1)
                return "  ● " .. (self.mode_map[m] and self.mode_map[m][1] or "??") .. " "
            end,
            hl = function(self)
                local m = self.mode:sub(1, 1)
                local color_key = (self.mode_map[m] and self.mode_map[m][2]) or "fg"
                local colors = self.colors or setup_colors()
                return { fg = colors[color_key], bg = colors.bg_light, bold = true }
            end,
            update = { "ModeChanged", pattern = "*:*" }
        }

        local FileName = {
            provider = function()
                local dir = vim.fn.expand("%:p:h:t")
                local file = vim.fn.expand("%:t")
                return "  " .. dir .. "/" .. (file == "" and "[No Name]" or file) .. " "
            end,
            hl = function(self) 
                local colors = self.colors or setup_colors()
                return { fg = colors.fg } 
            end,
        }

        local Git = {
            condition = function() return vim.b.gitsigns_head ~= nil end,
            provider = function() return "  " .. vim.b.gitsigns_head .. " " end,
            hl = function(self) 
                local colors = self.colors or setup_colors()
                return { fg = colors.purple, bold = true } 
            end,
            update = { "User", pattern = "GitsignsUpdate" }
        }

        local LSPMessages = {
            provider = function()
                local status = vim.lsp.status()
                if status == "" then return "" end
                return " ⚙ " .. (#status > 45 and status:sub(1, 43) .. "..."or status) .. " "
            end,
            hl = function(self) 
                local colors = self.colors or setup_colors()
                return { fg = colors.cyan, italic = true } 
            end,
            update = { "LspProgress", "LspAttach", "LspDetach" },
        }

        local Diagnostics = {
            condition = function() return #vim.diagnostic.get(0) > 0 end,
            update = { "DiagnosticChanged", "BufEnter" },
            {
                provider = function()
                    local n = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                    return n > 0 and ("  " .. n .. " ")
                end,
                hl = function(self) 
                    local colors = self.colors or setup_colors()
                    return { fg = colors.red } 
                end,
            },
            {
                provider = function()
                    local n = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                    return n > 0 and ("  " .. n .. " ")
                end,
                hl = function(self) 
                    local colors = self.colors or setup_colors()
                    return { fg = colors.orange } 
                end,
            },
        }

        local Time = {
            provider = function() return " " .. os.date("%H:%M") .. " " end,
            hl = function(self) 
                local colors = self.colors or setup_colors()
                return { fg = colors.fg, bg = colors.bg_light, italic = true } 
            end,
        }

        heirline.setup({
            statusline = {
                hl = function(self) 
                    local colors = self.colors or setup_colors()
                    return { bg = colors.bg_dark, fg = colors.fg } 
                end,
                ViMode,
                FileName,
                { provider = "%=" },
                LSPMessages,
                { provider = "%=" },
                Diagnostics,
                Git,
                Time,
            },
            opts = { colors = setup_colors }
        })
    end,
}

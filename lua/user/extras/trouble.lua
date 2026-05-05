return {
		"folke/trouble.nvim",
		dependencies = "nvim-web-devicons",
		cmd = { "TroubleToggle", "Trouble" },
		config = function()
			require("trouble").setup({
				position = "bottom",
				height = 10,
				icons = true,
				mode = "workspace_diagnostics",
				fold_open = "",
				fold_closed = "",
				action_keys = {
					close = "q",
					cancel = "<esc>",
					refresh = "r",
					jump = { "<cr>", "<tab>" },
					open_split = { "<c-x>" },
					open_vsplit = { "<c-v>" },
					open_tab = { "<c-t>" },
					toggle_fold = "z",
					previous = "k",
					next = "j",
				},
			})
		end
}



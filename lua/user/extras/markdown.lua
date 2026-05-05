return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
  keys = {
    { "<leader>m", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
  },
  opts = {},
}


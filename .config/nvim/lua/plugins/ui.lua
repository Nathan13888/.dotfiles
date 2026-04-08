return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>n", "<cmd>Neotree toggle<cr>", desc = "File explorer" },
      { "<leader>N", "<cmd>Neotree reveal<cr>", desc = "Reveal in explorer" },
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = { visible = true },
      },
    },
  },

  -- Keymap discovery
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>h", group = "git hunks" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>c", group = "code" },
        { "<leader>g", group = "git" },
        { "<leader>r", group = "refactor" },
        { "<leader>d", group = "debug" },
      },
    },
  },

  -- Diagnostics list
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "All diagnostics" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
    },
    opts = {},
  },

  -- TODO comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VimEnter",
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "TODOs in Trouble" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
    },
  },
}

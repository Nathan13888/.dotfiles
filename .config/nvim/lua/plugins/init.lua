return {
  -- Treesitter: syntax highlighting & indentation
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "rust", "typescript", "tsx", "javascript", "go", "python", "lua",
        "bash", "json", "yaml", "toml", "html", "css", "markdown",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- Mason: auto-install language servers
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "rust_analyzer", "ts_ls", "gopls", "pyright", "lua_ls",
      },
    },
  },

  -- LSP config (vim.lsp.config API, nvim 0.11+)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      vim.lsp.enable({ "rust_analyzer", "ts_ls", "gopls", "pyright", "lua_ls" })
    end,
  },

  -- Autocompletion
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = { preset = "default" },
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true },
    },
  },

  -- Format on save
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
        typescript = { "biome" },
        javascript = { "biome" },
        typescriptreact = { "biome" },
        javascriptreact = { "biome" },
        go = { "gofmt" },
        python = { "ruff_format" },
        lua = { "stylua" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>" },
    },
  },

  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },

  -- Diagnostics list
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" },
    },
    opts = {},
  },

  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    opts = {},
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  -- Tpope essentials
  "tpope/vim-surround",
  "tpope/vim-commentary",
  "tpope/vim-sleuth",

  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = { flavour = "mocha" },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

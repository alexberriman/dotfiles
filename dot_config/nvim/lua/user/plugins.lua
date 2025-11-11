return {
  -- Catppuccin Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Load before other plugins
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvim_tree = true,
          treesitter = true,
          telescope = true,
          trouble = true,
          mason = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end
  },

  { "nvim-lua/plenary.nvim", lazy = true },

  { "nvim-tree/nvim-tree.lua", cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    config = function()
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle tree" })
    end
  },

  { "nvim-telescope/telescope.nvim", cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local b = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", b.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", b.live_grep,  { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", b.buffers,    { desc = "Buffers" })
    end
  },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", event = "BufReadPost",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "typescript", "tsx", "json", "yaml", "bash", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- LSP Configuration & Auto-completion
  { "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  { "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "eslint" },
      })
    end
  },

  { "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lsp = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      lsp.lua_ls.setup({ capabilities = capabilities })
      lsp.ts_ls.setup({ capabilities = capabilities })
      lsp.eslint.setup({ capabilities = capabilities })
    end
  },

  -- Auto-completion
  { "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end
  },

  -- Formatting
  { "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end
  },

  -- Git integration
  { "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
    end
  },

  -- Better diagnostics
  { "folke/trouble.nvim",
    cmd = "Trouble",
    config = function()
      require("trouble").setup()
      vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
      vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
    end
  },

  { "nvim-lualine/lualine.nvim", event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin"
        }
      })
    end
  },
}

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "clangd",
        "pyright",
        "bashls",
      },
      automatic_enable = false,
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("rust_analyzer")
      vim.lsp.enable("clangd")
      vim.lsp.enable("pyright")
      vim.lsp.enable("bashls")

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = vim.keymap.set
          local opts = { buffer = args.buf }

          map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
          map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
          map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Implementation" }))
          map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
          map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
        end,
      })
    end,
  },

  {
    "SmiteshP/nvim-navic",
    lazy = false,
    init = function()
      vim.g.navic_silence = true
    end,
    opts = {
      highlight = true,
      separator = "  ",
      depth_limit = 5,
      safe_output = true,
      lsp = {
        auto_attach = true,
      },
    },
    config = function(_, opts)
      require("nvim-navic").setup(opts)
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      local kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "󰆧",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "󰜰",
        Module = "󰆧",
        Property = "󰖷",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "󰒻",
        Keyword = "󰉿",
        Snippet = "󰘍",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "󰒻",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "󰉪",
        Operator = "󰆕",
        TypeParameter = "󰉿",
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "󰉿", vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      notification = {
        window = { winblend = 0 },
      },
    },
  },
}

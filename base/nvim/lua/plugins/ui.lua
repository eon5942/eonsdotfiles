return {
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          "alpha",
          "dashboard",
          "NvimTree",
          "neo-tree",
          "Trouble",
        },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
        color_icons = true,
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and "  " or "  "
          return " " .. icon .. count
        end,
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 32, side = "left" },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            glyphs = {
              folder = { arrow_closed = "", arrow_open = "" },
            },
          },
        },
        diagnostics = { enable = true, show_on_dirs = true },
      })
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
    },
  },

  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        "                                                    ",
        " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "                                                    ",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find File", "<cmd>Telescope find_files<CR>"),
        dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("g", "  Grep Text", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("e", "  File Tree", "<cmd>NvimTreeToggle<CR>"),
        dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
      }

      dashboard.section.footer.val = {
        "  ",
        "  nvim " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch,
        "  ",
      }

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = {
            "  ",
            "  loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
            "  ",
          }
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { show_start = false, show_end = false },
    },
  },

  {
    "rcarriga/nvim-notify",
    lazy = false,
    priority = 1000,
    opts = {
      background_colour = "#000000",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      stages = "fade_in_slide_out",
    },
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      enable = true,
      max_lines = 0,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
    },
  },

  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
      under_cursor = true,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      vim.keymap.set("n", "]]", function()
        require("illuminate").goto_next_reference(false)
      end, { desc = "Next reference" })
      vim.keymap.set("n", "[[", function()
        require("illuminate").goto_prev_reference(false)
      end, { desc = "Prev reference" })
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
      },
    },
  },

  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-e>", "<C-y>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing = "quadratic",
      })
    end,
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
      { "<leader>cs", "<cmd>Trouble symbols toggle<CR>", desc = "Symbols (Trouble)" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location list (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix list (Trouble)" },
    },
  },
}

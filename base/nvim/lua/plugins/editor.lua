return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
      { "<leader>fc", function() require("telescope.builtin").commands() end, desc = "Commands" },
      { "<leader>fk", function() require("telescope.builtin").keymaps() end, desc = "Keymaps" },
      { "<leader>fs", function() require("telescope.builtin").git_status() end, desc = "Git status" },
      { "<leader>/", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Fuzzy find in buffer" },
    },
    opts = {
      defaults = {
        prompt_prefix = "  ",
        selection_caret = " ",
        entry_prefix = "  ",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
        },
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        file_ignore_patterns = { "node_modules", ".git/", "target/", "dist/" },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "python",
        "rust",
        "c",
        "cpp",
        "bash",
        "json",
        "toml",
        "yaml",
        "markdown",
        "markdown_inline",
        "html",
        "css",
        "javascript",
        "typescript",
        "regex",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      fast_wrap = { map = "<M-e>" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "󰐊" },
        topdelete = { text = "󰐊" },
        changedelete = { text = "▎" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
        virt_text_pos = "eol",
        ignore_whitespace = false,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
        end, { desc = "Next hunk" })
        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
        end, { desc = "Prev hunk" })
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
        map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })
      end,
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      win = {
        border = "rounded",
        padding = { 1, 2 },
      },
    },
  },

  {
    "numToStr/Comment.nvim",
    lazy = false,
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    opts = {},
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle flash search" },
    },
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-`>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal (Ctrl+`)" },
      { "<C-`>", "<cmd>ToggleTerm<CR>", mode = "t", desc = "Toggle terminal (Ctrl+`)" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      direction = "horizontal",
      shade_terminals = true,
      float_opts = { border = "curved" },
    },
  },

  {
    "CRAG666/code_runner.nvim",
    keys = {
      { "<leader>r", "<cmd>RunFile<CR>", desc = "Run code" },
      { "<leader>rc", "<cmd>RunClose<CR>", desc = "Close runner" },
    },
    config = function()
      require("code_runner").setup({
        mode = "term",
        startinsert = true,
        filetype = {
          python = "python3 -u $fileName",
          lua = "lua $fileName",
          rust = "cd $dir && cargo run",
          c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
          cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
          sh = "bash $fileName",
          bash = "bash $fileName",
          zsh = "zsh $fileName",
          fish = "fish $fileName",
          javascript = "node $fileName",
          typescript = "deno run $fileName",
          javascriptreact = "node $fileName",
          typescriptreact = "deno run $fileName",
          go = "go run $fileName",
          java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
          ruby = "ruby $fileName",
          php = "php $fileName",
        },
      })
    end,
  },

  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      set({ "n", "x" }, "<C-d>", function() mc.matchAddCursor(1) end, { desc = "Add cursor to next match (Ctrl+D)" })
      set({ "n", "x" }, "<C-S-Up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above (Ctrl+Shift+Up)" })
      set({ "n", "x" }, "<C-S-Down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below (Ctrl+Shift+Down)" })

      set("n", "<c-leftmouse>", mc.handleMouse, { desc = "Add cursor with click" })
      set("n", "<c-leftdrag>", mc.handleMouseDrag, { desc = "Drag cursors" })
      set("n", "<c-leftrelease>", mc.handleMouseRelease, { desc = "Release cursors" })
      set({ "n", "x" }, "<c-q>", mc.toggleCursor, { desc = "Toggle cursors" })

      mc.addKeymapLayer(function(layerSet)
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format file" },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        rust = { "rustfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
        go = { "gofmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      suppressed_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop", "/" },
    },
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      { "<leader>gg", function() require("neogit").open() end, desc = "Git (neogit)" },
    },
    opts = {},
  },
}

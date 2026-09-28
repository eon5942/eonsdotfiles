return {
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  {
    "Saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    opts = {},
  },
}

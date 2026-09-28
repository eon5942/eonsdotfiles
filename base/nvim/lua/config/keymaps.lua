vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>c", "<cmd>bdelete<CR>", { desc = "Close buffer" })

map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })

map("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })

-- VS Code-style keybindings
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Quick open (Ctrl+P)" })
map("n", "<C-S-p>", "<cmd>Telescope commands<CR>", { desc = "Command palette (Ctrl+Shift+P)" })
map("n", "<C-S-f>", "<cmd>Telescope live_grep<CR>", { desc = "Search in files (Ctrl+Shift+F)" })
map("n", "<C-f>", "/", { desc = "Find in file (Ctrl+F)" })
map("n", "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle sidebar (Ctrl+B)" })
map("n", "<C-S-e>", "<cmd>NvimTreeFocus<CR>", { desc = "Explorer (Ctrl+Shift+E)" })
map("n", "<C-S-x>", "<cmd>Lazy<CR>", { desc = "Extensions (Ctrl+Shift+X)" })
map("n", "<C-w>", "<cmd>bdelete<CR>", { desc = "Close tab (Ctrl+W)" })
map("n", "<C-S-k>", "dd", { desc = "Delete line (Ctrl+Shift+K)" })
map("n", "<C-g>", function()
  local line = vim.fn.input("Go to line: ")
  local n = tonumber(line)
  if n then
    vim.api.nvim_win_set_cursor(0, { n, 0 })
  end
end, { desc = "Go to line (Ctrl+G)" })

map("n", "<C-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment (Ctrl+/)" })
map("x", "<C-/>", "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment (Ctrl+/)" })

map("n", "<C-.>", vim.lsp.buf.code_action, { desc = "Quick fix (Ctrl+.)" })
map("n", "F2", vim.lsp.buf.rename, { desc = "Rename symbol (F2)" })
map("n", "F12", vim.lsp.buf.definition, { desc = "Go to definition (F12)" })
map("n", "<S-F12>", vim.lsp.buf.references, { desc = "Find all references (Shift+F12)" })
map("n", "<C-S-o>", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Go to symbol (Ctrl+Shift+O)" })
map("n", "<C-S-m>", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Problems (Ctrl+Shift+M)" })

map("n", "<A-Up>", "<cmd>m .-2<CR>==", { desc = "Move line up (Alt+Up)" })
map("n", "<A-Down>", "<cmd>m .+1<CR>==", { desc = "Move line down (Alt+Down)" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })

-- Change language (like VS Code "Select Language Mode")
map("n", "<leader>l", function()
  local languages = {
    "python", "rust", "c", "cpp", "lua", "bash", "sh", "zsh", "fish",
    "javascript", "typescript", "javascriptreact", "typescriptreact",
    "html", "css", "json", "yaml", "toml", "markdown",
    "go", "java", "ruby", "php", "zig", "nix", "sql",
  }
  vim.ui.select(languages, { prompt = "Language mode:" }, function(ft)
    if ft then
      vim.bo.filetype = ft
      vim.notify("Filetype set to " .. ft, vim.log.levels.INFO)
    end
  end)
end, { desc = "Change language" })

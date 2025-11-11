local map = vim.keymap.set
map("n", "<leader>e", vim.cmd.Ex, { desc = "File explorer" })
map("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quit" })
map("n", "<leader>w", ":w<CR>", { silent = true, desc = "Write" })
map("n", "<leader>h", ":nohlsearch<CR>", { silent = true, desc = "No highlight" })

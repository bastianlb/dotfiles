-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- create a mapping in your settings that opens a new split (horizontal or vertical), and then opens a new blank buffer in that split.
-- For a horizontal split
vim.api.nvim_set_keymap("n", "<Leader>h", ":split<CR>:enew<CR>", { noremap = true, silent = true })

-- For a vertical split
vim.api.nvim_set_keymap("n", "<Leader>v", ":vsplit<CR>:enew<CR>", { noremap = true, silent = true })

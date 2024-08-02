-- Disable compatibility to old-time vi
vim.opt.compatible = false

-- Show matching parentheses, braces, etc.
vim.opt.showmatch = true

-- Highlight search results
vim.opt.hlsearch = true

-- Incremental search
vim.opt.incsearch = true

-- Number of columns occupied by a tab
vim.opt.tabstop = 4

-- See multiple spaces as tabstops so <BS> does the right thing
vim.opt.softtabstop = 4

-- Convert tabs to white space
vim.opt.expandtab = true

-- Width for autoindents
vim.opt.shiftwidth = 4

-- Indent a new line the same amount as the line just typed
vim.opt.autoindent = true

-- Add line numbers
vim.opt.number = true

-- Set an 80 column border for good coding style
vim.opt.colorcolumn = "80"

-- Enable syntax highlighting
vim.cmd("syntax on")

-- Enable filetype plugins
vim.cmd("filetype plugin on")

-- Enable spell check
vim.opt.spell = true

vim.g.mapleader = " "

-- Disable creating swap file (commented out)
-- vim.opt.swapfile = false

-- Directory to store backup files (commented out)
-- vim.opt.backupdir = os.getenv("HOME") .. "/.cache/vim"
--

require("config.lazy")

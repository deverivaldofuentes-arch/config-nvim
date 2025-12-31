-- Core Neovim Options
-- ===================

-- Leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Opciones de UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes:1'
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.cmdheight = 1

-- Tabs e indentación
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Búsqueda
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Rendimiento
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 0

-- Ventanas y splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep = 'screen'

-- Archivos
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('state') .. '/undo'

-- Terminal
vim.opt.termguicolors = true
-- Mouse
vim.opt.mouse = 'a'

-- Completado
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.pumheight = 10

-- Misceláneo
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = {
    tab = '» ',
    trail = '·',
    nbsp = '␣',
}
vim.opt.inccommand = 'split'
vim.opt.conceallevel = 0
vim.opt.confirm = true
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'
vim.opt.title = true
vim.opt.titlestring = '%t - Neovim'

-- Corrector ortográfico (opcional)
vim.opt.spelllang = 'es,en'
vim.opt.spell = false

-- Neovim 0.11+ Configuration
-- ==========================

-- Silenciar advertencias
vim.g.lspconfig_silent = true

-- 1. Cargar configuración base
require('core.options')
require('core.keymaps')
require('core.autocmds')

-- 2. Cargar gestor de plugins y configuraciones
require('plugins.setup')

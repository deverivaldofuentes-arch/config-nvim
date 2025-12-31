-- Neovim 0.11+ Configuration
-- ==========================

-- Silenciar advertencia de deprecación de nvim-lspconfig
vim.g.lspconfig_silent = true

-- Cargar configuración base primero
require('core.options')
require('core.keymaps')
require('core.autocmds')

-- Cargar gestor de plugins
require('plugins.setup')

-- Cargar configuraciones específicas de plugins
require('plugins.config.mason')
require('plugins.config.lsp')
require('plugins.config.cmp')
require('plugins.config.luasnip')
require('plugins.config.jdtls')

-- Configuraciones específicas de lenguajes
require('lang.java')

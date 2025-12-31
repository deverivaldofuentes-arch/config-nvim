-- Mason Configuration for Neovim 0.11+
-- ====================================

require('mason').setup({
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
        },
        border = 'rounded',
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
})

require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'tsserver',  -- Mason lo llama tsserver, no typescript
        'pyright',
        'bashls',
        'jsonls',
        'html',
        'cssls',
        'emmet_ls',
    },
    automatic_installation = true,
})

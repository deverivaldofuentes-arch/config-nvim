-- Autocommands Configuration
-- ==========================

-- Crear grupos de autocomandos
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Grupo general
local general_group = augroup('GeneralSettings', { clear = true })

-- Destacar al copiar
autocmd('TextYankPost', {
    group = general_group,
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Restaurar posición del cursor
autocmd('BufReadPost', {
    group = general_group,
    callback = function()
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line('$') then
            vim.cmd('normal! g`"')
        end
    end,
})

-- Detección automática de tipo de archivo
autocmd({ 'BufNewFile', 'BufRead' }, {
    group = general_group,
    pattern = { '*.md', '*.txt' },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})

-- Configuración específica para archivos de configuración
autocmd('FileType', {
    group = general_group,
    pattern = { 'lua', 'vim', 'sh', 'zsh', 'bash', 'python' },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})

-- Auto-guardado (opcional, descomenta si lo quieres)
-- autocmd({ 'InsertLeave', 'TextChanged' }, {
--     group = general_group,
--     pattern = '*',
--     callback = function()
--         if vim.bo.modified and not vim.bo.readonly then
--             vim.cmd('silent write')
--         end
--     end,
-- })

-- Grupo para LSP
local lsp_group = augroup('LSP', { clear = true })

-- Formateo automático (se activará cuando cargue LSP)
autocmd('BufWritePre', {
    group = lsp_group,
    callback = function(args)
        local clients = vim.lsp.get_active_clients({ bufnr = args.buf })
        if #clients > 0 then
            vim.lsp.buf.format({ async = false })
        end
    end,
})

-- Grupo para Java específico
local java_group = augroup('JavaSettings', { clear = true })

autocmd('FileType', {
    group = java_group,
    pattern = 'java',
    callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
    end,
})

-- LuaSnip Configuration
-- =====================

local ls_ok, ls = pcall(require, 'luasnip')
if not ls_ok then
    vim.notify("LuaSnip no está disponible", vim.log.levels.WARN)
    return
end

-- Configuración básica
ls.config.set_config({
    history = true,
    updateevents = 'TextChanged,TextChangedI',
    enable_autosnippets = true,
})

-- Atajos de teclado
vim.keymap.set({ 'i', 's' }, '<C-k>', function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<C-j>', function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

vim.keymap.set('i', '<C-l>', function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)

-- Snippets personalizados (puedes agregar más aquí)
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets('all', {
    s('todo', {
        t('TODO: '),
        i(0),
    }),
    s('fixme', {
        t('FIXME: '),
        i(0),
    }),
    s('note', {
        t('NOTE: '),
        i(0),
    }),
})

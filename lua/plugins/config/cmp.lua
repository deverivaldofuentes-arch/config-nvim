-- Autocompletion (nvim-cmp) Configuration
-- =======================================

local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
    vim.notify("nvim-cmp no está disponible", vim.log.levels.WARN)
    return
end

local luasnip_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_ok then
    vim.notify("LuaSnip no está disponible", vim.log.levels.WARN)
    return
end

-- Cargar snippets amigables
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    }),
    formatting = {
        format = function(entry, vim_item)
            -- Icons
            local icons = {
                Text = '📝',
                Method = 'ƒ',
                Function = 'λ',
                Constructor = '🛠️',
                Field = '📦',
                Variable = '𝑥',
                Class = '🏛️',
                Interface = '🌐',
                Module = '📦',
                Property = '🏷️',
                Unit = '📏',
                Value = '💎',
                Enum = '🎲',
                Keyword = '🔑',
                Snippet = '✂️',
                Color = '🎨',
                File = '📁',
                Reference = '🔗',
                Folder = '📂',
                EnumMember = '👥',
                Constant = '🔢',
                Struct = '🏗️',
                Event = '📅',
                Operator = '⚙️',
                TypeParameter = '📐',
            }
            
            vim_item.kind = string.format('%s %s', icons[vim_item.kind] or '?', vim_item.kind)
            
            -- Source
            vim_item.menu = ({
                nvim_lsp = '[LSP]',
                luasnip = '[Snip]',
                buffer = '[Buf]',
                path = '[Path]',
            })[entry.source.name]
            
            return vim_item
        end,
    },
    experimental = {
        ghost_text = true,
    },
})

-- Autocompletado para línea de comandos
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
    }, {
        { name = 'cmdline' },
    }),
})

-- Autocompletado para búsqueda
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' },
    },
})

-- Plugin Manager Setup (Lazy.nvim) - Neovim 0.11+
-- ===============================================

-- Instalar Lazy.nvim si no está presente
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Configuración de Lazy.nvim
require('lazy').setup({
    -- Mason - LSP Manager
    {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        build = ':MasonUpdate',
        config = function()
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
        end,
    },
    
    -- Mason LSP Config - DEBE estar como plugin separado
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-lspconfig').setup({
                automatic_installation = true,
            })
        end,
    },
    
    -- cmp-nvim-lsp (necesario para capabilities)
    {
        'hrsh7th/cmp-nvim-lsp',
        event = 'InsertEnter',
    },
    
    -- Autocompletado (nvim-cmp)
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
        },
        config = function()
            require('plugins.config.cmp')
        end,
    },
    
    -- Snippets Engine
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'rafamadriz/friendly-snippets',
        },
        config = function()
            require('plugins.config.luasnip')
        end,
    },
    
    -- Java LSP
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
        config = function()
            require('plugins.config.jdtls')
        end,
    },
    
    -- Schemastore para JSON
    {
        'b0o/schemastore.nvim',
        lazy = true,
    },
    
    -- UI Enhancements
    {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
    },
    
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        opts = {
            options = {
                theme = 'auto',
                component_separators = { left = '|', right = '|' },
                section_separators = { left = '', right = '' },
            },
        },
    },
    
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'BufReadPost',
        main = 'ibl',
        opts = {
            indent = {
                char = '│',
                tab_char = '│',
            },
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
            },
        },
    },
    
    -- Syntax highlighting mejorado
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPost', 'BufNewFile' },
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'lua', 'vim', 'vimdoc',
                    'javascript', 'typescript', 'html', 'css',
                    'python', 'java', 'bash', 'json', 'yaml',
                },
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },
    
    -- File explorer
    {
        'nvim-tree/nvim-tree.lua',
        cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
        config = function()
            require('nvim-tree').setup({
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = false,
                },
            })
            
            vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
            vim.keymap.set('n', '<leader>E', ':NvimTreeFocus<CR>', { desc = 'Focus file explorer' })
        end,
    },
    
    -- Telescope (búsqueda)
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
        },
        config = function()
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    layout_strategy = 'horizontal',
                    layout_config = {
                        prompt_position = 'top',
                    },
                    sorting_strategy = 'ascending',
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
            })
            
            telescope.load_extension('fzf')
            
            -- Keymaps para Telescope
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
        end,
    },
    
    -- Git integration
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require('gitsigns').setup({
                signs = {
                    add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '_' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                },
            })
        end,
    },
    
}, {
    ui = {
        border = 'rounded',
    },
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip',
                'matchit',
                'matchparen',
                'netrwPlugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },
})

-- Después de que todos los plugins estén cargados, configuramos los LSP
vim.api.nvim_create_autocmd('User', {
    pattern = 'LazyDone',
    once = true,
    callback = function()
        -- Esperar un momento para asegurar que todos los módulos estén cargados
        vim.defer_fn(function()
            -- Cargar configuraciones LSP
            local ok_lsp, err_lsp = pcall(require, 'plugins.config.lsp')
            if not ok_lsp then
                vim.notify("Error cargando LSP: " .. err_lsp, vim.log.levels.WARN)
            end
            
            local ok_java, err_java = pcall(require, 'lang.java')
            if not ok_java then
                vim.notify("Error cargando Java config: " .. err_java, vim.log.levels.WARN)
            end
        end, 100)
    end
})

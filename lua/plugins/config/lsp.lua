-- LSP Configuration for Neovim 0.11+ (New API)
-- ============================================

-- Configurar capacidades para autocompletado
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configuración global para todos los LSP
local on_attach = function(client, bufnr)
    -- Mappings específicos de LSP
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    
    -- Navegación de código
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
    
    -- Información y acciones
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    
    -- Formateo
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
    
    -- Workspace
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    
    -- Diagnosticos
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
    vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, bufopts)
    
    -- Enable omnifunc para completado
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    
    -- Formateo automático al guardar
    vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ async = false })
        end
    })
end

-- Necesitamos cargar schemastore para JSON
local schemastore_ok, schemastore = pcall(require, 'schemastore')
local json_schemas = nil
if schemastore_ok then
    json_schemas = schemastore.json.schemas()
end

-- EN NEOVIM 0.11+ USAMOS LA NUEVA API: vim.lsp.start
-- ===================================================

-- Configuración base para todos los servidores
local common_config = {
    capabilities = capabilities,
    on_attach = on_attach,
}

-- Mapeo de servidores LSP a sus filetypes correspondientes
local server_filetypes = {
    lua_ls = { 'lua' },
    tsserver = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    typescript = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    pyright = { 'python' },
    bashls = { 'sh', 'bash' },
    jsonls = { 'json' },
    html = { 'html' },
    cssls = { 'css' },
    emmet_ls = { 'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
}

-- Función auxiliar para configurar servidores
local function setup_lsp_server(server_name, custom_config)
    local config = vim.tbl_deep_extend('force', common_config, custom_config or {})
    
    -- Obtener los filetypes para este servidor
    local filetypes = server_filetypes[server_name] or { server_name }
    
    -- Configurar el servidor usando la nueva API
    vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function(args)
            local root_dir = nil
            
            -- Buscar directorio raíz del proyecto
            local root_files = {
                '.git',
                '.git/',
                'package.json',
                'pyproject.toml',
                'setup.py',
                'requirements.txt',
                'pom.xml',
                'build.gradle',
                'build.gradle.kts',
                'gradlew',
                'mvnw',
            }
            
            for _, file in ipairs(root_files) do
                local found = vim.fs.find(file, { upward = true, path = args.file })
                if #found > 0 then
                    root_dir = vim.fs.dirname(found[1])
                    break
                end
            end
            
            -- Iniciar el cliente LSP
            vim.lsp.start({
                name = server_name,
                root_dir = root_dir,
                config = config,
            })
        end,
    })
end

-- Configurar servidores individuales
-- Lua
setup_lsp_server('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

-- TypeScript
setup_lsp_server('tsserver', {})

-- Python
setup_lsp_server('pyright', {})

-- Bash
setup_lsp_server('bashls', {})

-- JSON
local json_settings = {}
if json_schemas then
    json_settings.settings = {
        json = {
            schemas = json_schemas,
            validate = { enable = true },
        },
    }
end
setup_lsp_server('jsonls', json_settings)

-- HTML
setup_lsp_server('html', {})

-- CSS
setup_lsp_server('cssls', {})

-- Emmet
setup_lsp_server('emmet_ls', {
    filetypes = { 'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
})

-- Configurar diagnóstico
vim.diagnostic.config({
    virtual_text = {
        source = 'if_many',
        prefix = '●',
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

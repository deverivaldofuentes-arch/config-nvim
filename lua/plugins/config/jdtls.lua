-- Java Development Tools Language Server (JDTLS) Configuration
-- =============================================================

local jdtls = require('jdtls')
local home = os.getenv('HOME')
local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'

-- Configuración específica para proyectos Java
local function setup_jdtls()
    -- Encontrar la raíz del proyecto (donde está gradlew, mvnw, o .git)
    local root_markers = { 'gradlew', 'mvnw', '.git', 'pom.xml' }
    local root_dir = require('jdtls.setup').find_root(root_markers)
    
    if not root_dir then
        return
    end
    
    local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
    local workspace_dir = workspace_path .. project_name
    
    -- Ruta a la instalación de jdtls de Mason
    local jdtls_install_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
    
    -- TU RUTA ESPECÍFICA de Java 17
    local java_path = '/usr/lib/jvm/java-17-openjdk-amd64'
    local java_bin = java_path .. '/bin/java'
    
    -- Configuración principal de jdtls
    local config = {
        cmd = {
            java_bin,
            '-Declipse.application=org.eclipse.jdt.ls.core.id1',
            '-Dosgi.bundles.defaultStartLevel=4',
            '-Declipse.product=org.eclipse.jdt.ls.core.product',
            '-Dlog.protocol=true',
            '-Dlog.level=ALL',
            '-Xmx4g',
            '--add-modules=ALL-SYSTEM',
            '--add-opens', 'java.base/java.util=ALL-UNNAMED',
            '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
            '-jar', vim.fn.glob(jdtls_install_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
            '-configuration', jdtls_install_path .. '/config_linux',
            '-data', workspace_dir,
        },
        
        root_dir = root_dir,
        
        settings = {
            java = {
                -- Especificar Java 17
                configuration = {
                    runtimes = {
                        {
                            name = 'JavaSE-17',
                            path = java_path, -- Usar la ruta específica
                            default = true,
                        },
                    },
                },
                home = java_path, -- Usar la ruta específica
                
                -- Maven
                maven = {
                    downloadSources = true,
                },
                
                -- Completado
                completion = {
                    favoriteStaticMembers = {
                        'org.junit.Assert.*',
                        'org.junit.jupiter.api.Assertions.*',
                        'org.mockito.Mockito.*',
                        'org.mockito.ArgumentMatchers.*',
                    },
                    filteredTypes = {
                        'com.sun.*',
                        'sun.*',
                        'jdk.*',
                        'org.graalvm.*',
                    },
                },
                
                -- Fuentes
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticStarThreshold = 9999,
                    },
                },
                
                -- Código
                codeGeneration = {
                    toString = {
                        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
                    },
                    hashCodeEquals = {
                        useJava7Objects = true,
                    },
                    useBlocks = true,
                },
                
                -- Signatures
                signatureHelp = {
                    enabled = true,
                },
                
                -- References
                referencesCodeLens = {
                    enabled = true,
                },
                implementationsCodeLens = {
                    enabled = true,
                },
                
                -- Formatting (opcional, puedes comentar si no quieres formato específico)
                -- format = {
                --     enabled = true,
                --     settings = {
                --         url = vim.fn.stdpath('config') .. '/formatters/eclipse-java-google-style.xml',
                --         profile = 'GoogleStyle',
                --     },
                -- },
            },
        },
        
        init_options = {
            bundles = {},
        },
        
        -- Usar las mismas capacidades que otros LSP
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        
        on_attach = function(client, bufnr)
            -- Funcionalidades específicas de jdtls
            require('jdtls').setup_dap({ hotcodereplace = 'auto' })
            require('jdtls.setup').add_commands()
            
            -- Mappings específicos para Java
            local bufopts = { noremap = true, silent = true, buffer = bufnr }
            
            -- Organizar imports
            vim.keymap.set('n', '<leader>jo', ':OrganizeImports<CR>', bufopts)
            
            -- Extracción de variables/métodos
            vim.keymap.set('v', '<leader>jv', '<Esc><Cmd>lua require(\'jdtls\').extract_variable(true)<CR>', bufopts)
            vim.keymap.set('n', '<leader>jv', '<Cmd>lua require(\'jdtls\').extract_variable()<CR>', bufopts)
            vim.keymap.set('v', '<leader>jm', '<Esc><Cmd>lua require(\'jdtls\').extract_method(true)<CR>', bufopts)
            
            -- Testing
            vim.keymap.set('n', '<leader>jtc', '<Cmd>lua require(\'jdtls\').test_class()<CR>', bufopts)
            vim.keymap.set('n', '<leader>jtm', '<Cmd>lua require(\'jdtls\').test_nearest_method()<CR>', bufopts)
            
            -- Debugging
            vim.keymap.set('n', '<leader>jdb', '<Cmd>lua require(\'jdtls.dap\').setup_dap_main_class_configs()<CR>', bufopts)
            
            -- Update build configuration
            vim.keymap.set('n', '<leader>jub', '<Cmd>JdtUpdateBuildConfig<CR>', bufopts)
        end,
    }
    
    -- Iniciar el cliente jdtls
    require('jdtls').start_or_attach(config)
    
    -- Configurar formato con jdtls
    vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = vim.api.nvim_get_current_buf(),
        callback = function()
            vim.lsp.buf.format({ async = false })
        end
    })
end

-- Configurar jdtls solo para archivos Java
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function()
        setup_jdtls()
    end,
})

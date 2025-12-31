-- Java Language Specific Configuration
-- ====================================

local M = {}

M.setup = function()
    -- Variables de entorno para Java
    -- TU RUTA ESPECÍFICA
    local java_path = '/usr/lib/jvm/java-17-openjdk-amd64'
    vim.env.JAVA_HOME = java_path
    
    -- Configuración específica para archivos Java
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
            -- Configuración de formato
            vim.bo.tabstop = 4
            vim.bo.shiftwidth = 4
            vim.bo.softtabstop = 4
            vim.bo.expandtab = true
            
            -- Compilación y ejecución
            vim.keymap.set('n', '<leader>jc', ':!javac %<CR>', { buffer = true, desc = 'Compile Java file' })
            vim.keymap.set('n', '<leader>jr', ':!java %:r<CR>', { buffer = true, desc = 'Run Java file' })
            
            -- Comandos útiles
            vim.keymap.set('n', '<leader>jio', ':JavaImportOrganize<CR>', { buffer = true, desc = 'Organize imports' })
            vim.keymap.set('n', '<leader>jgs', ':JavaGetSet<CR>', { buffer = true, desc = 'Generate getters/setters' })
            
            -- Manejo de proyectos
            vim.keymap.set('n', '<leader>jpc', ':JdtCompile<CR>', { buffer = true, desc = 'Compile project' })
            vim.keymap.set('n', '<leader>jpu', ':JdtUpdateConfig<CR>', { buffer = true, desc = 'Update project config' })
        end,
    })
    
    -- Configuración para archivos de proyecto Java
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
        pattern = { 'pom.xml', 'build.gradle', 'build.gradle.kts' },
        callback = function()
            vim.bo.filetype = 'xml'  -- Para pom.xml
        end,
    })
end

M.setup()

return M

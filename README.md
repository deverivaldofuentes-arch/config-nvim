```markdown
# Neovim 0.11+ Configuración de Desarrollo Extremadamente Ordenada
## 🚀 Descripción

Configuración modular y extremadamente ordenada para Neovim 0.11+ diseñada para desarrollo profesional. Esta configuración usa la **nueva API de LSP de Neovim 0.11** (`vim.lsp.start`) en lugar del plugin `nvim-lspconfig`. Proporciona un entorno de desarrollo completo con LSP, autocompletado, snippets, y herramientas modernas, manteniendo una estructura modular que facilita la expansión y mantenimiento.

## ✨ Características

- ✅ **Modularidad extrema**: Cada componente en su propio archivo
- ✅ **Neovim 0.11+**: Usa la NUEVA API de LSP (`vim.lsp.start`) - sin `nvim-lspconfig`
- ✅ **Java 17 nativo**: Configuración optimizada para desarrollo Java
- ✅ **LSP automático**: Instalación y configuración automática de servidores
- ✅ **Autocompletado inteligente**: Con nvim-cmp y LuaSnip
- ✅ **UI moderna**: Lualine, indentación visual, árbol de archivos
- ✅ **Búsqueda potente**: Con Telescope y FZF
- ✅ **Control de versiones**: Integración con Git
- ✅ **Sistema de snippets**: Con snippets predefinidos y personalizables
- ✅ **Diagnóstico en tiempo real**: Errores y advertencias integrados

## 💻 Requisitos del Sistema

### Dependencias esenciales:
```bash
# Java 17 (para desarrollo Java)
sudo apt update
sudo apt install openjdk-17-jdk

# Node.js (para algunos LSP como tsserver)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs

# Python (para pyright y otros)
sudo apt install python3 python3-pip python3-venv

# Herramientas de compilación
sudo apt install build-essential
```

### Verificar instalaciones:
```bash
# Verificar Java
java -version  # Debe mostrar: openjdk version "17.x.x"

# Verificar Node.js
node --version  # Debe mostrar: v20.x.x

# Verificar Python
python3 --version  # Debe mostrar: Python 3.x.x

# Verificar Neovim (DEBE ser 0.11+)
nvim --version  # Debe mostrar: NVIM v0.11.x
```

## 📦 Instalación Completa

### Paso 1: Instalar Neovim 0.11+
```bash
# Ubuntu/Debian (usando PPA)
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# Verificar versión
nvim --version  # Debe mostrar: NVIM v0.11.x
```

### Paso 2: Crear estructura de directorios
```bash
mkdir -p ~/.config/nvim/lua/core
mkdir -p ~/.config/nvim/lua/plugins/config
mkdir -p ~/.config/nvim/lua/lang
```

### Paso 3: Clonar o crear archivos de configuración

**1. Archivo principal `init.lua`:**
```lua
-- Neovim 0.11+ Configuration
-- ==========================

-- Silenciar advertencias
vim.g.lspconfig_silent = true

-- 1. Cargar configuración base
require('core.options')
require('core.keymaps')
require('core.autocmds')

-- 2. Cargar gestor de plugins
require('plugins.setup')
```

**2. Configuración base `core/`:**
- `core/options.lua`: Opciones básicas de Neovim
- `core/keymaps.lua`: Atajos de teclado globales
- `core/autocmds.lua`: Autocomandos y eventos

**3. Gestor de plugins `plugins/setup.lua`:**
```lua
-- Configuración de Lazy.nvim con todos los plugins
-- Incluye: mason, nvim-cmp, LuaSnip, nvim-jdtls, Telescope, etc.
-- NOTA: NO incluye nvim-lspconfig (usamos la nueva API de Neovim 0.11)
```

**4. Configuraciones específicas `plugins/config/`:**
- `lsp.lua`: Configuración LSP (NUEVA API Neovim 0.11 con `vim.lsp.start`)
- `cmp.lua`: Autocompletado con nvim-cmp
- `luasnip.lua`: Sistema de snippets
- `jdtls.lua`: Configuración específica para Java

**5. Configuración por lenguaje `lang/java.lua`:**
```lua
-- Configuración específica para proyectos Java
-- Variables de entorno, compilación, ejecución, etc.
```

**IMPORTANTE**: NO existe `mason.lua` - Mason se configura directamente en `setup.lua`

## 📁 Estructura de Archivos Actualizada

```
~/.config/nvim/
├── init.lua                          # Entrada principal
├── lua/
│   ├── core/                         # Configuración base
│   │   ├── autocmds.lua              # Autocomandos
│   │   ├── keymaps.lua               # Atajos de teclado
│   │   └── options.lua               # Opciones de Neovim
│   ├── plugins/                      # Gestión de plugins
│   │   ├── config/                   # Configuraciones específicas
│   │   │   ├── cmp.lua               # Autocompletado
│   │   │   ├── lsp.lua               # Servidores LSP (NUEVA API vim.lsp.start)
│   │   │   ├── luasnip.lua           # Snippets
│   │   │   └── jdtls.lua             # Java LSP
│   │   └── setup.lua                 # Lazy.nvim (incluye configuración de Mason)
│   └── lang/                         # Configuración por lenguaje
│       └── java.lua                  # Java específico
└── README.md                         # Esta documentación
```

## 🔧 Configuración Detallada

### 1. Opciones Básicas (`core/options.lua`)
```lua
-- Leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes:1'

-- Tabs e indentación
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Búsqueda
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Rendimiento
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
```

### 2. LSP Moderno (Neovim 0.11 API) - SIN nvim-lspconfig
```lua
-- Nueva API vim.lsp.start() - NO USAMOS nvim-lspconfig
vim.lsp.start({
    name = 'lua_ls',
    root_dir = root_dir,
    config = {
        settings = { Lua = { ... } },
        capabilities = capabilities,
        on_attach = on_attach,
    }
})

-- Configuramos servidores con autocmds
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'lua',
    callback = function(args)
        -- Iniciar el cliente LSP
        vim.lsp.start({
            name = 'lua_ls',
            root_dir = root_dir,
            config = config,
        })
    end,
})
```

### 3. Java 17 Configuration
```lua
-- Ruta específica (ajustar según sistema)
local java_path = '/usr/lib/jvm/java-17-openjdk-amd64'
vim.env.JAVA_HOME = java_path

-- Configuración JDTLS usando la nueva API
local config = {
    cmd = { java_bin, ... },
    root_dir = root_dir,
    settings = {
        java = {
            configuration = {
                runtimes = { { name = 'JavaSE-17', path = java_path } }
            }
        }
    }
}

-- Iniciar jdtls con autocmd
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function()
        require('jdtls').start_or_attach(config)
    end,
})
```

## 📦 Plugins Instalados (ACTUALIZADO)

### Gestión de LSP:
- **`williamboman/mason.nvim`**: Instalador de servidores LSP
- **`williamboman/mason-lspconfig.nvim`**: Integración Mason-LSP
- **`mfussenegger/nvim-jdtls`**: LSP específico para Java
- **`b0o/schemastore.nvim`**: Esquemas JSON para jsonls

### ❌ NO USAMOS: `neovim/nvim-lspconfig`
> Usamos la nueva API nativa de Neovim 0.11+ (`vim.lsp.start`)

### Autocompletado:
- **`hrsh7th/nvim-cmp`**: Motor de autocompletado
- **`hrsh7th/cmp-nvim-lsp`**: Fuente LSP para cmp
- **`hrsh7th/cmp-buffer`**: Fuente buffer para cmp
- **`hrsh7th/cmp-path`**: Fuente rutas para cmp
- **`hrsh7th/cmp-cmdline`**: Fuente para línea de comandos
- **`L3MON4D3/LuaSnip`**: Motor de snippets
- **`rafamadriz/friendly-snippets`**: Snippets predefinidos
- **`saadparwaiz1/cmp_luasnip`**: Integración snippets-cmp

### UI y Utilidades:
- **`nvim-tree/nvim-web-devicons`**: Iconos
- **`nvim-lualine/lualine.nvim`**: Barra de estado
- **`lukas-reineke/indent-blankline.nvim`**: Guías de indentación
- **`nvim-treesitter/nvim-treesitter`**: Resaltado mejorado
- **`nvim-tree/nvim-tree.lua`**: Explorador de archivos
- **`nvim-telescope/telescope.nvim`**: Búsqueda fuzzy
- **`lewis6991/gitsigns.nvim`**: Integración Git

## ⌨️ Atajos de Teclado

### Navegación:
- `<C-h/j/k/l>`: Moverse entre ventanas
- `<leader>e`: Toggle explorador de archivos (NvimTree)
- `<leader>E`: Focus explorador de archivos
- `<leader>tn/tc/tl/th>`: Gestión de pestañas

### Búsqueda:
- `<leader>ff`: Buscar archivos (Telescope)
- `<leader>fg`: Buscar en archivos (grep vivo)
- `<leader>fb`: Buscar buffers
- `<leader>fh`: Buscar help tags

### LSP:
- `gd`: Ir a definición
- `gr`: Ver referencias
- `K`: Mostrar documentación
- `<leader>ca`: Acciones de código
- `<leader>rn`: Renombrar símbolo
- `<leader>f`: Formatear buffer

### Java específico:
- `<leader>jo`: Organizar imports
- `<leader>jv`: Extraer variable
- `<leader>jm`: Extraer método
- `<leader>jtc`: Ejecutar tests de clase
- `<leader>jtm`: Ejecutar test más cercano

### Buffers:
- `<leader>bn/bp`: Siguiente/anterior buffer
- `<leader>bd`: Cerrar buffer
- `<leader>ba`: Cerrar todos menos actual

### Sistema:
- `<leader>w`: Guardar archivo
- `<leader>q`: Cerrar ventana
- `<leader>h`: Limpiar búsqueda

## ☕ Configuración Específica por Lenguaje

### Java:
```lua
-- Variables de entorno
vim.env.JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'

-- Comandos de compilación y ejecución
vim.keymap.set('n', '<leader>jc', ':!javac %<CR>')
vim.keymap.set('n', '<leader>jr', ':!java %:r<CR>')
```

### TypeScript/JavaScript:
```lua
-- Configuración automática con tsserver
-- Se inicia automáticamente al abrir archivos .js/.ts
```

### Python:
```lua
-- Pyright configurado automáticamente
-- Se inicia automáticamente al abrir archivos .py
```

### Lua:
```lua
-- lua_ls con configuración específica para Neovim
-- Diagnósticos ajustados para API de Neovim
```

## 🔧 Solución de Problemas (ACTUALIZADO)

### Error: "Mason command not found"
```bash
# Limpiar cache de plugins
rm -rf ~/.local/share/nvim/lazy
rm -rf ~/.local/state/nvim/lazy

# Reabrir Neovim
nvim

# Verificar que Mason se carga
:Lazy
```

### Error: "mason-lspconfig not found"
```lua
-- Verificar que en plugins/setup.lua está declarado:
{
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
        require('mason-lspconfig').setup({
            automatic_installation = true,
        })
    end,
}
```

### Error: Java path incorrecto
```bash
# Encontrar ruta correcta
ls /usr/lib/jvm/

# Actualizar archivos:
# - lua/plugins/config/jdtls.lua (línea ~25)
# - lua/lang/java.lua (línea ~7)
```

### Plugins no se instalan
```bash
# Eliminar cache de Lazy.nvim
rm -rf ~/.local/share/nvim/lazy
rm -rf ~/.local/state/nvim/lazy

# Reinstalar Lazy.nvim
git clone https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim

# Reabrir Neovim
nvim
```

### No hay autocompletado
```bash
# Verificar que cmp está configurado
:checkhealth nvim-cmp

# Reinstalar dependencias
:MasonInstallAll

# Verificar servidores LSP instalados
:Mason
```

## 🔄 Nueva API de LSP (Neovim 0.11+)

### ¿Por qué no usamos nvim-lspconfig?
Neovim 0.11+ introduce una nueva API nativa para LSP (`vim.lsp.start`) que hace que `nvim-lspconfig` sea opcional. Ventajas:

1. **Menos dependencias**: No necesitas `nvim-lspconfig`
2. **Configuración nativa**: Usas la API oficial de Neovim
3. **Más simple**: Configuras servidores directamente con autocmds

### Ejemplo de configuración:
```lua
-- En lua/plugins/config/lsp.lua
local function setup_lsp_server(server_name, custom_config)
    vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function(args)
            vim.lsp.start({
                name = server_name,
                root_dir = root_dir,
                config = config,
            })
        end,
    })
end
```

## 🛠️ Mantenimiento y Expansión (ACTUALIZADO)

### Agregar nuevo plugin:
1. Añadir a `lua/plugins/setup.lua` en la tabla `require('lazy').setup({})`
2. Crear archivo de configuración en `lua/plugins/config/` si es necesario
3. Cargar configuración en `init.lua` si aplica

### Agregar nuevo servidor LSP:
1. Instalar con `:Mason`
2. Añadir configuración en `lua/plugins/config/lsp.lua` usando `setup_lsp_server`
3. Agregar el filetype en la tabla `server_filetypes`

```lua
-- Ejemplo para Rust
server_filetypes.rust_analyzer = { 'rust' }

setup_lsp_server('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = {
                command = 'clippy',
            },
        },
    },
})
```

### Agregar nuevo lenguaje:
1. Crear archivo en `lua/lang/`
2. Configurar autocmds específicos, keymaps, settings
3. Cargar en `init.lua`

### Actualizar configuración:
```bash
# Actualizar plugins
:Lazy update

# Actualizar servidores LSP
:MasonUpdate

# Actualizar Treesitter
:TSUpdate
```

## 📝 Créditos

### Desarrollado por:
- **Dani** - Configuración base y estructura modular
- **Comunidad Neovim** - Plugins y configuraciones de referencia

### Recursos:
- [Neovim Documentation](https://neovim.io/doc/user/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)
- [Neovim 0.11 LSP API](https://github.com/neovim/neovim/releases/tag/v0.11.0)

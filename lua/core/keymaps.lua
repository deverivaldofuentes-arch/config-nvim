-- Keyboard Mappings
-- =================

-- Función auxiliar para crear mappings
local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Navegación mejorada
map('n', '<C-d>', '<C-d>zz', 'Scroll down half page centered')
map('n', '<C-u>', '<C-u>zz', 'Scroll up half page centered')
map('n', 'n', 'nzzzv', 'Next search result centered')
map('n', 'N', 'Nzzzv', 'Previous search result centered')

-- Movimiento entre ventanas
map('n', '<C-h>', '<C-w>h', 'Move to left window')
map('n', '<C-j>', '<C-w>j', 'Move to below window')
map('n', '<C-k>', '<C-w>k', 'Move to above window')
map('n', '<C-l>', '<C-w>l', 'Move to right window')

-- Redimensionar ventanas
map('n', '<S-Left>', '<C-w><', 'Decrease window width')
map('n', '<S-Right>', '<C-w>>', 'Increase window width')
map('n', '<S-Up>', '<C-w>+', 'Increase window height')
map('n', '<S-Down>', '<C-w>-', 'Decrease window height')

-- Gestión de buffers
map('n', '<leader>bn', ':bnext<CR>', 'Next buffer')
map('n', '<leader>bp', ':bprevious<CR>', 'Previous buffer')
map('n', '<leader>bd', ':bdelete<CR>', 'Close buffer')
map('n', '<leader>ba', ':%bd|e#<CR>', 'Close all but current')
map('n', '<leader>bs', ':buffers<CR>', 'Show buffer list')

-- Gestión de pestañas
map('n', '<leader>tn', ':tabnew<CR>', 'New tab')
map('n', '<leader>tc', ':tabclose<CR>', 'Close tab')
map('n', '<leader>tl', ':tabnext<CR>', 'Next tab')
map('n', '<leader>th', ':tabprevious<CR>', 'Previous tab')

-- Búsqueda y reemplazo
map('n', '<leader>sr', ':%s/\\<<C-r><C-w>\\>//g<Left><Left>', 'Replace word under cursor')
map('n', '<leader>sw', ':%s/\\s\\+$//e<CR>', 'Remove trailing whitespace')

-- Sistema de archivos
map('n', '<leader>w', ':write<CR>', 'Save file')
map('n', '<leader>W', ':wall<CR>', 'Save all files')
map('n', '<leader>q', ':quit<CR>', 'Quit')
map('n', '<leader>Q', ':quitall<CR>', 'Quit all')

-- Misceláneo
map('n', '<leader>h', ':nohlsearch<CR>', 'Clear search highlight')
map('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>', 'CD to file directory')

-- Terminal
map('t', '<Esc>', '<C-\\><C-n>', 'Exit terminal mode')
map('n', '<leader>tt', ':terminal<CR>', 'Open terminal')

-- LSP mappings (definiciones por compatibilidad)
map('n', 'gd', function() vim.lsp.buf.definition() end, 'Go to definition')
map('n', 'gr', function() vim.lsp.buf.references() end, 'Go to references')
map('n', 'gi', function() vim.lsp.buf.implementation() end, 'Go to implementation')
map('n', 'K', function() vim.lsp.buf.hover() end, 'Show documentation')
map('n', '<leader>ca', function() vim.lsp.buf.code_action() end, 'Code action')
map('n', '<leader>rn', function() vim.lsp.buf.rename() end, 'Rename symbol')
map('n', '<leader>f', function() vim.lsp.buf.format() end, 'Format buffer')
map('n', '<leader>dl', function() vim.diagnostic.open_float() end, 'Show diagnostic')
map('n', '[d', function() vim.diagnostic.goto_prev() end, 'Previous diagnostic')
map('n', ']d', function() vim.diagnostic.goto_next() end, 'Next diagnostic')

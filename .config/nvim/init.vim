call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tjdevries/colorbuddy.nvim'
Plug 'rktjmp/lush.nvim'
Plug 'nvim-lua/plenary.nvim'

Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'simrat39/rust-tools.nvim'
Plug 'mfussenegger/nvim-dap'

Plug 'whonore/Coqtail'

Plug 'sainnhe/sonokai'
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/everforest'
Plug 'sainnhe/edge'
Plug 'EdenEast/nightfox.nvim'
Plug 'preservim/vim-colors-pencil'
Plug 'mweisshaupt1988/neobeans.vim', { 'as': 'neobeans' }
Plug 'tjdevries/colorbuddy.nvim', { 'branch': 'dev' }
Plug 'jesseleite/nvim-noirbuddy'
Plug 'mcchrish/zenbones.nvim'
Plug 'ellisonleao/gruvbox.nvim'

Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'lewis6991/gitsigns.nvim'

Plug 'karb94/neoscroll.nvim'

Plug 'numToStr/Comment.nvim'

Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
call plug#end()

syntax on

set spelllang=en,ru

set termguicolors
set encoding=utf-8
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smarttab
set scrolloff=3

function Fmt()
    !cargo fmt
    call feedkeys("<CR>")
endfunction

autocmd BufWritePost *.rs call Fmt()
autocmd BufWritePost *.tex !pdflatex %

nnoremap q :nohlsearch<CR>

let g:gruvbox_material_foreground = 'material'
colorscheme gruvbox-material

lua << EOF
require('nvim-treesitter.configs').setup {
    ensure_installed = { "rust", "toml", "latex", "bibtex", "lua", "markdown", "dockerfile", "vim" },
    auto_install = true,
    highlight = { enable = true },
    incremental_selection = { enable = true }
}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.registers, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
vim.keymap.set('n', '<leader>git', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gst', builtin.git_status, {})
vim.keymap.set('n', '<leader>dig', builtin.diagnostics, {})
require('gitsigns').setup{}
local cmp = require('cmp');
cmp.setup {
    completion = {
        autocomplete = false
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false })
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = "path" }
    }, {
        { name = 'buffer' }
    })
}
local rt = require("rust-tools")
local lspconfig = require('lspconfig')
local on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'K', rt.hover_actions.hover_actions, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', rt.code_action_group.code_action_group, bufopts)
end
rt.setup {
    tools = { inlay_hints = { only_current_line = true } },
    server = {
        on_attach = on_attach,
        cmd = {'rustup', 'run', 'stable', 'rust-analyzer'},
        capabilities = require('cmp_nvim_lsp').default_capabilities{},
        settings = { ["rust-analyzer"] = { check = { command = { "clippy" } } } }
    }
}
local dap = require('dap')
vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>dcn', dap.continue)
vim.keymap.set('n', '<leader>dsi', dap.step_into)
vim.keymap.set('n', '<leader>dso', dap.step_out)
vim.keymap.set('n', '<leader>dsv', dap.step_over)
vim.keymap.set('n', '<leader>do', dap.repl.open)
vim.keymap.set('n', '<leader>dc', dap.repl.close)
local dap_ui_widgets = require('dap.ui.widgets')
vim.keymap.set({'n', 'v'}, '<leader>dh', dap_ui_widgets.hover)
vim.keymap.set({'n', 'v'}, '<leader>dp', dap_ui_widgets.preview)
vim.keymap.set('n', '<leader>df', function()
    dap_ui_widgets.centered_float(dap_ui_widgets.frames)
end)
vim.keymap.set('n', '<leader>ds', function()
    dap_ui_widgets.centered_float(dap_ui_widgets.scopes)
end)
lspconfig.texlab.setup{}
require('lualine').setup{}
require('neoscroll').setup()
require('Comment').setup()
EOF

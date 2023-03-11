call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'sainnhe/sonokai'
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/everforest'
Plug 'sainnhe/edge'
Plug 'EdenEast/nightfox.nvim'
Plug 'preservim/vim-colors-pencil'
Plug 'mweisshaupt1988/neobeans.vim', { 'as': 'neobeans' }
Plug 'tjdevries/colorbuddy.nvim', { 'branch': 'dev' }
Plug 'jesseleite/nvim-noirbuddy'
Plug 'alligator/accent.vim'
Plug 'andreasvc/vim-256noir'

Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
call plug#end()

syntax on

set termguicolors
set encoding=utf-8
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smarttab
set scrolloff=3
set background=dark
" set completeopt-=preview

function Fmt()
    !cargo fmt
    call feedkeys("<CR>")
endfunction

autocmd BufWritePost *.rs call Fmt()
autocmd BufWritePost *.tex !pdflatex %

nnoremap q :nohlsearch<CR>

let g:vimsyn_embed = 'l'

let g:sonokai_style = 'default'
let g:gruvbox_material_foreground = 'mix'
let g:gruvbox_material_background = 'soft'
let g:everforest_background = 'default'
let g:accent_colour = 'cyan'
" colorscheme noirbuddy

lua << EOF
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true
    }
}
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
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = "path" }
    }, {
        { name = 'buffer' }
    })
}
local on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
end
require('lspconfig').rust_analyzer.setup {
    on_attach = on_attach,
    cmd = {'rustup', 'run', 'stable', 'rust-analyzer'},
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = { "clippy" }
            }
        }
    }
}
require('noirbuddy').setup {
    preset = 'minimal'
}
local noirbuddy_lualine = require('noirbuddy.plugins.lualine')
require('lualine').setup {
    options = {
        theme = noirbuddy_lualine.theme
    },
    sections = noirbuddy_lualine.sections,
    inactive_sections = noirbuddy_lualine.inactive_sections
}
EOF

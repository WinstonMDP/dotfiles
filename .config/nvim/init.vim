call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'rktjmp/lush.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'mfussenegger/nvim-lint'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'L3MON4D3/LuaSnip', {'do': 'make install_jsregexp'}
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'mfussenegger/nvim-dap'

Plug 'whonore/Coqtail'

Plug 'tpope/vim-repeat'

Plug 'ggandor/leap.nvim'

Plug 'tjdevries/colorbuddy.nvim', { 'branch': 'dev' }
Plug 'jesseleite/nvim-noirbuddy'

Plug 'sainnhe/gruvbox-material'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'rose-pine/neovim'

Plug 'sainnhe/sonokai'
Plug 'sainnhe/everforest'
Plug 'sainnhe/edge'
Plug 'EdenEast/nightfox.nvim'
Plug 'preservim/vim-colors-pencil'
Plug 'mweisshaupt1988/neobeans.vim', { 'as': 'neobeans' }
Plug 'mcchrish/zenbones.nvim'
Plug 'shaunsingh/nord.nvim'
Plug 'Mofiqul/dracula.nvim'
Plug 'ishan9299/nvim-solarized-lua'
Plug 'rafamadriz/neon'
Plug 'folke/tokyonight.nvim'
Plug 'marko-cerovac/material.nvim'
Plug 'Abstract-IDE/Abstract-cs'
Plug 'Mofiqul/vscode.nvim'
Plug 'nyoom-engineering/oxocarbon.nvim'
Plug 'jim-at-jibba/ariake-vim-colors'
Plug 'mhartington/oceanic-next'
Plug 'tanvirtin/monokai.nvim'
Plug 'savq/melange-nvim'
Plug 'fenetikm/falcon'
Plug 'shaunsingh/moonlight.nvim'
Plug 'navarasu/onedark.nvim'
Plug 'kdheepak/monochrome.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'FrenzyExists/aquarium-vim'
Plug 'kvrohit/substrata.nvim'
Plug 'luisiacc/gruvbox-baby'
Plug 'nvimdev/zephyr-nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'kvrohit/rasmus.nvim'
Plug 'ramojus/mellifluous.nvim'
Plug 'olivercederborg/poimandres.nvim'
Plug 'maxmx03/FluoroMachine.nvim'

Plug 'nvim-lualine/lualine.nvim'

Plug 'numToStr/Comment.nvim'

Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'nvim-telescope/telescope-file-browser.nvim'

Plug 'folke/which-key.nvim'

Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'folke/todo-comments.nvim'
call plug#end()

syntax on

autocmd FileType tex,markdown setlocal spell

set spelllang=en,ru,de
set termguicolors
set encoding=utf-8
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smarttab
set number
set relativenumber
set listchars=trail:~,tab:>-,nbsp:+
set list
set scrolloff=4
set nowrap

let g:gruvbox_material_background='hard'
let g:gruvbox_material_foreground='mix'

function RustFmt()
    !cargo fmt
    call feedkeys("<CR>")
endfunction

function CppFmt()
    !clang-format -i %
    call feedkeys("<CR>")
endfunction

autocmd BufWritePost *.rs call RustFmt()
autocmd BufWritePost *.tex !pdflatex -output-directory %:p:h %
autocmd BufWritePost *.cpp,*.h call CppFmt()

au BufWritePost * lua require('lint').try_lint()


lua << EOF
require('nvim-treesitter.configs').setup({
    ensure_installed = {"vim", "vimdoc", "lua", "gitignore", "rust", "toml", "latex", "markdown", "yaml", "cpp", "kotlin"},
    highlight = { enable = true },
    incremental_selection = { enable = true }
})

local leap = require('leap')
leap.add_default_mappings()
leap.opts.safe_labels = {}

require('noirbuddy').setup({
    colors = {
        background = '#000000',
        primary = '#ffffff'
    }
})
local Color, colors, Group, groups, styles = require('colorbuddy').setup({})
Group.new('ErrorMsg', colors_primary, colors.background)
Group.new('SpellBad', colors.diagnostic_error)
Group.new('SpellRare', colors.diagnostic_warning)

require("mason").setup()
require("mason-lspconfig").setup()

require('lint').linters_by_ft = { markdown = { 'markdownlint' } }

local luasnip = require('luasnip')

local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4)
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' }
    }),
    experimental = {
        ghost_text = true,
    }
})

vim.keymap.set({"i", "s"}, "<C-J>", function() luasnip.jump(1) end, { desc = "next snippet item" })
vim.keymap.set({"i", "s"}, "<C-K>", function() luasnip.jump(-1) end, { desc = "previous snippet item" })

require('todo-comments').setup()

local my_capabilities = require('cmp_nvim_lsp').default_capabilities()

local telescope = require('telescope')
telescope.setup {
    defaults = { file_ignore_patterns = { "%.pdf" } },
    extensions = { file_browser = { hijack_netrw = true } }
}
telescope.load_extension("file_browser")
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "find files" })
vim.keymap.set('n', '<leader>fl', builtin.live_grep, { desc = "search input string, respecting .gitignore" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "buffers" })
vim.keymap.set('n', '<leader>fgc', builtin.git_commits, { desc = "commits" })
vim.keymap.set('n', '<leader>fgs', builtin.git_status, { desc = "git status" })
vim.keymap.set('n', '<leader>fdi', builtin.diagnostics, { desc = "diagnostics" })
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = "document symbols" })
vim.keymap.set('n', '<leader>ftd', require("telescope._extensions.todo-comments").exports.todo, { desc = "todo-comments" })

vim.keymap.set('n', '<leader>di', vim.diagnostic.open_float, { desc = "open diagnostic in float" })

local lspconfig = require('lspconfig')
vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, { desc = "go to declaration" })
vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions, { desc = "definitions" })
vim.keymap.set('n', '<leader>gi', builtin.lsp_implementations, { desc = "implementations" })
vim.keymap.set('n', '<leader>gr', builtin.lsp_references, { desc = "references" })
vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, { desc = "hover actions" })
vim.keymap.set('n', '<leader><C-k>', vim.lsp.buf.signature_help, { desc = "signature help" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "rename" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "code action" })

lspconfig.rust_analyzer.setup({
    cmd = {'rustup', 'run', 'stable', 'rust-analyzer'},
    capabilities = my_capabilities,
    settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
})

local dap = require('dap')
vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, { desc = "toggle breakpoint " })
vim.keymap.set('n', '<leader>dn', dap.continue, { desc = "continue" })
vim.keymap.set('n', '<leader>dsi', dap.step_into, { desc = "step into" })
vim.keymap.set('n', '<leader>dso', dap.step_out, { desc = "step out" })
vim.keymap.set('n', '<leader>dsv', dap.step_over, { desc = "step over"})
vim.keymap.set('n', '<leader>do', dap.repl.open, { desc = "dap open" })
vim.keymap.set('n', '<leader>dc', dap.repl.close, { desc = "dap close" })
vim.keymap.set('n', '<leader>dq', dap.terminate, { desc = "dap terminate" })
local dap_ui_widgets = require('dap.ui.widgets')
vim.keymap.set({'n', 'v'}, '<leader>dh', dap_ui_widgets.hover, { desc = "dap hover" })
vim.keymap.set({'n', 'v'}, '<leader>dp', dap_ui_widgets.preview, { desc = "dap preview" })
vim.keymap.set('n', '<leader>df', function() dap_ui_widgets.centered_float(dap_ui_widgets.frames) end, { desc = "dap frames" })
vim.keymap.set('n', '<leader>dsc', function() dap_ui_widgets.centered_float(dap_ui_widgets.scopes) end, { desc = "dap scopes" })

lspconfig.texlab.setup({
    capabilities = my_capabilities
})

lspconfig.kotlin_language_server.setup({
    capabilities = my_capabilities
})

require('lualine').setup({
    options = {
        section_separators = '',
        component_separators = ''
    }
})

require('Comment').setup()
require("which-key").setup{ triggers = "" }
EOF

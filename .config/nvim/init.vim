call plug#begin()
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'rktjmp/lush.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
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
Plug 'mcchrish/zenbones.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'shaunsingh/nord.nvim'

Plug 'tjdevries/colorbuddy.nvim', { 'branch': 'dev' }
Plug 'jesseleite/nvim-noirbuddy'

Plug 'nvim-lualine/lualine.nvim'

Plug 'numToStr/Comment.nvim'

Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }

Plug 'folke/which-key.nvim'
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

let g:netrw_banner=0
let g:netrw_liststyle=3

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

lua << EOF
require('nvim-treesitter.configs').setup({
    ensure_installed = { "vim", "lua", "rust", "toml", "latex", "bibtex", "markdown", "dockerfile", "agda" },
    auto_install = true,
    highlight = { enable = true },
    incremental_selection = { enable = true }
})

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

local cmp = require('cmp')
cmp.setup({
    completion = { autocomplete = false },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
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
})

require('telescope').setup({ defaults = { file_ignore_patterns = { "%.pdf" } } })
local builtin = require('telescope.builtin')
vim.keymap.set('n', '.ff', builtin.find_files, { desc = "find files" })
vim.keymap.set('n', '.fl', builtin.live_grep, { desc = "search input string, respecting .gitignore" })
vim.keymap.set('n', '.fb', builtin.buffers, { desc = "buffers" })
vim.keymap.set('n', '.git', builtin.git_commits, { desc = "commits" })
vim.keymap.set('n', '.gst', builtin.git_status, { desc = "git status" })
vim.keymap.set('n', '.di', builtin.diagnostics, { desc = "diagnostics" })

vim.keymap.set('n', '<leader>di', vim.diagnostic.open_float, { desc = "open diagnostic in float" })
vim.diagnostic.config({ float = { border = "single" } })

local lspconfig = require('lspconfig')

local rt = require("rust-tools")
local on_attach = function(client, bufnr)
    vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, { desc = "go to declaration" })
    vim.keymap.set('n', '<leader>gd', builtin.lsp_definitions, { desc = "definitions" })
    vim.keymap.set('n', '<leader>gi', builtin.lsp_implementations, { desc = "implementations" })
    vim.keymap.set('n', '<leader>K', rt.hover_actions.hover_actions, { desc = "hover actions" })
    vim.keymap.set('n', '<leader><C-k>', vim.lsp.buf.signature_help, { desc = "signature help" })
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "rename" })
    vim.keymap.set('n', '<leader>ca', rt.code_action_group.code_action_group, { desc = "code action" })
end
rt.setup({
    tools = {
        inlay_hints = { only_current_line = true },
        hover_actions = { auto_focus = true }
    },
    server = {
        on_attach = on_attach,
        cmd = {'rustup', 'run', 'stable', 'rust-analyzer'},
        capabilities = require('cmp_nvim_lsp').default_capabilities{},
        settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
    }
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
vim.keymap.set('n', '<leader>df', function()
    dap_ui_widgets.centered_float(dap_ui_widgets.frames)
end, { desc = "dap frames" })
vim.keymap.set('n', '<leader>dsc', function()
    dap_ui_widgets.centered_float(dap_ui_widgets.scopes)
end, { desc = "dap scopes" })

lspconfig.texlab.setup({})

require('lualine').setup({
    options = {
        section_separators = '',
        component_separators = ''
    }
})

require('Comment').setup()
require("which-key").setup{ triggers = "" }
EOF

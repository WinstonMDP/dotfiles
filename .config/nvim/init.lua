-- TODO: DAP

vim.opt.termguicolors = true

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.smarttab = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = false
vim.opt.scrolloff = 4

vim.opt.listchars = { trail = "~", tab = ">-", nbsp = "+" }
vim.opt.list = true

vim.opt.virtualedit = "block"

vim.o.timeout = false

vim.opt.spelllang = { "en", "ru", "de" }
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tex", "markdown" },
    callback = function() vim.opt_local.spell = true end,
})

vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "go to declaration" })
vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { desc = "hover actions" })
vim.keymap.set("n", "<leader><C-k>", vim.lsp.buf.signature_help, { desc = "signature help" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "rename" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float, { desc = "open diagnostic in float" })

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.tex" },
    command = "!pdflatex -output-directory %:p:h %",
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "jesseleite/nvim-noirbuddy",
        priority = 1000,
        dependencies = { "tjdevries/colorbuddy.nvim", branch = "dev" },
        config = function()
            require("noirbuddy").setup({
                colors = {
                    background = "#000000",
                    primary = "#ffffff",
                },
            })
            local _, colors, Group, _, _ = require("colorbuddy").setup()
            Group.new("ErrorMsg", colors.primary, colors.background)
            Group.new("SpellBad", colors.diagnostic_error)
            Group.new("SpellRare", colors.diagnostic_warning)
        end,
    },
    {
        "sainnhe/gruvbox-material",
        event = "VeryLazy",
        config = function()
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_foreground = "mix"
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        event = "VeryLazy",
        config = true,
    },
    {
        "sainnhe/sonokai",
        event = "VeryLazy",
        config = true,
    },
    {
        "rose-pine/neovim",
        name = "rose",
        event = "VeryLazy",
    },
    {
        "tanvirtin/monokai.nvim",
        event = "VeryLazy",
    },
    {
        "folke/tokyonight.nvim",
        event = "VeryLazy",
        config = true,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        priority = 900,
        build = ":TSUpdate",
        config = function()
            ---@diagnostic disable: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "vim",
                    "vimdoc",
                    "lua",
                    "gitignore",
                    "rust",
                    "toml",
                    "latex",
                    "markdown",
                    "yaml",
                    "cpp",
                    "kotlin",
                },
                highlight = { enable = true },
                incremental_selection = { enable = true },
            })
            ---@diagnostic enable: missing-fields
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {
            options = {
                section_separators = "",
                component_separators = "",
            },
        },
    },
    {
        "numToStr/Comment.nvim",
        config = true,
    },
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "folke/neodev.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()

            require("neodev").setup()

            local my_capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({ capabilities = my_capabilities })
            lspconfig.rust_analyzer.setup({
                cmd = { "rustup", "run", "stable", "rust-analyzer" },
                capabilities = my_capabilities,
                settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
            })
            lspconfig.texlab.setup({ capabilities = my_capabilities })
            lspconfig.kotlin_language_server.setup({ capabilities = my_capabilities })
        end,
    },
    {
        "mhartington/formatter.nvim",
        config = function()
            require("formatter").setup({
                logging = true,
                log_level = vim.log.levels.WARN,
                filetype = {
                    lua = { require("formatter.filetypes.lua").stylua },
                    rust = {
                        function()
                            return {
                                exe = "rustfmt",
                                stdin = true,
                            }
                        end,
                    },
                },
            })
            vim.api.nvim_create_autocmd("BufWritePost", { command = "FormatWriteLock" })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = { markdown = { "markdownlint" } }
            vim.api.nvim_create_autocmd("BufWritePost", { callback = function() require("lint").try_lint() end })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        priority = 800,
        dependencies = {
            { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                }),
                sources = cmp.config.sources({
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
                experimental = {
                    ghost_text = true,
                },
            })

            vim.keymap.set({ "i", "s" }, "<C-J>", function() luasnip.jump(1) end, { desc = "next snippet item" })
            vim.keymap.set({ "i", "s" }, "<C-K>", function() luasnip.jump(-1) end, { desc = "previous snippet item" })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            "folke/todo-comments.nvim",
        },
        config = function()
            local telescope = require("telescope")

            telescope.setup({
                defaults = { file_ignore_patterns = { "%.pdf" } },
                extensions = { file_browser = { hijack_netrw = true } },
            })

            telescope.load_extension("file_browser")

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "find files" })
            vim.keymap.set(
                "n",
                "<leader>fl",
                builtin.live_grep,
                { desc = "search input string, respecting .gitignore" }
            )
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "buffers" })
            vim.keymap.set("n", "<leader>fgc", builtin.git_commits, { desc = "commits" })
            vim.keymap.set("n", "<leader>fgs", builtin.git_status, { desc = "git status" })
            vim.keymap.set("n", "<leader>fdi", builtin.diagnostics, { desc = "diagnostics" })
            vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "document symbols" })
            vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, { desc = "definitions" })
            vim.keymap.set("n", "<leader>gi", builtin.lsp_implementations, { desc = "implementations" })
            vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { desc = "references" })
            vim.keymap.set(
                "n",
                "<leader>ftd",
                require("telescope._extensions.todo-comments").exports.todo,
                { desc = "todo-comments" }
            )
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = true,
    },
    {
        "ggandor/leap.nvim",
        dependencies = "tpope/vim-repeat",
        config = function()
            local leap = require("leap")
            vim.keymap.set({ "n", "x", "o" }, "f", "<Plug>(leap-forward-to)")
            vim.keymap.set({ "n", "x", "o" }, "F", "<Plug>(leap-backward-to)")
            vim.keymap.set({ "n", "x", "o" }, "t", "<Plug>(leap-forward-till)")
            vim.keymap.set({ "n", "x", "o" }, "T", "<Plug>(leap-backward-till)")
            vim.keymap.set({ "n", "x", "o" }, "<leader>w", "<Plug>(leap-from-window)")
            leap.opts.safe_labels = {}
            leap.add_repeat_mappings(";", ",", {
                relative_directions = true,
                modes = { "n", "x", "o" },
            })
        end,
    },
    { "kylechui/nvim-surround", config = true },
    { "whonore/Coqtail", ft = "coq" },
})

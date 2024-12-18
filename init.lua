-- Initialize lazy.nvim
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

-- Set leader key before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4  -- Set indentation to 4 spaces
vim.opt.tabstop = 4     -- Set tab size to 4 spaces
vim.opt.softtabstop = 4 -- Set softtabstop to 4 spaces
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menuone,noselect"
vim.cmd([[highlight IndentBlanklineChar guifg=#7C6F64]])
vim.cmd([[highlight IndentBlanklineContextChar guifg=#D79921]])
vim.opt.writedelay = 1000 -- Save the buffer after 1 second of inactivity

vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight SignColumn guibg=NONE ctermbg=NONE]]) -- Make sign column transparent
vim.cmd([[highlight VertSplit guibg=NONE ctermbg=NONE]])  -- Make vertical splits transparent
vim.cmd([[highlight StatusLine guibg=NONE ctermbg=NONE]]) -- Make status line transparent
vim.cmd([[highlight TabLine guibg=NONE ctermbg=NONE]])    -- Make tab line transparent
vim.cmd([[highlight Pmenu guibg=NONE ctermbg=NONE]])
-- Enable auto-indentation for JSX/TSX and other common languages
vim.cmd([[
augroup FileTypeIndent
  autocmd!
  " For JavaScript, TypeScript, and JSX/TSX
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  " For HTML
  autocmd FileType html,css,scss setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  " For Python
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  " For Go
  autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  " For Lua
  autocmd FileType lua setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  " For other filetypes as needed...
augroup END
]])

-- Plugin specifications
require("lazy").setup({
    -- Theme
    --   -- Theme
    {
        -- You can easily change to a different colorscheme.
        -- Change the name of the colorscheme plugin below, and then
        -- change the command in the config to whatever the name of that colorscheme is.
        --
        -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
        -- 'folke/tokyonight.nvim',
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        init = function()
            -- Load the colorscheme here.
            -- Like many other themes, this one has different styles, and you could load
            -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
            vim.cmd.colorscheme 'catppuccin'
            -- You can configure highlights by doing something like:
            vim.cmd.hi 'Comment gui=none'
        end,
    },

    -- Additional transparency settings
    vim.cmd([[
  " Make background transparent
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight SignColumn guibg=NONE ctermbg=NONE
  highlight VertSplit guibg=NONE ctermbg=NONE
  highlight StatusLine guibg=NONE ctermbg=NONE
  highlight StatusLineNC guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
  highlight CursorLineNr guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
]]),
    -- Telescope for fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git" },
                },
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup()
        end
    },

    -- Crackboard

    {
        'boganworld/crackboard.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crackboard').setup({
                session_key = 'f2cd778595204a576a99b7c5a25ab207831a7b6f123f2157544380aeebb78aa0',
            })
        end,
    },
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
    -- Formatter plugin
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- Prettier for multiple languages
                    null_ls.builtins.formatting.prettier,
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({
                                    bufnr = bufnr,
                                    filter = function(client)
                                        return client.name == "null-ls"
                                    end
                                })
                            end
                        })
                    end
                end
            })
        end
    },
    {
        'kyallanum/dashboard-nvim',
        branch = 'bugfix/support_spaces',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                theme = 'hyper',
                config = {
                    shortcut = {},
                },
            }
        end,
    },
{"tpope/copilot.vim", event = "VimEnter", cmd = "Copilot", setup = function(), config = function() vim.g.copilot#enable() end},
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            local autopairs = require('nvim-autopairs')
            local Rule = require('nvim-autopairs.rule')
            local cond = require('nvim-autopairs.conds')

            autopairs.setup({
                -- General settings
                disable_filetype = { "TelescopePrompt", "vim" },
                disable_in_macro = false,
                disable_in_visualblock = false,
                enable_moveright = true,
                enable_afterquote = true,
                enable_check_bracket_line = true,

                -- Treesitter integration
                check_ts = true,
                ts_config = {
                    lua = { 'string' },
                    javascript = { 'template_string' },
                    java = false,
                },

                -- Bracket and quote pairing
                fast_wrap = {
                    map = '<M-e>', -- Alt+e to fast wrap
                    chars = { '{', '[', '(', '"', "'" },
                    pattern = [=[[%'%"%>%]%)%}%,]]=],
                    end_key = '$',
                    keys = 'qwertyuiopzxcvbnmasdfghjkl',
                    check_comma = true,
                    highlight = 'Search',
                    highlight_grey = 'Comment'
                },

                -- Specific rules for different scenarios
                map_cr = true,
                map_bs = true, -- map backspace
                map_c_h = false, -- Map <C-h> to delete pairs
            })

            -- HTML and XML specific auto-close tags
            autopairs.add_rules({
                -- Auto-close HTML tags
                Rule("<", ">",
                    { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" })
                    :with_pair(function(opts)
                        local pair = opts.line:sub(opts.col - 1, opts.col)
                        return pair ~= "<"
                    end)
                    :with_move(cond.done())
                    :use_key(">")
                    :replace_endpair(function(opts)
                        local prev_line = opts.line:sub(1, opts.col - 1)
                        local next_char = opts.line:sub(opts.col, opts.col)

                        -- Check if it's a self-closing tag or a complete tag
                        if next_char ~= ">" then
                            return "</" .. prev_line:match("<(%w+)") .. ">"
                        end
                        return ""
                    end),
            })

            -- Special pairs for different languages
            autopairs.add_rules({
                -- Add space inside pairs
                Rule(" ", " ")
                    :with_pair(function(opts)
                        local pair = opts.line:sub(opts.col - 1, opts.col)
                        return vim.tbl_contains({ "()", "[]", "{}" }, pair)
                    end),

                -- Auto-add closing bracket for function definitions
                Rule("(", ")")
                    :use_key(")")
                    :with_pair(cond.not_before_text("[")),
            })

            -- Integration with completion (optional)
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on(
                'confirm_done',
                cmp_autopairs.on_confirm_done()
            )
        end,
        dependencies = {
            'hrsh7th/nvim-cmp', -- Optional: for completion integration
        }
    },
    {                   -- Useful plugin to show you pending keybinds.
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        opts = {
            icons = {
                -- set icon mappings to true if you have a Nerd Font
                mappings = vim.g.have_nerd_font,
                -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
                -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
                keys = vim.g.have_nerd_font and {} or {
                    Up = '<Up> ',
                    Down = '<Down> ',
                    Left = '<Left> ',
                    Right = '<Right> ',
                    C = '<C-ΓÇª> ',
                    M = '<M-ΓÇª> ',
                    D = '<D-ΓÇª> ',
                    S = '<S-ΓÇª> ',
                    CR = '<CR> ',
                    Esc = '<Esc> ',
                    ScrollWheelDown = '<ScrollWheelDown> ',
                    ScrollWheelUp = '<ScrollWheelUp> ',
                    NL = '<NL> ',
                    BS = '<BS> ',
                    Space = '<Space> ',
                    Tab = '<Tab> ',
                    F1 = '<F1>',
                    F2 = '<F2>',
                    F3 = '<F3>',
                    F4 = '<F4>',
                    F5 = '<F5>',
                    F6 = '<F6>',
                    F7 = '<F7>',
                    F8 = '<F8>',
                    F9 = '<F9>',
                    F10 = '<F10>',
                    F11 = '<F11>',
                    F12 = '<F12>',
                },
            },

            -- Document existing key chains
            spec = {
                { '<leader>c', group = '[C]ode',     mode = { 'n', 'x' } },
                { '<leader>d', group = '[D]ocument' },
                { '<leader>r', group = '[R]ename' },
                { '<leader>s', group = '[S]earch' },
                { '<leader>w', group = '[W]orkspace' },
                { '<leader>t', group = '[T]oggle' },
                { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
                { '<leader>l', group = '[L]SP',      mode = { 'n' } },
            },
        },
    },

    -- File Explorer

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            {
                mode = 'n',
                '<leader>n',
                '<cmd>Neotree<CR>',
                desc = 'Open Neotree viewer sidebar',
            },
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,  -- Close Neotree if it's the last window
                filesystem = {
                    follow_current_file = false, -- Don't automatically focus the current file
                    hijack_netrw_behavior = "disabled", -- Disable netrw completely
                    filtered_items = {
                        visible = true,       -- Make all files, including dotfiles, visible
                        hide_dotfiles = false, -- Show dotfiles
                        hide_gitignored = false, -- Show git-ignored files
                        hide_hidden = false,  -- Show hidden files
                    },
                },
                window = {
                    position = "left", -- Set Neotree to open on the right
                    width = 40, -- Width of the Neotree window
                },
            })

            -- Ensure Neotree is not opened on startup
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    vim.cmd("Neotree close")
                end,
            })
        end,
    },
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        init = function()
            vim.g.barbar_auto_setup = false
            -- Keymaps for buffer navigation and management
            vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>',
                { noremap = true, silent = true, desc = 'Previous buffer' })
            vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })
            vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>',
                { noremap = true, silent = true, desc = 'Close current buffer' })
            vim.keymap.set('n', '<A-s-c>', '<Cmd>BufferCloseAllButCurrent<CR>',
                { noremap = true, silent = true, desc = 'Close all buffers except current' })
        end,
        opts = {
            -- Animation settings
            animation = true,
            auto_hide = 1, -- Hide buffer bar when fewer than 2 buffers are open

            -- Buffer placement
            insert_at_start = false,
            insert_at_end = false,

            -- Sidebar configuration
            sidebar_filetypes = {
                NvimTree = true,
                undotree = { text = 'Undotree', align = 'center' },
                ['neo-tree'] = { event = 'BufWipeout' },
                Outline = {
                    event = 'BufWinLeave',
                    text = 'Symbols Outline',
                    align = 'right'
                },
            },

            -- Icon configuration
            icons = {
                buffer_index = true, -- Show buffer index in the tabline
                buffer_number = false,
                button = '×', -- Close button
                diagnostics = {
                    [vim.diagnostic.severity.ERROR] = { enabled = true, icon = '✘' },
                    [vim.diagnostic.severity.WARN] = { enabled = true, icon = '⚠' },
                    [vim.diagnostic.severity.INFO] = { enabled = true, icon = 'ℹ' },
                    [vim.diagnostic.severity.HINT] = { enabled = true, icon = '💡' },
                },
                filetype = {
                    enabled = true, -- Enable file type icons
                    custom_colors = true, -- Use custom colors for file type icons
                },
                separator = {
                    left = '▎',
                    right = '',
                },
                inactive = {
                    button = '', -- No close button for inactive buffers
                },
            },

            -- Maximum padding
            maximum_padding = 1,
            minimum_padding = 1,
            maximum_length = 30, -- Maximum buffer name length

            -- Semantic highlighting
            semantic_letters = true,
            no_name_title = '[No Name]',
        },
        version = '^1.0.0',
    },
    -- Auto-close tags
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
                indent = {
                    char = "│", -- Customize this if desired
                    tab_char = "│",
                    highlight = "IndentBlanklineChar",
                },
                scope = {
                    enabled = true,
                    show_start = false,
                    show_end = false,
                    highlight = "IndentBlanklineContextChar",
                },
            })
        end,
    },

    -- Autocomplete setup
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- LSP, Mason, and related configurations
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "ts_ls",
                    "rust_analyzer",
                    "html",
                    "cssls",
                    "eslint",
                },
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local servers = {
                "lua_ls",
                "pyright",
                "ts_ls",
                "rust_analyzer",
                "html",
                "cssls",
                "eslint",
            }

            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup({
                    capabilities = capabilities,
                })
            end
        end,
    },
})

-- Key mappings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Navigation mappings
map("n", "<leader>e", ":Neotree toggle<CR>")        -- Toggle file explorer
map("n", "<leader>ff", ":Telescope find_files<CR>") -- Find files
map("n", "<leader>fg", ":Telescope live_grep<CR>")  -- Find text
map("n", "<leader>fb", ":Telescope buffers<CR>")    -- Find buffers
map("n", "<leader>fh", ":Telescope help_tags<CR>")  -- Find help

-- Indentation mappings
map("n", "<leader>i", ">>", { silent = true })  -- Indent current line right
map("v", "<leader>i", ">gv", { silent = true }) -- Indent selected block right

-- Indent entire file (new binding)
map("n", "<leader>I", "gg=G", { silent = true }) -- Indent the entire file

-- Additional mappings
map("n", "<leader>w", ":w<CR>") -- Save
map("n", "<leader>q", ":q<CR>") -- Quit
map("n", "<ESC>", ":noh<CR>")   -- Clear search highlights
map("n", "<C-s>", ":w<CR>")     -- Save with Ctrl+S
map("n", "<leader>f", ":lua vim.lsp.buf.format()<CR>", { desc = "Format current buffer" })

return {
  -- Gruvbox Theme
  
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},

   {

      'romgrk/barbar.nvim',
      dependencies = {
        'lewis6991/gitsigns.nvim',     -- for git status
        'nvim-tree/nvim-web-devicons', -- for file icons
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {
        animation = true,
        insert_at_start = false,
        sidebar_filetypes = {
          NvimTree = true,
          undotree = {
            text = 'undotree',
            align = 'center', -- *optionally* specify an alignment (either 'left', 'center', or 'right')
          },
          ['neo-tree'] = { event = 'BufWipeout' },
          Outline = { event = 'BufWinLeave', text = 'symbols-outline', align = 'right' },
        },
      },
      version = '^1.0.0',
    },


  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
       ensure_installed = {
  "c", -- Treesitter Parser for C
  "cpp", -- Treesitter Parser for C++
  "json",
  "javascript",
  "typescript",
  "yaml",
  "html",
  "css",
  "markdown",
  "markdown_inline",
  "bash",
  "lua",
  "vim",
  "dockerfile",
  "gitignore",
  "tsx",
  "go",
  "zig",
  "java",
  "rust",
},
        highlight = { enable = true },
        indent = { enable = true }, -- Enable treesitter indentation
      })
    end
  },

{
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional: for icons
        config = function()
            require("lualine").setup {
                options = {
                    theme = "gruvbox", -- Or set your custom theme
                },
            }
        end
    },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = true },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
        },
      },
    },
  },

  -- Auto pairs and tags
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
      "php",
      "markdown",
      "astro",
      "glimmer",
      "handlebars",
      "hbs",
    },
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<C-p>', function() require('telescope.builtin').find_files() end, desc = 'Find Files' },
    },
  },

  -- Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { '<C-n>', ':Neotree filesystem reveal right<CR>', desc = 'Toggle Neo-tree' },
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end
  },

  -- LSP Support
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = { 'lua_ls', 'pyright', 'ts_ls', 'html', 'cssls' },
        automatic_installation = true,
      })

      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Set up each LSP server
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.ts_ls.setup({ capabilities = capabilities,   init_options = {
    preferences = {
      disableSuggestions = false,
    }, }})
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.cssls.setup({ capabilities = capabilities })
    end
  },


    {
      'numToStr/Comment.nvim',
      opts = {},
      config = function()
        require('Comment').setup({
          padding = true,
          sticky = true,
          ignore = nil,

          toggler = {
            line = 'gcc',
            block = 'gbc',
          },

          opleader = {
            line = 'gc',
            block = 'gb',
          },

          -- extra mapping
          extra = {
            above = 'gcO',
            below = 'gco',
            eol = 'gcA',
          },

          -- enable keybinds
          mappings = {
            basic = true,
            extra = true,
          },

          pre_hook = nil,
          post_hook = nil,
        })
      end,
    },
        {
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require('nvim-treesitter').setup({
          ensure_installed = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", },
          sync_install = true,

          auto_install = true,

          -- ignore_install = { "javascript" },

          highlight = {
            enable = true,

            disable = function(lang, buf)
              local max_filesize = 100 * 1024 -- 100 KB
              local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
              if ok and stats and stats.size > max_filesize then
                return true
              end
            end,

            additional_vim_regex_highlighting = false,
          },
        })
      end,
    },
  {
      'goolord/alpha-nvim',
      dependencies = {
        'echasnovski/mini.icons',
        'nvim-lua/plenary.nvim'
      },
      config = function()
        require 'alpha'.setup(require 'alpha.themes.theta'.config)
      end
    },

    {
      "akinsho/bufferline.nvim",
      version = "*",
    },
}

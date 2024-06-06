return {
    -- {
    --     'mcchrish/zenbones.nvim',
    --     dependencies = { 'rktjmp/lush.nvim' },
    --     config = function()
    --         vim.opt.termguicolors = true
    --         vim.cmd.colorscheme('forestbones')
    --     end
    -- },
    {
        'ellisonleao/gruvbox.nvim',
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('gruvbox')
        end
    },
    -- {
    --     'rose-pine/neovim',
    --     opts = {
    --         variant = 'moon'
    --     },
    --     config = function()
    --         vim.opt.termguicolors = true
    --         vim.cmd.colorscheme('rose-pine')
    --     end
    -- },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },      -- Required
            { 'williamboman/mason.nvim' },    -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' }, -- Required

            -- format on save 
            { 'lukas-reineke/lsp-format.nvim' }
        },
        config = function()
            local lsp = require('lsp-zero').preset({})

            lsp.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp.default_keymaps({ buffer = bufnr })
            end)

            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
            require('lspconfig').tsserver.setup({ on_attach = require("lsp-format").on_attach })
            require('lspconfig').volar.setup({})
            require('lspconfig').ruff_lsp.setup({})
            require('lspconfig').rust_analyzer.setup({ on_attach = require("lsp-format").on_attach })

            lsp.setup()

--             -- rust
--             local rust_tools = require('rust-tools')
--             rust_tools.setup({
--                 server = {
--                     on_attach = function(_, bufnr)
--                         vim.keymap.set('n', '<leader>ca', rust_tools.hover_actions.hover_actions, {buffer = bufnr})
--                     end
--                 }
--             })

            -- nvim-cmp
            local cmp = require('cmp')
            cmp.setup({
                mapping = {
                    ['<Tab>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                    ['<S-Tab>'] = cmp.mapping.select_next_item(),
                }
            })
        end
    }
}

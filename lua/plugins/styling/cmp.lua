if not vim.g.vscode then
  return {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'L3MON4D3/LuaSnip', version = "v2.*" },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'FelipeLema/cmp-async-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'amarakon/nvim-cmp-buffer-lines',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind-nvim',
      'windwp/nvim-autopairs',
      'petertriho/cmp-git',
    },
    event = {
      event = "InsertEnter",
    },
    priority = 650,
    config = function()
      local ls = require("luasnip")
      local lspkind = require('lspkind')
      local status, cmp = pcall(require, 'cmp')

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )

      if status then
        lspkind.init()
        cmp.setup({
          snippet = {
            expand = function(args)
              ls.lsp_expand(args.body)
            end,
          },
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'nvim_lua' },
            { name = 'async_path' },
            { name = 'buffer' },
          }),

          mapping = cmp.mapping.preset.insert({
            ['<C-h>'] = cmp.mapping.scroll_docs(-4),
            ['<C-l>'] = cmp.mapping.scroll_docs(4),
            ['<C-j>'] = cmp.mapping.select_prev_item(),
            ['<C-k>'] = cmp.mapping.select_next_item(),
            ['<C-space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif ls.expand_or_jumpable() then
                ls.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
          }),

          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },

          formatting = {
            format = lspkind.cmp_format {
              default = true,
              kind = { "kind", "abbr", "menu" },
              menu = {
                luasnip = "[snip]",
                buffer = "[buf]",
                path = "[path]",
                nvim_lsp = "[lsp]",
              }
            }
          },
          experimental = {
            ghost_text = {
              hl_group = "LspCodeLens",
            }
          },
        })

        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = 'git' },
          }, {
            { name = 'buffer' },
          })
        })

        require("cmp_git").setup({})

        require("luasnip.loaders.from_vscode").lazy_load()
      end
    end
  }
end

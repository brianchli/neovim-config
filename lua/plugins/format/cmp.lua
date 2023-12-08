if not vim.g.vscode then
  return {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'amarakon/nvim-cmp-buffer-lines',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind-nvim',
      'p00f/clangd_extensions.nvim',
      'windwp/nvim-autopairs',
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

      -- sets the colors for the autocompletion list options

      -- gray
      vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })

      -- Fuzzy match autocompletion -
      vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#cad3f5' })
      vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })

      -- Item text - lavender
      vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#b7bdf8' })
      vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
      vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })

      -- pink
      vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
      vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })

      -- front - mauve
      vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#c6a0f6' })
      vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
      vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

      if status then
        lspkind.init()
        cmp.setup({
          preselect = cmp.PreselectMode.None,
          snippet = {
            expand = function(args)
              ls.lsp_expand(args.body)
            end,
          },
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'nvim_lua' },
            { name = 'path' },
            { name = 'buffer' },
          }),
          mapping = cmp.mapping.preset.insert({
            ['<C-h>'] = cmp.mapping.scroll_docs(-4),
            ['<C-l>'] = cmp.mapping.scroll_docs(4),
            ['<C-j>'] = cmp.mapping.select_prev_item(),
            ['<C-k>'] = cmp.mapping.select_next_item(),
            ['<C-Space>'] = cmp.mapping.complete(),
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
        require("luasnip.loaders.from_vscode").lazy_load()
      end
    end
  }
end

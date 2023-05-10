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
    },
    event = {
      event = "InsertEnter",
    },
    priority = 650,
    config = function()
      local ls = require("luasnip")
      local lspkind = require('lspkind')
      local status, cmp = pcall(require, 'cmp')
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

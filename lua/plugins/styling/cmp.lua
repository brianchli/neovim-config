if not vim.g.vscode then
  return {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = "v2.*",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        config = function(_, opts)
          if opts then require("luasnip").config.setup(opts) end
          vim.tbl_map(
            function(type) require("luasnip.loaders.from_" .. type).lazy_load() end,
            { "vscode", "snipmate", "lua" }
          )
          -- friendly-snippets - enable standardized comments snippets
          require("luasnip").filetype_extend("typescript", { "tsdoc" })
          require("luasnip").filetype_extend("javascript", { "jsdoc" })
          require("luasnip").filetype_extend("lua", { "luadoc" })
          require("luasnip").filetype_extend("python", { "pydoc" })
          require("luasnip").filetype_extend("rust", { "rustdoc" })
          require("luasnip").filetype_extend("c", { "cdoc" })
          require("luasnip").filetype_extend("cpp", { "cppdoc" })
          require("luasnip").filetype_extend("kotlin", { "kdoc" })
          require("luasnip").filetype_extend("sh", { "shelldoc" })
        end,
      },
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
            completion = {
              winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
              col_offset = -3,
              side_padding = 0,
            },
          },

          formatting = {
            fields = { "icon", "abbr", "kind", "menu" },
            format = function(entry, vim_item)
              local lspkind = require("lspkind")
              local kind = lspkind.cmp_format({
                mode = "symbol_text",
                maxwidth = 50,
                menu = {
                  luasnip = "[snip]",
                  buffer = "[buf]",
                  path = "[path]",
                  nvim_lsp = "[lsp]",

                },
                ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
              })(entry, vim_item)
              kind.icon = " " .. (kind.icon or "") .. "  "
              kind.kind = "   (" .. (kind.kind or "") .. ")"
              return kind
            end,
          },
          experimental = {
            ghost_text = true
          },
          view = {
            entries = { follow_cursor = true }
          }
        })

        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = 'git' },
          }, {
            { name = 'buffer' },
          })
        })

        require("cmp_git").setup({})
      end
    end
  }
end

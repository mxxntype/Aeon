# INFO: LSP & Completion

{
  pkgs,
  ...
}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [

    # Snippet engine
    luasnip

    # Completion sources
    cmp-path
    cmp-buffer
    cmp-nvim-lsp

    {
      plugin = nvim-cmp;
      type = "lua";
      config = ''
        --[[ Shortcuts ]]--
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        --[[ Utility functions ]]--
        local function has_words_before()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end



        --[[ Plugin setup ]]--
        cmp.setup({
          -- Configure snippets
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          -- Configure mappings
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),                 -- Manually trigger completion
            ["<C-e>"]     = cmp.mapping.abort(),                    -- Hide completion snippets when they aren't needed
            ["<Enter>"]   = cmp.mapping.confirm({ select = true }), -- Accept & autocomplete selected item

            ["<Tab>"] = cmp.mapping(function(fallback)              -- Select next item
              if cmp.visible() then
                cmp.select_next_item()
              -- Replace expand_or_jumpable() calls with expand_or_locally_jumpable(),
              -- that way you will only jump inside the snippet region (thefuck...)
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)          -- Select previous item
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
            { name = "buffer" },
            { name = "path" },
          })
        })



        --[[ Completion menu appearance ]]--
        local function format(_, item)

          local item_kinds = {
            Class = '',
            Color = '',
            Constant = '',
            Constructor = '',
            Enum = '',
            EnumMember = '',
            Event = '',
            Field = '',
            File = '',
            Folder = '',
            Function = '',
            Interface = '',
            Keyword = '',
            Method = '',
            Module = '',
            Operator = '',
            Property = '',
            Reference = '',
            Snippet = '',
            Struct = '',
            Text = '󰊄',
            TypeParameter = '',
            Unit = '',
            Value = '',
            Variable = '',

            Unknown = ' ',
          }
          item.kind = ' ' .. (item_kinds[item.kind] or item_kinds.Unknown) .. ' │'

          -- Remove gibberish.
          item.menu = nil
          return item
        end

        local formatting = {
          fields = { 'kind', 'abbr' },
          format = format,
        }

        local window = {
          completion = cmp.config.window.bordered {
            winhighlight = 'Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None',
            border = "none",
            scrollbar = false,
            col_offset = -1,
            side_padding = 0,
          },
          documentation = cmp.config.window.bordered {
            border = "none",
            winhighlight = 'Normal:Pmenu,FloatBorder:PmenuDocBorder,CursorLine:PmenuSel,Search:None',
            scrollbar = false,
            side_padding = 1, -- Not working?
          },
        }

        cmp.setup {
          formatting = formatting,
          window = window,
        }



        --[[ Integration with nvim-autopairs ]]--
        cmp.event:on(
          'confirm_done',
          require('nvim-autopairs.completion.cmp').on_confirm_done()
        )
      '';
    }
  ];
}

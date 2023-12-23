# INFO: Prettier notes

{ pkgs, ... }: {
    programs.neovim.plugins = with pkgs.vimPlugins; [
        {
            plugin = todo-comments-nvim;
            type = "lua";
            config = /* lua */ ''
                require("todo-comments").setup({
                    keywords = {
                        FIX     = { icon = " ", color = "error",   alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },  },
                        TODO    = { icon = " ", color = "info"                                                  },
                        HACK    = { icon = " ", color = "warning"                                               },
                        WARN    = { icon = " ", color = "warning", alt = { "WARNING", "XXX" }                   },
                        PERF    = { icon = " ",                    alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                        NOTE    = { icon = " ", color = "hint",    alt = { "INFO", "USAGE", "PURPOSE" }         },
                        TEST    = { icon = "󰙨 ", color = "test",    alt = { "TESTING", "PASSED", "FAILED" }      },
                    },
                    highlight = {
                        multiline = true, -- Enable multine todo comments
                        before = "",      -- "fg", "bg" or empty
                        keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty
                        after = "fg",     -- "fg", "bg" or empty
                    },
                })
            '';
        }
    ];
}

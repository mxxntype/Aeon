# INFO: Helix, a post-modern vim-like editor

{ config, pkgs, ... }: {
    imports = [
        ./theme.nix
    ];

    programs.helix = {
        enable = true;
        defaultEditor = true;

        settings = {
            theme = if config.theme.meta.override_helix then config.theme.meta.slug else "base16";
            editor = {
                # Common stuff
                idle-timeout = 0;
                completion-trigger-len = 1;
                file-picker.hidden = false;
                lsp.display-messages = true;
                indent-guides.render = true;
                soft-wrap.enable = true;

                color-modes = true;
                cursor-shape = {
                    normal = "block";
                    insert = "bar";
                    select = "underline";
                };

                statusline = {
                    left = [
                        "mode"
                        "spinner"
                        "version-control"
                    ];
                    center = [
                        "file-base-name"
                        "file-modification-indicator"
                    ];
                    right = [
                        "diagnostics"
                        "position"
                        "file-encoding"
                        # "file-line-ending"
                        "file-type"
                    ];

                    mode = {
                        normal = "NORMAL";
                        insert = "INSERT";
                        select = "SELECT";
                    };
                };
            };

            keys = {
                insert = {
                    "A-h" = "move_char_left";
                    "A-j" = "move_line_down";
                    "A-k" = "move_line_up";
                    "A-l" = "move_char_right";
                };
            };
        };

        languages.language = [
            {
                name = "rust";
                auto-format = true;
            }
            {
                name = "c";
                auto-format = true;
            }
            {
                name = "nix";
                indent = {
                    tab-width = 4;
                    unit = "    ";
                };
            }
        ];
    };

    home.packages = with pkgs; [
        rust-analyzer
        nil
    ];
}

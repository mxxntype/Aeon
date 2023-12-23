{ inputs, config, pkgs, ... }: let
    inherit (config.theme) colors;
    layoutDir = "${config.xdg.configHome}/zellij/layouts/";
    defaultTabTemplate = /* kdl */ ''
        default_tab_template {
            // Every other pane
            children

            // Custom statusbar
            pane size=1 borderless=true {
                plugin location="file:${inputs.zjstatus.packages.${pkgs.system}.default}/bin/zjstatus.wasm" {
                    format_left  "{mode}{tabs}"
                    format_right "{command_git_branch} #[fg=#${colors.teal},bold]{session}{datetime} #[fg=#${colors.crust},bg=#${colors.mauve},bold]   "
                    format_space ""

                    border_enabled  "false"
                    border_char     "─"
                    border_format   "#[fg=#${colors.surface2}]{char}"
                    border_position "top"

                    // `false` means follow core config,
                    // `true` will turn on frames when a second pane is opened
                    hide_frame_for_single_pane "false"

                    mode_normal  "#[fg=#${colors.crust},bg=#${colors.text},bold] NORMAL "
                    mode_locked  "#[fg=#${colors.crust},bg=#${colors.red},bold] LOCKED "
                    mode_resize  "#[fg=#${colors.crust},bg=#${colors.green},bold] RESIZE "
                    mode_pane    "#[fg=#${colors.crust},bg=#${colors.blue},bold]  PANE  "
                    mode_tab     "#[fg=#${colors.crust},bg=#${colors.yellow},bold]  TAB   "
                    mode_scroll  "#[fg=#${colors.crust},bg=#${colors.teal},bold] SCROLL "
                    mode_session "#[fg=#${colors.crust},bg=#${colors.maroon},bold] SESSION "
                    mode_move    "#[fg=#${colors.crust},bg=#${colors.mauve},bold]  MOVE  "
                    mode_tmux    "#[fg=#${colors.crust},bg=#${colors.green},bold]  TMUX  "

                    tab_active  " #[bg=#${colors.teal}] #[fg=#${colors.text},bg=#${colors.surface0},bold] {name} "
                    tab_normal  " #[bg=#${colors.subtext0}] #[fg=#${colors.subtext0},bg=#${colors.surface0}] {name} "

                    command_git_branch_command  "git rev-parse --abbrev-ref HEAD"
                    command_git_branch_format   "#[fg=red] {stdout} "
                    command_git_branch_interval  "10"

                    datetime          "#[fg=#${colors.mauve},bold] {format}"
                    datetime_format   "%A, %d %b %Y %H:%M"
                    datetime_timezone "Europe/Moscow"
                }
            }
        }
    '';
in {
    xdg.configFile = {
        "${layoutDir}/cli.kdl".text = /* kdl */ ''
            layout {
                ${defaultTabTemplate}
                tab name="Tab #1 | 󰊠 " focus=true {
                    pane
                }
                tab name="Tab #2 | 󰼁 " {
                    pane
                }
                tab name="Tab #3 | 󰚌 " {
                    pane
                }
            }
        '';
        
        "${layoutDir}/wyrm.kdl".text = /* kdl */ ''
            layout {
                ${defaultTabTemplate}
                tab name="󱆃 CLI [~]" cwd="~/" focus=true {
                    pane split_direction="vertical" {
                        pane
                        pane cwd="Aeon/"
                    }
                }

                tab name="󰍳 Subliminal | 󰡨 " cwd="~/Repos/Subliminal" {
                    pane split_direction="horizontal" {
                        pane split_direction="vertical" {
                            pane size="50%"
                            pane edit="./docker-compose.yml"
                        }
                        pane size="40%" {
                            command "docker"
                            args "compose" "logs" "--follow"
                        }
                    }
                }

                tab name="󱄅 System Monitor" cwd="/" {
                    pane split_direction="horizontal" {
                        pane size="70%" {
                            command "btm"
                            args "--battery"
                        }
                        pane
                    }
                }
            }
        '';

        "${layoutDir}/monocle.kdl".text = /* kdl */ ''
            layout {
                ${defaultTabTemplate}
                tab name="Monocle | 󰹻 " focus=true {
                    pane split_direction="horizontal" {
                        pane size="70%" edit="./"
                        pane
                    }
                }
            }
        '';
    };
}

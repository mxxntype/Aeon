{ config, ... }: let
    layoutDir = "${config.xdg.configHome}/zellij/layouts/";
in {
    xdg.configFile = {
        "${layoutDir}/wyrm.kdl".text = ''
            layout {
                default_tab_template {
                    children
                    pane size=1 borderless=true {
                        plugin location="zellij:compact-bar"
                    }
                }

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
    };
}
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.colorscheme) colors;
  fonts = {
    names = [ "JetBrainsMono Nerd Font" ];
    style = "SemiBold";
    size = 10.0;
  };
in {
  imports = [
    ../../common  # All common
    ../common     # Wayland common

    ./i3status.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;

    config = {
      gaps = {
        inner = 16;
      };

      window.titlebar = false;

      modifier = "Mod4";
      keybindings = let
        MOD = config.wayland.windowManager.sway.config.modifier;
        in lib.mkOptionDefault {
          "${MOD}+Return" = "exec ${pkgs.wezterm}/bin/wezterm start --always-new-process";
          "${MOD}+Shift+q" = "kill";
          "${MOD}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
      };

      colors = {
        focused = {
          background = "#${colors.base00}";
          border = "#${colors.base09}";
          childBorder = "#${colors.base09}";
          indicator = "#${colors.base08}";
          text = "#${colors.base05}";
        };

        unfocused = {
          background = "#${colors.base00}";
          border = "#${colors.base03}";
          childBorder = "#${colors.base03}";
          indicator = "#${colors.base03}";
          text = "#${colors.base05}";
        };

        urgent = {
          background = "#${colors.base00}";
          border = "#${colors.base0E}";
          childBorder = "#${colors.base0E}";
          indicator = "#${colors.base0C}";
          text = "#${colors.base05}";
        };
      };

      fonts = fonts;

      bars = [
        {
          position = "top";
          # TODO: statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs";
          statusCommand = "i3status"; # Configured in ./i3status.nix

          colors = {
            background = "#${colors.base00}";
            statusline = "#${colors.base05}";
            separator = "#${colors.base09}";

            focusedWorkspace = {
              background = "#${colors.base09}";
              border = "#${colors.base09}";
              text = "#${colors.base00}";
            };

            inactiveWorkspace = {
              background = "#${colors.base02}";
              border = "#${colors.base02}";
              text = "#${colors.base05}";
            };

            urgentWorkspace = {
              background = "#${colors.base0E}";
              border = "#${colors.base0E}";
              text = "#${colors.base00}";
            };

            bindingMode = {
              background = "#${colors.base08}";
              border = "#${colors.base08}";
              text = "#${colors.base00}";
            };
          };
          
          fonts = fonts;
        }
      ];
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.theme) colors;
  fonts = {
    names = [ "JetBrainsMono Nerd Font" ];
    style = "SemiBold";
    size = 10.0;
  };
in {
  imports = [
    ../../common  # Wayland & X11 common
    ../common     # Wayland common

    ../../x11/i3/i3status.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = lib.mkForce pkgs.swayfx;

    config = {


      # INFO: Gaps & Title bars
      gaps = {
        inner = 16;
      };

      window.titlebar = false;


      # INFO: Keybindings
      modifier = "Mod4";
      keybindings = let
        MOD = config.wayland.windowManager.sway.config.modifier;
        in lib.mkForce {
          "${MOD}+Return" = "exec ${pkgs.wezterm}/bin/wezterm start --always-new-process";
          "${MOD}+Shift+q" = "kill";
          "${MOD}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";

          # Shift focus
          "${MOD}+h" = "focus left";
          "${MOD}+j" = "focus down";
          "${MOD}+k" = "focus up";
          "${MOD}+l" = "focus right";

          # Move window
          "${MOD}+Shift+h" = "move left";
          "${MOD}+Shift+j" = "move down";
          "${MOD}+Shift+k" = "move up";
          "${MOD}+Shift+l" = "move right";

          # Workspaces
          "${MOD}+1" = "workspace number 1";
          "${MOD}+2" = "workspace number 2";
          "${MOD}+3" = "workspace number 3";
          "${MOD}+4" = "workspace number 4";
          "${MOD}+5" = "workspace number 5";
          "${MOD}+6" = "workspace number 6";
          "${MOD}+7" = "workspace number 7";
          "${MOD}+8" = "workspace number 8";
          "${MOD}+9" = "workspace number 9";
          "${MOD}+0" = "workspace number 10";

          "${MOD}+Shift+1" = "move container to workspace number 1";
          "${MOD}+Shift+2" = "move container to workspace number 2";
          "${MOD}+Shift+3" = "move container to workspace number 3";
          "${MOD}+Shift+4" = "move container to workspace number 4";
          "${MOD}+Shift+5" = "move container to workspace number 5";
          "${MOD}+Shift+6" = "move container to workspace number 6";
          "${MOD}+Shift+7" = "move container to workspace number 7";
          "${MOD}+Shift+8" = "move container to workspace number 8";
          "${MOD}+Shift+9" = "move container to workspace number 9";
          "${MOD}+Shift+0" = "move container to workspace number 10";

          # Toggle splitting
          "${MOD}+n" = "split horizontal";
          "${MOD}+v" = "split vertical";

          # Fullscreen & Floating
          "${MOD}+F" = "fullscreen toggle";
          "${MOD}+Shift+F" = "floating toggle";
          "${MOD}+Shift+Space" = "focus mode_toggle";

          # Modes
          "${MOD}+R" = "mode resize";

          # Reload & Exit
          "${MOD}++Shift+R" = "reload";
          "${MOD}+Ctrl+Shift+E" = "exit";
      };


      # INFO: Colors
      colors = {
        focused = {
          background = "#${colors.base}";
          border = "#${colors.yellow}";
          childBorder = "#${colors.yellow}";
          indicator = "#${colors.peach}";
          text = "#${colors.text}";
        };

        unfocused = {
          background = "#${colors.base}";
          border = "#${colors.surface1}";
          childBorder = "#${colors.surface1}";
          indicator = "#${colors.surface1}";
          text = "#${colors.text}";
        };

        urgent = {
          background = "#${colors.base}";
          border = "#${colors.mauve}";
          childBorder = "#${colors.mauve}";
          indicator = "#${colors.sky}";
          text = "#${colors.text}";
        };
      };


      # INFO:: Bar
      bars = [
        {
          position = "top";
          # TODO: statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs";
          statusCommand = "i3status"; # Configured in ./i3status.nix

          colors = {
            background = "#${colors.base}";
            statusline = "#${colors.text}";
            separator = "#${colors.yellow}";

            focusedWorkspace = {
              background = "#${colors.yellow}";
              border = "#${colors.yellow}";
              text = "#${colors.base}";
            };

            inactiveWorkspace = {
              background = "#${colors.surface0}";
              border = "#${colors.surface0}";
              text = "#${colors.text}";
            };

            urgentWorkspace = {
              background = "#${colors.mauve}";
              border = "#${colors.mauve}";
              text = "#${colors.base}";
            };

            bindingMode = {
              background = "#${colors.peach}";
              border = "#${colors.peach}";
              text = "#${colors.base}";
            };
          };
          
          fonts = fonts;
        }
      ];

      fonts = fonts;
    };
  };
}

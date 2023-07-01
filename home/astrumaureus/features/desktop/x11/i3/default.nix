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
    ../../common  # X11 & Wayland commons
    ../common/picom
  ];

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      startup = [
        { # Adjust display
          # TODO: Dynamic outputs
          command = "${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --gamma 0.7";
        }
        { # Start compositor
          command = "picom";
        }
      ];

      # INFO: Gaps & Title bars
      gaps = {
        inner = 16;
      };

      window.titlebar = false;


      # INFO: Keybindings
      modifier = "Mod4";
      keybindings = let
        MOD = config.xsession.windowManager.i3.config.modifier;
        in lib.mkForce {
          # TODO: Automatically detect (somehow) if `nvidia-offload` is needed/available
          "${MOD}+Return" = "exec nvidia-offload wezterm start --always-new-process";
          "${MOD}+Shift+q" = "kill";
          "${MOD}+d" = "exec dmenu_run";

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

          # TODO: nvidia-offload
          "${MOD}+Ctrl+Shift+3" = "exec nvidia-offload librewolf";

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

      assigns = {
        "1" =   [];
        "2" =   [];
        "3" =   [
          {
            class = "^librewolf$";
          }
        ];
        "4" =   [];
        "5" =   [];
        "6" =   [];
        "7" =   [];
        "8" =   [];
        "9" =   [];
        "10" =  [];
      };


      # INFO: Colors
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


      # INFO:: Bar
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

      fonts = fonts;
    };
  };

  home.packages = with pkgs; [
    i3status
    dmenu
  ];

  home.file.".xinitrc" = {
    text = ''
      #!/bin/sh

      userresources=$HOME/.Xresources
      usermodmap=$HOME/.Xmodmap
      sysresources=/nix/store/i6fwdq3wf24ad5f0hd841nss1qfmh8il-xinit-1.4.1/etc/X11/xinit/.Xresources
      sysmodmap=/nix/store/i6fwdq3wf24ad5f0hd841nss1qfmh8il-xinit-1.4.1/etc/X11/xinit/.Xmodmap

      # merge in defaults and keymaps

      if [ -f $sysresources ]; then
          xrdb -merge $sysresources
      fi

      if [ -f $sysmodmap ]; then
          xmodmap $sysmodmap
      fi

      if [ -f "$userresources" ]; then
          xrdb -merge "$userresources"
      fi

      if [ -f "$usermodmap" ]; then
          xmodmap "$usermodmap"
      fi

      # start some nice programs

      if [ -d /nix/store/i6fwdq3wf24ad5f0hd841nss1qfmh8il-xinit-1.4.1/etc/X11/xinit/xinitrc.d ] ; then
       for f in /nix/store/i6fwdq3wf24ad5f0hd841nss1qfmh8il-xinit-1.4.1/etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
       done
       unset f
      fi

      exec i3
    '';
    executable = true;
  };
}

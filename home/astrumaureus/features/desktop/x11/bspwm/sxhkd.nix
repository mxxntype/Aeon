{
  pkgs,
  ...
}: let
  offloadCommand = "nvidia-offload";
  startTerminal = "${offloadCommand} wezterm start --always-new-process";
  disposableTerminalSize = "800x600";
  startDisposableTerminal = "bspc rule -a org.wezfurlong.wezterm -o state=floating follow=on center=true rectangle=${disposableTerminalSize}+0+0 && ${startTerminal}";
in {
  services.sxhkd = {
    enable = true;
    keybindings = {
      # --[[ Basic commands ]]--
        # Kill | Force kill current window
        "super + shift + q" = "bspc node -c";
        "super + ctrl + shift + q" = "bspc node -k";

        # Lock screen
        "super + ctrl + shift + l" = "${pkgs.betterlockscreen}/bin/betterlockscreen -l";

        # Force exit BSPWM
        "super + ctrl + shift + e" = "bspc quit";
      

      # --[[ WM navigation ]]--
        # Change window focus | Move window
        "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
        "super + shift + {h,j,k,l}" = "bspc node -s {west,south,north,east}";

        # Change workspace | Move window to workspace
        "super + {1-9,0}" = "bspc desktop -f {1-9,10}";
        "super + shift + {1-9,0}" = "bspc node -d {1-9,10}";

        # Toggle floating | Toggle fullscreen
        "super + t" = "bspc node -t ~floating";
        "super + f" = "bspc node -t ~fullscreen";


      # --[[ Apps ]]--
        # Open terminal | Open floating terminal
        "super + Return" = "${startTerminal}";
        "super + shift + Return" = "${startDisposableTerminal}";

        # Common terminal utilities
        # TODO: "super + e" = "nvidia-offload wezterm start <file-manager>"
        "super + m" = "${startDisposableTerminal} alsamixer";
        "super + p" = "${startDisposableTerminal} btm --battery";

        # Application launcher
        "super + d" = "nvidia-offload dmenu_run";

        # Workspace-specific apps
        "ctrl + shift + 1" = "${startTerminal}";
        "ctrl + shift + 2" = "nvidia-offload gimp";
        "ctrl + shift + 3" = "nvidia-offload librewolf";
        "ctrl + shift + 4" = "nvidia-offload kotatogram-desktop";
        "ctrl + shift + 5" = "nvidia-offload libreoffice";
        "ctrl + shift + 6" = "virt-manager";
        "ctrl + shift + 7" = "nvidia-offload prismlauncher";
        "ctrl + shift + 8" = "keepassxc";
        "ctrl + shift + 9" = "nvidia-offload freetube";
        # TODO: "ctrl + shift + o" = "nvidia-offload wezterm start <music-player>";

      # --[[ Hardware control ]]--
        # Brightness
        "XF86MonBrightnessUp" = "brillo -A 10 -u 500";
        "XF86MonBrightnessDown" = "brillo -U 10 -u 500";

        # Sound
        "XF86AudioMute" = "amixer -q set Master toggle";
        "XF86AudioRaiseVolume" = "amixer -q set Master 10%+ unmute";
        "XF86AudioLowerVolume" = "amixer -q set Master 10%- unmute";
    };
  };
}

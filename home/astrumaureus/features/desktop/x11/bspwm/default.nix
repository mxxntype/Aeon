{
  inputs,
  pkgs,
  config,
  ...
}: let
  offloadCommand = "smart-offload";
  inherit (config.colorscheme) colors;
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) nixWallpaperFromScheme;
in {
  imports = [
    ../../common  # X11 & Wayland commons
    ../common     # X11 commons

    ../common/picom/arian8j2.nix
    ../common/polybar
    ./sxhkd.nix
  ];

  xsession.windowManager.bspwm = {
    enable = true;
    startupPrograms = let
      wallpaper = nixWallpaperFromScheme {
        scheme = config.colorscheme;
        width = 1920;
        height = 1080;
        logoScale = 5.0;
      }; in [
      "xrandr --output eDP-1 --gamma 0.7"
      "${offloadCommand} picom"
      "${offloadCommand} feh ${wallpaper} --bg-scale"
      "bspc monitor -d 1 2 3 4 5 6 7 8 9"

      "bspc config window_gap 12"
      "bspc config border_width 2"
      "bspc config normal_border_color '#${colors.base03}'"
      "bspc config active_border_color '#${colors.base03}'"
      "bspc config focused_border_color '#${colors.base0E}'"

      "pkill polybar; sleep 0.2 && ${offloadCommand} polybar"
    ];
  };

  home.packages = with pkgs; [
    dmenu     # Application launcher
  ];

  home.file.".xinitrc" = {
    text = ''
      #!/bin/sh

      export SXHKD_SHELL="/bin/sh"

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

      sxhkd &
      exec ${offloadCommand} bspwm
    '';
    executable = true;
  };
}

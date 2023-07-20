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
      sxhkd &
      exec ${offloadCommand} bspwm
    '';
    executable = true;
  };
}

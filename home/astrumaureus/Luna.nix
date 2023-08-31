# INFO: astrumaureus@Luna configuration

{
  ...
}: {
  imports = [
    ./global

    # X11 Window managers | DEs
    # WARNING: Only one can be enabled at a time
    # ./features/desktop/x11/i3
    # ./features/desktop/x11/xmonad
    # ./features/desktop/x11/bspwm
    # ./features/desktop/x11/awesome

    # Wayland compositors
    # ./features/desktop/wayland/swayfx
    ./features/desktop/wayland/hyprland

    # Userspace apps
    ./features/apps/freetube.nix
    ./features/apps/gimp.nix
    ./features/apps/keepassxc.nix
    ./features/apps/libreoffice.nix
    ./features/apps/librewolf.nix
    ./features/apps/obsidian.nix
    ./features/apps/surroundings.nix
    ./features/apps/telegram
    ./features/apps/upscayl.nix
    ./features/apps/rocketchat.nix

    # Features
    ./features/music

    # Games
    ./features/games/minecraft
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  monitors = [
    {
      name = "eDP-1";
      width = 2880;
      height = 1800;
      refreshRate = 120;
      gamma = 1.0;
      scale = 1.5;
      showBar = true;
      x = 0;
      y = 0;
      workspace = "1";
      enable = true;
    }
  ];
}

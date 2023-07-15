# INFO: astrumaureus@Nox configuration

{
  ...
}: {
  imports = [
    ./global

    # Window managers | DEs
    # ./features/desktop/wayland/swayfx
    # ./features/desktop/x11/i3
    # ./features/desktop/x11/xmonad
    ./features/desktop/x11/bspwm

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
    ./features/apps/wezterm

    # Features
    ./features/music

    # Games
    ./features/games/minecraft
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}

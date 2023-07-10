# INFO: astrumaureus@Nox configuration

{
  ...
}: {
  imports = [
    ./global

    # ./features/desktop/wayland/swayfx
    # ./features/desktop/x11/i3
    # ./features/desktop/x11/xmonad
    ./features/desktop/x11/bspwm

    ./features/apps/freetube
    ./features/apps/gimp
    ./features/apps/keepassxc
    ./features/apps/libreoffice
    ./features/apps/librewolf
    ./features/apps/obsidian
    ./features/apps/telegram/kotatogram
    ./features/apps/upscayl
    ./features/apps/wezterm

    ./features/music

    ./features/games/minecraft
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}

# INFO: astrumaureus@Nox configuration

{
  ...
}: {
  imports = [
    ./global

    # ./features/desktop/wayland/swayfx
    ./features/desktop/x11/i3

    ./features/apps/wezterm
    ./features/apps/librewolf
    ./features/apps/obsidian
    ./features/apps/telegram/kotatogram
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}

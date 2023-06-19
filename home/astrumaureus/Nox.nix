# INFO: astrumaureus@Nox configuration

{
  ...
}: {
  imports = [
    ./global

    ./features/desktop/hyprland

    ./features/apps/kitty
    ./features/apps/wezterm
    ./features/apps/obsidian
    ./features/apps/telegram/kotatogram
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}

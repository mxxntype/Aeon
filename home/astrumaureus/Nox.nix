# INFO: astrumaureus@Nox configuration

_: let
  state = builtins.fromTOML (
    builtins.readFile ../../hosts/Luna/state.toml
  );
in {
  imports = [
    ./global

    # Window managers | DEs
    # ./features/desktop/wayland/swayfx
    # ./features/desktop/x11/i3
    # ./features/desktop/x11/xmonad
    # ./features/desktop/x11/bspwm

    ./features/desktop/wayland/hyprland

    # Userspace apps
    ./features/apps
    ./features/apps/obsidian.nix

    # Features
    ./features/music

    # Games
    ./features/games/minecraft
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      gamma = 0.6;
      showBar = true;
      x = 0;
      y = 0;
      workspace = "1";
      enable = true;
    }
  ];

  # Set the userspace theme
  theme = builtins.fromTOML (
    builtins.readFile ../../shared/themes/${state.theme}.toml
  );
}

# INFO: astrumaureus@Luna configuration

{ inputs, config, ... }: let
  state = builtins.fromTOML (
    builtins.readFile ../../hosts/Luna/state.toml
  );
in {
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

    # Userspace
    ./features/apps
    ./features/apps/obsidian.nix
    ./features/music
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

  # Set the theme & store it in ~/.config in different formats
  theme = builtins.fromTOML (
    builtins.readFile ../../shared/themes/${state.theme}.toml
  );
  xdg.configFile = {
    "theme.toml".text = inputs.nix-std.lib.serde.toTOML config.theme;
    "theme.json".text = builtins.toJSON config.theme;
  };
}

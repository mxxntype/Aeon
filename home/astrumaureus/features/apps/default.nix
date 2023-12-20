{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Main
    librewolf
    libreoffice

    # Communications
    telegram-desktop
    session-desktop
    rocketchat-desktop
    revolt-desktop
    signal-desktop

    # Media
    inkscape
    upscayl
    freetube
    oculante

    # Password management
    keepassxc

    # Surroundings
    organicmaps
    gnome.gnome-weather
  ];

  imports = [
    ./obsidian.nix
  ];
}

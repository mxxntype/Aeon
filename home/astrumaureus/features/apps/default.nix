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
    signal-desktop-beta

    # Media
    inkscape
    upscayl
    freetube

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

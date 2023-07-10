{
  pkgs,
  ...
}: {
  imports = [
    ./picom
    ./wmutils
  ];

  home.packages = with pkgs; [
    scrot
    feh
    betterlockscreen
  ];
}

{
  pkgs,
  ...
}: {
  imports = [
    ./wmutils
  ];

  home.packages = with pkgs; [
    scrot
    feh
    betterlockscreen
  ];
}

{
  pkgs,
  ...
}: {
  imports = [
    ./wmutils
  ];

  home.packages = with pkgs; [
    scrot
    xclip
    feh
    betterlockscreen
  ];
}

{
  pkgs,
  ...
}: {
  imports = [
    ./wmutils
    ./eww
  ];

  home.packages = with pkgs; [
    scrot
    xclip
    feh
    betterlockscreen
  ];
}

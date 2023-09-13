{
  pkgs,
  ...
}: {
  imports = [
    ./gtk
    ./eww
  ];

  home.packages = with pkgs; [
    xdg-utils
  ];
}

{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    wlsunset
    swww
    eww-wayland
  ];
}

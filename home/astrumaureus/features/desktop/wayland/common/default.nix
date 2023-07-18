# INFO: Wayland commons

{
  pkgs,
  ...
}: {
  imports = [
    ./eww
  ];

  home.packages = with pkgs; [
    wlsunset
    swww
    wl-clipboard
  ];
}

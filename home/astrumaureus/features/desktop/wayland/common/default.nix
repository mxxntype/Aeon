# INFO: Wayland commons

{
  pkgs,
  ...
}: {
  imports = [
    ./eww
  ];

  home.packages = with pkgs; [
    wl-clipboard
    wlr-randr
    wlsunset
    swww
    grim
    slurp
  ];
}

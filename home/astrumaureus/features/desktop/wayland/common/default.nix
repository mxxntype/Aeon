# INFO: Wayland commons

{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
    wlr-randr
    wlsunset
    swww
    grim
    slurp
    gtklock
  ];
}

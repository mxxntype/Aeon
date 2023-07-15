# INFO: Maps & Weather

{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    organicmaps
    gnome.gnome-weather
  ];
}

# INFO: Elkowar's wacky widgets

{
  pkgs,
  ...
}: {
  imports = [
    ./statusbar
    ./powermenu
  ];

  home.packages = with pkgs; [
    eww-wayland
  ];

  xdg.configFile."eww/eww.yuck".text = ''
    (include "./statusbar/statusbar.yuck")
    (include "./powermenu/powermenu.yuck")
  '';
  xdg.configFile."eww/eww.scss".text = ''
    @use './statusbar/statusbar';
    @use './powermenu/powermenu';

    * {
      all: unset;
    }
  '';
}

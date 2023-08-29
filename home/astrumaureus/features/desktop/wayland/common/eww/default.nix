# INFO: Elkowar's wacky widgets

{
  pkgs,
  ...
}: {
  imports = [
    ./statusbar.nix
  ];

  home.packages = with pkgs; [
    eww-wayland
  ];

  xdg.configFile."eww/eww.yuck".text = ''
    (include "./statusbar/statusbar.yuck")
  '';
  xdg.configFile."eww/eww.scss".text = ''
    @use './statusbar/statusbar';
  '';
}

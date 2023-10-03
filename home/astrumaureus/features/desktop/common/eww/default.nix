# INFO: Elkowar's wacky widgets

{
  pkgs,
  ...
}: {
  imports = [
    ./statusbar
    ./powermenu
    ./command-prompt.nix
  ];

  home.packages = with pkgs; [
    eww-wayland
  ];

  # TODO: Automatically via `lib.forEach builtins.attrvalues`
  xdg.configFile."eww/eww.yuck".text = ''
    (include "./statusbar/statusbar.yuck")
    (include "./powermenu/powermenu.yuck")
    (include "./command-prompt.yuck")
  '';
  xdg.configFile."eww/eww.scss".text = ''
    @use './statusbar/statusbar';
    @use './powermenu/powermenu';

    * {
      all: unset;
    }
  '';
}

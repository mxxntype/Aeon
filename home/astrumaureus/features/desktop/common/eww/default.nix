# INFO: Elkowar's wacky widgets configuration

{ inputs, config, lib, pkgs, ... }: let
  shared = import ./shared.nix { inherit inputs config lib pkgs; };
in {
  imports = [
    ./statusbar-bottom
    ./powermenu
    ./command-prompt.nix
  ];

  home.packages = with pkgs; [
    eww-wayland
  ];

  xdg.configFile = {
    "eww/eww.yuck".text = /* yuck */ ''
      (include "./powermenu/powermenu.yuck")
      (include "./command-prompt.yuck")
      (include "./${shared.widgets.statusbars.bottom.moduleName}.yuck")
    '';

    "eww/eww.scss".text = /* scss */ ''
      @use './powermenu/powermenu';
      @use './${shared.widgets.statusbars.bottom.subModules.workspaces.moduleName}';
      @use './${shared.widgets.statusbars.bottom.subModules.battery.moduleName}';

      * {
        all: unset;
        font-family: BigBlueTermPlus Nerd Font;
        font-size: 16px;
      }
    '';
  };
}

# INFO: Elkowar's wacky widgets configuration

{ inputs, config, lib, pkgs, ... }: let
  shared = import ./shared.nix { inherit inputs config lib pkgs; };
in {
  imports = [
    ./statusbar
    ./statusbar-bottom
    ./powermenu
    ./command-prompt.nix
  ];

  home.packages = with pkgs; [
    eww-wayland
  ];

  xdg.configFile = {
    # TODO: Automatically via `lib.forEach builtins.attrValues`
    "eww/eww.yuck".text = ''
      (include "./statusbar/statusbar.yuck")
      (include "./powermenu/powermenu.yuck")
      (include "./command-prompt.yuck")
      (include "./${shared.widgets.statusbars.bottom.moduleName}.yuck")
    '';

    "eww/eww.scss".text = ''
      @use './statusbar/statusbar';
      @use './powermenu/powermenu';
      @use './${shared.widgets.statusbars.bottom.subModules.workspaces.moduleName}';
      @use './${shared.widgets.statusbars.bottom.subModules.battery.moduleName}';

      * {
        all: unset;
      }
    '';
  };
}

# INFO: Hyprland, the smooth wayland compositor

{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default

    ../common
    ../../common

    ./config.nix
  ];

  home.packages = [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprquery.defaultPackage.${pkgs.system}
    pkgs.hyprpicker
  ];
  
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # nvidiaPatches = true; # TODO: Set to `config.hardware.nvidia.something`...

    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.borders-plus-plus # WARN: Does not compile
      inputs.hyprland-hy3.packages.${pkgs.system}.hy3
    ];
  };

  wm-config = {
    border.thickness = 0;
    gaps = {
      inner = 12;
      outer = 24;
    };
    rounding = 0;
  };
}

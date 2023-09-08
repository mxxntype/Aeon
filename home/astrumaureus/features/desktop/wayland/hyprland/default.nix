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
  
  wayland.windowManager.hyprland = {
    enable = true;
    # nvidiaPatches = true; # TODO: Set to `config.hardware.nvidia.something`...
    xwayland = {
      enable = true;
    };

    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.borders-plus-plus # WARN: Does not compile
      inputs.hyprland-hy3.packages.${pkgs.system}.hy3
    ];
  };

  wm-config = {
    border.thickness = 2;
    gaps = {
      inner = 4;
      outer = 32;
    };
    rounding = 6;
  };
}

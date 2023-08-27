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
      # inputs.hyprland-plugins.packages.${pkgs.system}.borders-plus-plus
      inputs.hyprland-hy3.packages.${pkgs.system}.hy3
    ];
  };
}

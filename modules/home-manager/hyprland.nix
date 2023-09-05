{
  lib,
  ...
}: {
  options.wayland.windowManager.hyprland = {
    configParts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };
}

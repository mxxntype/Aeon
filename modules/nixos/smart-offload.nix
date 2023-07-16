{
  config,
  lib,
  pkgs,
  ...
}: let 
  cfg = config.hardware.nvidia;
in {
  options.hardware.nvidia.enableSmartOffloadCmd = lib.mkEnableOption "Smart Offload Cmd";

  config = lib.mkIf cfg.enableSmartOffloadCmd (lib.mkMerge [

    # PRIME is enabled, so `smart-offload` should basically be an alias for `nvidia-offload`
    (lib.mkIf (config.hardware.nvidia.prime.offload.enable) {
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "smart-offload" ''
          exec nvidia-offload $@
        '')
      ];
      # Make sure `nvidia-offload` is available
      hardware.nvidia.prime.offload.enableOffloadCmd = true;
    })

    # PRIME is disabled, so `smart-offload` should do nothing at all
    (lib.mkIf (!(config.hardware.nvidia.prime.offload.enable)) {
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "smart-offload" ''
          exec $@
        '')
      ];
    })
  ]);
}

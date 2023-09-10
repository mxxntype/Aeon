/* INFO: Host configuration: Luna (Zenbook 14X) */

{
  pkgs,
  lib,
  ...
}: {
  # List of features that form the host configuration
  imports = [

    # Users that should be present on the system
    ../common/users/astrumaureus

    # Optinonal system-level modules
    ../common/features/boot/quiet-boot.nix
    ../common/features/power/drain.nix
    ../common/features/sound/pipewire
    ../common/features/gvfs.nix

    # Services
    ../common/features/auto-cpufreq.nix
    ../common/features/services/syncthing
    ../common/features/services/qemu
    ../common/features/services/flatpak.nix
    ../common/features/services/bluetooth.nix
    ../common/features/services/adb.nix

    # Other features
    ../common/features/langs/c
    ../common/features/langs/rust
    ../common/features/langs/py.nix

    # WARN: Vital stuff
    ../common/global
    ../common/users/root
    ../common/users/astrumaureus/autologin.nix
    ./fstab.nix
    ./hardware.nix

  ];

  networking.hostName = "Luna";
  system.stateVersion = "23.05";

  virtualisation.waydroid.enable = true;
}

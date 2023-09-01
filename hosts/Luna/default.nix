/* INFO: Host configuration: Luna (Zenbook 14X) */

{
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
    # ../common/features/x11.nix

    # Services
    ../common/features/auto-cpufreq.nix
    ../common/features/services/syncthing
    ../common/features/services/qemu
    # ../common/features/services/vmware.nix
    ../common/features/services/flatpak.nix

    # Other features
    ../common/features/langs/c
    ../common/features/langs/rust

    # WARN: Vital stuff
    ../common/global
    ../common/users/root
    ./fstab.nix
    ./hardware.nix

  ];

  networking.hostName = "Luna";
  system.stateVersion = "23.05";
}
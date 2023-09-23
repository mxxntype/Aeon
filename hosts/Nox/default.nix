/* INFO: Host configuration: Nox (Dell i7559) */

{
  inputs,
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
    ../common/features/x11.nix

    # Services
    ../common/features/services/syncthing
    ../common/features/services/qemu

    # Devtools
    ../common/features/devtools

    # WARN: Vital stuff
    ../common/global
    ../common/users/root
    ./fstab.nix
    ./hardware.nix

    # inputs.hardware.nixosModules.common-gpu-nvidia-disable

  ];

  networking.hostName = "Nox";
  system.stateVersion = "22.11";
}

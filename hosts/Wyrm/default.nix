/* INFO: Host configuration: Wyrm (Desktop PC) */

{
  ...
}: {
  # List of features that form the host configuration
  imports = [

    # Users that should be present on the system
    ../common/users/astrumaureus

    # Optinonal system-level modules
    ../common/features/boot/quiet-boot.nix
    ../common/features/sound/pipewire
    # ../common/features/x11.nix

    # Services
    ../common/features/services/syncthing
    ../common/features/services/qemu
    ../common/features/services/docker.nix
    ../common/features/services/flatpak.nix
    ../common/features/services/moonlight.nix

    # Devtools
    ../common/features/devtools

    # WARN: Vital stuff
    ../common/global
    ../common/users/root
    ./fstab.nix
    ./hardware.nix

  ];

  networking.hostName = "Wyrm";
  system.stateVersion = "23.05";

  services.tailscale.enable = true;
}

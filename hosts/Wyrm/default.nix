/* INFO: Host configuration: Wyrm (Desktop PC) */

_: let
  state = builtins.fromTOML (
    builtins.readFile ./state.toml
  );
in {
  # List of features that form the host configuration
  imports = [
    # Users that should be present on the system
    ../common/users/astrumaureus

    # Optinonal system-level modules
    ../common/features/boot/quiet-boot.nix
    ../common/features/sound/pipewire.nix

    # Services
    ../common/features/services/syncthing
    ../common/features/services/qemu
    ../common/features/services/docker.nix
    ../common/features/services/flatpak.nix
    ../common/features/services/moonlight.nix
    ../common/features/services/minecraft/default.nix

    # Devtools
    ../common/features/devtools

    # WARN: Vital stuff
    ../common/global.nix
    ../common/users/root.nix
    ./fstab.nix
    ./hardware.nix
  ];

  networking.hostName = "Wyrm";
  system.stateVersion = "23.05";
  services.tailscale.enable = true;

  theme = builtins.fromTOML (
    builtins.readFile ../../shared/themes/${state.theme}.toml
  );
}

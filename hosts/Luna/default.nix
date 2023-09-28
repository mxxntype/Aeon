/* INFO: Host configuration: Luna (Zenbook 14X) */

{
  ...
}: {
  imports = [
    # Users that should be present on the system
    ../common/users/astrumaureus

    # Services
    ../common/features/auto-cpufreq.nix
    ../common/features/services/syncthing
    ../common/features/services/qemu
    ../common/features/services/flatpak.nix
    ../common/features/services/bluetooth.nix
    ../common/features/services/adb.nix

    # DB's
    ../common/features/db/postgres.nix

    # Devtools
    ../common/features/devtools

    # Optinonal system-level modules
    ../common/features/boot/quiet-boot.nix
    ../common/features/power/drain.nix
    ../common/features/sound/pipewire
    ../common/features/gamemode.nix
    ../common/features/services/cups.nix
    ../common/features/gpg.nix

    # NOTE: Vital
    ../common/global
    ../common/users/root
    ../common/users/astrumaureus/autologin.nix
    ./fstab.nix
    ./hardware.nix

  ];

  networking.hostName = "Luna";
  system.stateVersion = "23.05";

  # services.logmein-hamachi.enable = true;

  virtualisation = {
    waydroid.enable = true;
    # docker.enable = true;
  };
}

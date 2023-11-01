/* INFO: Host configuration: Luna (Zenbook 14X) */

{ pkgs, ... }: {
  imports = [
    # Users that should be present on the system
    ../common/users/astrumaureus

    # Services
    ../common/features/auto-cpufreq.nix
    ../common/features/services/syncthing
    ../common/features/services/qemu
    ../common/features/services/docker.nix
    ../common/features/services/flatpak.nix
    ../common/features/services/bluetooth.nix
    ../common/features/services/adb.nix
    ../common/features/services/moonlight.nix

    # DB's
    ../common/features/db/postgres.nix

    # Servers
    ../common/features/servers/searxng.nix

    # Devtools
    ../common/features/devtools
    ../common/features/devtools/qt.nix

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

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "appimage-thai-run" ''
      LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.libthai}/lib/ ${pkgs.appimage-run}/bin/appimage-run $@
    '')
  ];

  networking.hostName = "Luna";
  system.stateVersion = "23.05";

  services.tailscale.enable = true;
}

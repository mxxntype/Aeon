/* INFO: Host configuration: Nox (Dell i7559) */

{
  ...
}: {
  # NOTE: List of modules that form the host configuration
  imports = [

    # Users that should be present on the system
    ../common/users/astrumaureus


    # Optinonal system-level modules
    ../common/features/boot/quiet-boot.nix

    ../common/features/sound/pipewire


    # Other features
    ../common/features/langs/c
    ../common/features/langs/rust


    # WARN: Vital stuff
    ../common/global
    ../common/users/root
    ./fstab.nix
    ./hardware.nix

  ];

  # TODO: Move to features & import above
  programs = {
    dconf.enable = true;
  };

  networking.hostName = "Nox";
  system.stateVersion = "22.11";
}

/* INFO: Host configuration: Nox (Dell i7559) */

{
  ...
}: {
  # NOTE: List of modules that form the host configuration
  imports = [

    # Users that should be present on the system
    ../common/users/astrumaureus


    # Optional sys-level modules
    ../common/optional/fde.nix
    ../common/optional/quiet-boot.nix


    # Other features
    ../common/optional/langs/c
    ../common/optional/langs/rust


    # WARN: Vital stuff
    ../common/global
    ../common/users/root
    ./fstab.nix
    ./hardware.nix

  ];

  # TODO: Move to optional & import above
  programs = {
    dconf.enable = true;
  };

  networking.hostName = "Nox";
  system.stateVersion = "22.11";
}

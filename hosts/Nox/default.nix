{
  ...
}: {
  imports = [
    ../common/global

    ../common/users/root
    ../common/users/astrumaureus

    ../common/optional/fde.nix
    ../common/optional/quiet-boot.nix

    ../common/optional/langs/c
    ../common/optional/langs/rust

    ./fstab.nix
    ./hardware.nix
  ];

  programs = {
    dconf.enable = true;
  };

  networking.hostName = "Nox";
  system.stateVersion = "22.11";
}

# INFO: Lanzaboote, UEFI secure boot for NixOS

{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # Lanzaboote currently replaces the systemd-boot module. So force it to false for now
    loader.systemd-boot.enable = lib.mkForce false;
    loader.grub.enable = lib.mkForce false;

    bootspec.enable = true; # It's not required anymore, but also doesn't do any harm
  };

  environment.systemPackages = with pkgs; [
    sbctl
  ];
}

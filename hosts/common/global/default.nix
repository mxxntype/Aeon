# INFO: Default, imports other files.
# Some common and/or unsorted settings

{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [

    ../features/boot
    ../features/environment.nix
    ../features/locale.nix
    ../features/dconf.nix
    ../features/network.nix
    ../features/nix.nix
    ../features/sops.nix
    ../features/ssh.nix
    ../features/zen-kernel.nix

    ../features/services/dnscrypt-proxy
    ../features/services/xdg-portal.nix

    inputs.home-manager.nixosModules.home-manager
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager.extraSpecialArgs = { 
    inherit inputs outputs;
  };

  nixpkgs = {
    # overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  security.pam.services.gtklock = {};

  environment = {
    enableAllTerminfo = true;
    systemPackages = with pkgs; [
      bottom
      exa
      file
      htop
      pciutils
      ripgrep
      sops
      usbutils
      wget
    ];

  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    corefonts
  ];

  hardware.enableRedistributableFirmware = true;
}

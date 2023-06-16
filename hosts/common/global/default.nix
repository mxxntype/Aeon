# INFO: Default, imports other files.
# Some common and/or unsorted settings

{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./boot.nix
    ./environment.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./sops.nix
    ./ssh.nix
  ]; # ++ (builtins.attrValues outputs.nixosModules);

  home-manager.extraSpecialArgs = { 
    inherit inputs outputs;
  };

  nixpkgs = {
    # overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };


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

  # TODO: Move to userspace
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  hardware.enableRedistributableFirmware = true;
}

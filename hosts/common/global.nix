{ inputs, outputs, pkgs, ... }: {
  imports = [
    ../common/features/boot
    ../common/features/environment.nix
    ../common/features/locale.nix
    ../common/features/network.nix
    ../common/features/nix.nix
    ../common/features/sops.nix
    ../common/features/ssh.nix
    ../common/features/console.nix
    ../common/features/zen-kernel.nix
    ../common/features/services/dnscrypt-proxy
    ../common/features/services/xdg-portal.nix
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
      file
      pciutils
      usbutils
      wget
      jmtpfs
      libnotify
    ];
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "BigBlueTerminal"
        "Gohu"
        "Iosevka"
        "IosevkaTerm"
      ];
    })
    corefonts
  ];

  programs = {
    traceroute.enable = true;
    dconf.enable = true;
  };

  services = {
    gvfs.enable = true;
    logind = {
      killUserProcesses = true;
      powerKey = "suspend";
    };
  };

  hardware.enableRedistributableFirmware = true;
}

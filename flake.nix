{
  description = "Aeon | NixOS Flake ⚜️";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Sops-nix: atomic secret provisioning for NixOS
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lanzaboote, UEFI secure boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland, the smooth wayland compositor
    hyprland.url = "github:hyprwm/Hyprland";

    # Nix-colors, the Nix way around ricing
    nix-colors.url = "github:misterio77/nix-colors";

    # Stable & nightly Rust
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: 
  let
    inherit (self) outputs;

    # Declares a NixOS host
    mkNixOS = modules: nixpkgs.lib.nixosSystem {
      inherit modules;
      specialArgs = { inherit inputs outputs; };
    };

    # Declares a user@host
    mkHome = modules: pkgs: home-manager.lib.homeManagerConfiguration {
      inherit modules pkgs;
      extraSpecialArgs = { inherit inputs outputs; };
    };
  in {
    # Available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      # Dell i7559
      Nox = mkNixOS [ ./hosts/Nox ];
    };

    # Available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "astrumaureus@Nox" = mkHome [ ./home/astrumaureus/Nox.nix ] nixpkgs.legacyPackages."x86_64-linux" ;
    };
  };
}

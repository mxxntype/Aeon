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

    # Hyprland, the smooth wayland compositor
    hyprland.url = "github:hyprwm/Hyprland";

    # Nix-colors, the Nix way around ricing
    nix-colors.url = "github:misterio77/nix-colors";

    # Stable & nightly Rust
    rust-overlay.url = "github:oxalica/rust-overlay";

    # # Lanzaboote, UEFI secure boot for NixOS
    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: 
  let
    inherit (self) outputs;
    # lib = nixpkgs.lib // home-manager.lib;
    # systems = [ "x86_64-linux" ];
    # forEachSystem = f: lib.genAttrs systems (sys: f nixpkgs.legacyPackages.${sys});

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
    # inherit lib;
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs; });

    # Available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      Nox = mkNixOS [ ./hosts/Nox ];    # Dell i7559
      Wyrm = mkNixOS [ ./hosts/Wyrm ];  # Desktop
    };

    # Available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      "astrumaureus@Nox" = mkHome [ ./home/astrumaureus/Nox.nix ] nixpkgs.legacyPackages."x86_64-linux";
      "astrumaureus@Wyrm" = mkHome [ ./home/astrumaureus/Wyrm.nix ] nixpkgs.legacyPackages."x86_64-linux";
    };
  };
}

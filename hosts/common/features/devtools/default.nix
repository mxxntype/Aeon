{ pkgs, ... }: {
  imports = [
    ./c.nix
    ./rust.nix
    ./python.nix
  ];

  environment.systemPackages = with pkgs; [
    pkg-config
  ];
}
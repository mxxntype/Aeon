# INFO: Global astrumaureus configuration

{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  imports = [
    ../features/cli
    ../features/nvim
    inputs.nix-colors.homeManagerModules.default
  ]; # ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
  };

  home = {
    username = lib.mkDefault "astrumaureus";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
  };

  # Sets global colorscheme
  colorscheme = lib.mkDefault colorSchemes.everforest;
  # Echoes it to ~/.colorscheme
  home.file.".colorscheme".text = config.colorscheme.slug; 
}

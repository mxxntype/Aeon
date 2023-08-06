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
    ../features/helix
    inputs.nix-colors.homeManagerModules.default
  ] ++ (builtins.attrValues outputs.homeManagerModules);

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
    nix-index = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;
    };
  };

  home = {
    username = lib.mkDefault "astrumaureus";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "Catppuccin-Mocha-Dark-Cursors";
      size = 32;
    };
  };

  # Sets global colorscheme
  colorscheme = lib.mkDefault colorSchemes.nord;
  # Echoes it to ~/.colorscheme
  # home.file.".colorscheme".text = config.colorscheme.slug; 
}

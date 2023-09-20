# INFO: Global astrumaureus configuration

{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors.lib) schemeFromYAML;
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

    sessionVariables = let
      dirName = "Screenshots";
    in {
      GRIM_DEFAULT_DIR = "${config.xdg.userDirs.pictures}/${dirName}";
      XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/${dirName}";
    };
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Images";
    };
  };

  # Sets global colorscheme
  # colorscheme = schemeFromYAML "base16" (builtins.readFile ../../../colorschemes/everblush.yaml);
  colorscheme = schemeFromYAML "base16" (builtins.readFile ../../../colorschemes/catppuccin-oled.yaml);
  # colorscheme = schemeFromYAML "base16" (builtins.readFile ../../../colorschemes/decay.yaml);
  # colorscheme = lib.mkDefault colorSchemes.catppuccin-frappe;
  # Echoes it to ~/.colorscheme
  # home.file.".colorscheme".text = config.colorscheme.slug; 
}

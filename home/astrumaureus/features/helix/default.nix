# INFO: Helix, a post-modern editor

{
  config,
  pkgs,
  ...
}: let
  inherit (config) colorscheme;
in {
  programs.helix = {
    enable = true;

    settings = {
      theme = colorscheme.slug;
      editor = {
        color-modes = true;
        indent-guides.render = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
    };

    languages.language = [
      {
        name = "rust";
        auto-format = true;
      }
      {
        name = "nix";
      }
      # TODO: Set up C
      # {
      #   name = "clangd";
      # }
    ];
  };

  home.packages = with pkgs; [
    rust-analyzer
    nil
    # clang-tools
  ];
}

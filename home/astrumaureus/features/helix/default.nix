# INFO: Helix, a post-modern vim-like editor

{
  pkgs,
  ...
}: {
  imports = [
    ./theme.nix
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "base16";
      editor = {
        idle-timeout = 0;
        completion-trigger-len = 1;
        lsp = {
          display-inlay-hints = true;
        };

        indent-guides = {
          render = true;
        };

        color-modes = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
          ];
          center = [
            "file-base-name"
            "file-modification-indicator"
          ];
          right = [
            "diagnostics"
            "position"
            "file-encoding"
            # "file-line-ending"
            "file-type"
          ];

          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };

        file-picker = {
          hidden = false;
        };

        auto-pairs = {
          "(" = ")";
          "[" = "]";
          "{" = "}";
          "\"" = "\"";
          "'" = "'";
          "`" = "`";
          "<" = ">";
        };

        soft-wrap.enable = true;
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
    ];
  };

  home.packages = with pkgs; [
    rust-analyzer
    nil
  ];
}

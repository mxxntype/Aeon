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
          # display-inlay-hints = true;
          display-messages = true;
        };
        file-picker.hidden = false;

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

        # file-picker = {
        #   hidden = false;
        # };

        auto-pairs = {
          "(" = ")";
          "[" = "]";
          "{" = "}";
          "\"" = "\"";
          "'" = "'";
          "`" = "`";
          # "<" = ">";
        };
        soft-wrap.enable = true;
      };

      keys = {
        insert = {
          "A-h" = "move_char_left";
          "A-j" = "move_line_down";
          "A-k" = "move_line_up";
          "A-l" = "move_char_right";
        };
        # normal = {
        #   "space-W" = "write";
        # };
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
      # {
      #   name = "python";
      #   scope = "source.python";
      #   injection-regex = "python";
      #   file-types = ["py" "pyi" "py3" "pyw" "ptl" ".pythonstartup" ".pythonrc" "SConstruct"];
      #   shebangs = ["python"];
      #   roots = ["setup.py"  "setup.cfg"  "pyproject.toml"];
      #   comment-token = "#";
      #   language-server = {
      #     command = "pyright-langserver";
      #     args = ["--stdio"];
      #   };
      #   indent = { tab-width = 4; unit = "    "; };
      #   config = {}; # will get "Async jobs timed out" errors if this empty config is not added
      # }
    ];
  };

  home.packages = with pkgs; [
    rust-analyzer
    nil
  ];
}

# INFO: `fzf`, a general-purpose command-line fuzzy finder
{ config, ... }: let
  inherit (config.colorscheme) colors;
in {
  programs.fzf = {
    enable = true;

    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    colors = rec {
      bg = "#${colors.base00}"; # Background
      fg = "#${colors.base04}"; # Text
      "bg+" = bg; # Background (current line)
      "fg+" = "#${colors.base05}"; # Text (current line)
      hl = fg; # Highlighted substrings
      "hl+" = "#${colors.base0A}"; # Highlighted substrings (current line)
      preview-bg = bg; # Background (preview window)
      preview-fg = "#${colors.base05}"; # Text (preview window)
      gutter = bg; # Gutter on the left (defaults to bg+)
      info = "#${colors.base04}";
      border = "#${colors.base02}"; # Border of the preview window and horizontal separators (--border)
      prompt = "#${colors.base0E}";
      pointer = "#${colors.base0A}";
      spinner = "#${colors.base08}"; # Streaming input indicator
      header = "#${colors.base04}";
    };

    defaultCommand = null;
    defaultOptions = [
      "--border"
      "--height 40%"
      "--bind=tab:down"
      "--bind=btab:up"
    ];

    # CTRL+T
    fileWidgetCommand = null;
    fileWidgetOptions = [
      "--preview 'bat -nf {}'"
    ];

    # ALT+C
    changeDirWidgetCommand = "fd --type directory";
    # changeDirWidgetOptions = [
    #   "--preview 'erd --dirs-only --suppress-size --icons --layout inverted {} | head -n 100'"
    # ];

    # CTRL+R
    historyWidgetOptions = [
      "--exact"
    ];
  };
}
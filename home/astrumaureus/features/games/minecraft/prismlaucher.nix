{
  config,
  pkgs,
  ...
}: let 
  inherit (config.colorscheme) colors;
in {
  home.packages = with pkgs; [
    prismlauncher
  ];

  home.file.".local/share/PrismLauncher/themes/custom/theme.json".text = ''
    {
      "colors": {
        "AlternateBase": "#${colors.base02}",
        "Base": "#${colors.base01}",
        "BrightText": "#${colors.base05}",
        "Button": "#${colors.base03}",
        "ButtonText": "#${colors.base05}",
        "Highlight": "#${colors.base09}",
        "HighlightText": "#${colors.base01}",
        "Link": "#${colors.base0D}",
        "Text": "#${colors.base05}",
        "ToolTipBase": "#${colors.base01}",
        "ToolTipText": "#${colors.base05}",
        "Window": "#${colors.base01}",
        "WindowText": "#${colors.base05}",
        "fadeAmount": 0.5,
        "fadeColor": "#${colors.base02}"
      },
      "name": "Nix Dynamic",
      "qssFilePath": "themeStyle.css",
      "widgets": "Fusion"
    }
  '';

  home.file.".local/share/PrismLauncher/themes/custom/themeStyle.css".text = ''
    QToolTip {
      color: #${colors.base05};
      background-color: #${colors.base01};
      border: 2px solid #${colors.base02};
    }
  '';
}

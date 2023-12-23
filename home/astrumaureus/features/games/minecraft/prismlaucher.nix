{ config, pkgs, ... }: let 
    inherit (config.theme) colors;
in {
    home.packages = with pkgs; [
        prismlauncher
    ];

    home.file.".local/share/PrismLauncher/themes/custom/theme.json".text = builtins.toJSON {
        colors = {
            AlternateBase = "#${colors.surface0}";
            Base = "#${colors.base}";
            BrightText = "#${colors.text}";
            Button = "#${colors.surface1}";
            ButtonText = "#${colors.text}";
            Highlight = "#${colors.green}";
            HighlightText = "#${colors.base}";
            Link = "#${colors.blue}";
            Text = "#${colors.text}";
            ToolTipBase = "#${colors.base}";
            ToolTipText = "#${colors.text}";
            Window = "#${colors.base}";
            WindowText = "#${colors.text}";
            fadeAmount = 0.5;
            fadeColor = "#${colors.surface0}";
        };
        name = "Nix Dynamic";
        qssFilePath = "themeStyle.css";
        widgets = "Fusion";
    };

    home.file.".local/share/PrismLauncher/themes/custom/themeStyle.css".text = /* css */ ''
        QToolTip {
            color: #${colors.text};
            background-color: #${colors.base};
            border: 2px solid #${colors.surface0};
        }
    '';
}

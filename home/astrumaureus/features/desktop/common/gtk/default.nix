{ config, pkgs, ... }: let
    inherit (config.theme) colors;
    nixGtkTheme = let
            rendersvg = pkgs.runCommand "rendersvg" { } ''
                mkdir -p $out/bin
                ln -s ${pkgs.resvg}/bin/resvg $out/bin/rendersvg
            '';
        in pkgs.stdenv.mkDerivation {
            name = "nix-gtk-theme";
            src = pkgs.fetchFromGitHub {
                owner = "nana-4";
                repo = "materia-theme";
                rev = "76cac96ca7fe45dc9e5b9822b0fbb5f4cad47984";
                sha256 = "sha256-0eCAfm/MWXv6BbCl2vbVbvgv8DiUH09TAUhoKq7Ow0k=";
            };
            buildInputs = with pkgs; [
                sassc
                bc
                which
                rendersvg
                meson
                ninja
                nodePackages.sass
                gtk4.dev
                optipng
            ];
            phases = [ "unpackPhase" "installPhase" ];
            installPhase = /* shell */ ''
                HOME=/build
                chmod 777 -R .
                patchShebangs .
                mkdir -p $out/share/themes
                mkdir bin
                sed -e 's/handle-horz-.*//' -e 's/handle-vert-.*//' -i ./src/gtk-2.0/assets.txt

                cat > /build/gtk-colors << EOF
                    BTN_BG=${colors.base}
                    BTN_FG=${colors.text}
                    FG=${colors.text}
                    BG=${colors.base}
                    HDR_BTN_BG=${colors.mantle}
                    HDR_BTN_FG=${colors.text}
                    ACCENT_BG=${colors.blue}
                    ACCENT_FG=${colors.crust}
                    HDR_FG=${colors.text}
                    HDR_BG=${colors.base}
                    MATERIA_SURFACE=${colors.base}
                    MATERIA_VIEW=${colors.mantle}
                    MENU_BG=${colors.base}
                    MENU_FG=${colors.subtext0}
                    SEL_BG=${colors.blue}
                    SEL_FG=${colors.surface0}
                    TXT_BG=${colors.base}
                    TXT_FG=${colors.text}
                    WM_BORDER_FOCUS=${colors.text}
                    WM_BORDER_UNFOCUS=${colors.surface0}
                    UNITY_DEFAULT_LAUNCHER_STYLE=False
                    NAME=Nix
                    MATERIA_STYLE_COMPACT=True
                EOF

                echo "Changing colours:"
                ./change_color.sh -o Nix /build/gtk-colors -i False -t "$out/share/themes"
                chmod 555 -R .
            '';
        };
in {
    gtk = {
        enable = true;
        font = {
            name = "IosevkaTerm Nerd Font";
            size = 10;
        };
        theme = {
            # name = "Catppuccin-Mocha-Standard-Mauve-Dark";
            # package = pkgs.catppuccin-gtk.override {
            #     accents = [ "mauve" ];
            #     size = "standard";
            #     tweaks = [];
            #     variant = "mocha";
            # };
            name = "Nix";
            package = nixGtkTheme;
        };
        # iconTheme = {
        #     name = "Papirus";
        #     package = pkgs.papirus-icon-theme;
        # };
    };

    # services.xsettingsd = {
    #     enable = true;
    #     settings = {
    #         "Net/ThemeName" = "${gtk.theme.name}";
    #         # "Net/IconThemeName" = "${gtk.iconTheme.name}";
    #     };
    # };

    home.packages = with pkgs; [
        gtk-engine-murrine
        gnome.adwaita-icon-theme
    ];
}

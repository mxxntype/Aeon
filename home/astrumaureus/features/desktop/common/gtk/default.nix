{ pkgs, ... }: {
  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        tweaks = [];
        variant = "mocha";
      };
    };
    # iconTheme = {
    #   name = "Papirus";
    #   package = pkgs.papirus-icon-theme;
    # };
  };

  # services.xsettingsd = {
  #   enable = true;
  #   settings = {
  #     "Net/ThemeName" = "${gtk.theme.name}";
  #     # "Net/IconThemeName" = "${gtk.iconTheme.name}";
  #   };
  # };

  home.packages = with pkgs; [
    gtk-engine-murrine
    gnome.adwaita-icon-theme
  ];
}

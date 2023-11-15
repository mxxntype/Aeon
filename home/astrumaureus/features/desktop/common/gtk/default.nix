{ pkgs, ... }: {
  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
    # theme = {
    #   name = "${config.theme.slug}";
    #   package = gtkThemeFromScheme { scheme = config.theme; };
    # };
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

{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    wiki-tui
  ];

  xdg.configFile."wiki-tui/config.toml".text = let
    config = {
      api = {
        article_language_changed_popup = true;
        language = "English";
        language_changed_popup = true;
        post_language = ".wikipedia.org/w/api.php";
        pre_language = "https://";
      };
      features = {
        links = true;
        toc = true;
      };
      keybindings = {
        down = {
          key = "j";
          mode = "normal";
        };
        focus_next = {
          key = "tab";
          mode = "normal";
        };
        focus_prev = {
          key = "tab";
          mode = "shift";
        };
        left = {
          key = "h";
          mode = "normal";
        };
        right = {
          key = "l";
          mode = "normal";
        };
        toggle_article_language_selection = {
          key = "f3";
          mode = "normal";
        };
        toggle_language_selection = {
          key = "f2";
          mode = "normal";
        };
        up = {
          key = "k";
          mode = "normal";
        };
      };
      logging = {
        enabled = true;
        log_level = "INFO";
      };
      settings = {
        toc = {
          item_format = "{NUMBER} {TEXT}";
          max_width = 60;
          min_width = 20;
          position = "Right";
          scroll_x = true;
          scroll_y = true;
          title = "Default";
        };
      };
      theme = {
        background = "default";
        highlight = "magenta";
        highlight_inactive = "black";
        highlight_text = "white";
        search_match = "cyan";
        text = "white";
        title = "blue";
      };
    };
  in inputs.nix-std.lib.serde.toTOML config;
}

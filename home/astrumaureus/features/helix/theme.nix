# INFO: Dynamic colorscheme for `helix`
{ config, ... }: let
  inherit (config.theme) colors;
in {
  programs.helix = {
    themes = {
      base16 = {
        palette = {
          # Backgrounds
          crust = "#${colors.base}";
          mantle = "#${colors.base}";
          base = "#${colors.base}";
          # Surfaces
          surface0 = "#${colors.surface0}";
          surface1 = "#${colors.surface1}";
          surface2 = "#${colors.surface2}";
          # Overlays
          overlay0 = "#6c7086"; # FIXME
          overlay1 = "#7f849c"; # FIXME
          overlay2 = "#9399b2"; # FIXME
          # Texts
          subtext0 = "#a6adc8"; # FIXME
          subtext1 = "#bac2de"; # FIXME
          text = "#${colors.text}";
          # Cursor
          secondary_cursor = "#b5a6a8"; # FIXME
          cursorline = "#${colors.surface1}";
          # Accents
          red = "#${colors.red}";
          maroon = "#${colors.maroon}";
          peach = "#${colors.peach}";
          yellow = "#${colors.yellow}";
          flamingo = "#f2cdcd";  # FIXME
          rosewater = "#f5e0dc"; # FIXME
          green = "#${colors.green}";
          teal = "#${colors.teal}";
          sky = "#${colors.sky}";
          sapphire = "#74c7ec";  # FIXME
          blue = "#${colors.blue}";
          mauve = "#${colors.mauve}";
          pink = "#${colors.pink}";
          lavender = "#b4befe"; # FIXME
        };
        attribute = "blue";
        comment = {
          fg = "overlay1";
          modifiers = ["italic"];
        };
        constant = "peach";
        "constant.builtin" = "peach";
        "constant.character" = "teal";
        "constant.character.escape" = "pink";
        constructor = "sapphire";
        "diagnostic.error" = {
          underline = {
            color = "red";
            style = "curl";
          };
        };
        "diagnostic.hint" = {
          underline = {
            color = "teal";
            style = "curl";
          };
        };
        "diagnostic.info" = {
          underline = {
            color = "sky";
            style = "curl";
          };
        };
        "diagnostic.warning" = {
          underline = {
            color = "yellow";
            style = "curl";
          };
        };
        "diff.delta" = "blue";
        "diff.minus" = "red";
        "diff.plus" = "green";
        error = "red";
        function = "blue";
        "function.macro" = "mauve";
        hint = "teal";
        info = "sky";
        keyword = "mauve";
        "keyword.control.conditional" = {
          fg = "mauve";
          modifiers = [ "italic" ];
        };
        "keyword.storage.modifier.ref" = "teal";
        label = "sapphire";
        "markup.bold" = {
          modifiers = [ "bold" ];
        };
        "markup.heading.1" = "lavender";
        "markup.heading.2" = "mauve";
        "markup.heading.3" = "green";
        "markup.heading.4" = "yellow";
        "markup.heading.5" = "pink";
        "markup.heading.6" = "teal";
        "markup.heading.marker" = {
          fg = "peach";
          modifiers = [ "bold" ];
        };
        "markup.italic" = {
          modifiers = [ "italic" ];
        };
        "markup.link.text" = "blue";
        "markup.link.url" = {
          fg = "rosewater";
          modifiers = [ "underlined" ];
        };
        "markup.list" = "mauve";
        "markup.raw" = "flamingo";
        "markup.strikethrough" = {
          modifiers = [ "crossed_out" ];
        };
        namespace = {
          fg = "blue";
          modifiers = [ "italic" ];
        };
        operator = "sky";
        punctuation = "overlay2";
        "punctuation.special" = "sky";
        special = "blue";
        string = "green";
        "string.regexp" = "peach";
        "string.special" = "blue";
        tag = "mauve";
        type = "yellow";
        "ui.background" = {
          bg = "base";
          fg = "text";
        };
        "ui.bufferline" = {
          bg = "mantle";
          fg = "subtext0";
        };
        "ui.bufferline.active" = {
          bg = "base";
          fg = "mauve";
          underline = {
            color = "mauve";
            style = "line";
          };
        };
        "ui.bufferline.background" = {
          bg = "crust";
        };
        "ui.cursor" = {
          bg = "secondary_cursor";
          fg = "base";
        };
        "ui.cursor.match" = {
          fg = "peach";
          modifiers = [ "bold" ];
        };
        "ui.cursor.primary" = {
          bg = "rosewater";
          fg = "base";
        };
        "ui.cursorline.primary" = {
          bg = "cursorline";
        };
        "ui.help" = {
          bg = "surface0";
          fg = "overlay2";
        };
        "ui.highlight" = {
          bg = "surface1";
          modifiers = [ "bold" ];
        };
        "ui.linenr" = {
          fg = "surface1";
        };
        "ui.linenr.selected" = {
          fg = "lavender";
        };
        "ui.menu" = {
          bg = "surface0";
          fg = "overlay2";
        };
        "ui.menu.selected" = {
          bg = "surface1";
          fg = "text";
          modifiers = [ "bold" ];
        };
        "ui.popup" = {
          bg = "surface0";
          fg = "text";
        };
        "ui.selection" = {
          bg = "surface1";
        };
        "ui.statusline" = {
          bg = "mantle";
          fg = "subtext1";
        };
        "ui.statusline.inactive" = {
          bg = "mantle";
          fg = "surface2";
        };
        "ui.statusline.insert" = {
          bg = "green";
          fg = "base";
          modifiers = [ "bold" ];
        };
        "ui.statusline.normal" = {
          bg = "lavender";
          fg = "base";
          modifiers = [ "bold" ];
        };
        "ui.statusline.select" = {
          bg = "flamingo";
          fg = "base";
          modifiers = [ "bold" ];
        };
        "ui.text" = "text";
        "ui.text.focus" = {
          bg = "surface0";
          fg = "text";
          modifiers = [ "bold" ];
        };
        "ui.virtual" = "overlay0";
        "ui.virtual.indent-guide" = "surface0";
        "ui.virtual.inlay-hint" = {
          bg = "mantle";
          fg = "surface1";
        };
        "ui.virtual.ruler" = {
          bg = "surface0";
        };
        "ui.window" = {
          fg = "crust";
        };
        "variable" = "text";
        "variable.builtin" = "red";
        "variable.other.member" = "teal";
        "variable.parameter" = {
          fg = "maroon";
          modifiers = [ "italic" ];
        };
        warning = "yellow";
      };
    };
  };
}

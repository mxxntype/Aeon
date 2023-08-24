# INFO: Dynamic colorscheme for helix

{
  config,
  ...
}: let 
  inherit (config.colorscheme) colors;
in {
  programs.helix = {
    themes = {
      base16 = let 
        # Common colors
        transparent = "none";

        # Backgrounds
        # mantle = "#${colors.base00}";
        base = "#${colors.base01}";
        surface0 = "#${colors.base02}";
        surface1 = "#${colors.base03}";

        # Foregrounds
        subtext = "#${colors.base04}";
        text = "#${colors.base05}";

        # Accents
        red = "#${colors.base06}";
        maroon = "#${colors.base07}";
        orange = "#${colors.base08}";
        yellow = "#${colors.base09}";
        green = "#${colors.base0A}";
        cyan = "#${colors.base0B}";
        teal = "#${colors.base0C}";
        blue = "#${colors.base0D}";
        purple = "#${colors.base0E}";
        pink = "#${colors.base0F}";
      in {
        "ui.linenr.selected" = subtext;
        "ui.cursorline.primary" = { bg = base; };
        "ui.text.focus" = { fg = purple; modifiers = ["bold"]; };
        "ui.menu" = { fg = text; bg = surface0; };
        "ui.menu.selected" = { fg = purple; bg = surface0; };
        "ui.virtual.ruler" = { bg = base; };

        "info" = purple;
        "hint" = pink;

        # Polar Night
        # nord0 - background color
        "ui.background" = transparent;

        "ui.statusline" = { fg = subtext; bg = surface0; };
        "ui.statusline.inactive" = { fg = subtext; bg = surface0; };
        "ui.statusline.normal" = { fg = base; bg = purple; };
        "ui.statusline.insert" = { fg = base; bg = green; };
        "ui.statusline.select" = { fg = base; bg = blue; };

        "ui.popup" = { bg = base; };
        "ui.window" = { bg = base; };
        "ui.help" = { bg = base; fg = text; };

        "ui.selection" = { bg = surface0; };
        "ui.cursor.match" = { bg = surface0; };

        "comment" = { fg = surface1; modifiers = ["italic"]; };
        "ui.linenr" = surface1;
        "ui.virtual.whitespace" = surface0;
        "ui.virtual.inlay-hint" = { fg = surface0; };

        "ui.cursor.primary" = { fg = subtext; modifiers = ["reversed"]; };
        "attribute" = text;
        "variable" = text;
        "constant" = text;
        "variable.builtin" = text;
        "constant.builtin" = text;
        "namespace" = cyan;

        "ui.text" = text;
        "punctuation" = text;

        "type" = yellow;
        "type.builtin" = yellow;
        "label" = yellow;

        "constructor" = blue;
        "function" = blue;
        "function.macro" = blue;
        "function.builtin" = blue;

        "punctuation.delimiter" = orange;
        "operator" = orange;
        # "variable.other.member" = orange;

        "keyword" = purple;
        "keyword.directive" = purple;
        "variable.parameter" = purple;

        "error" = red;

        "special" = pink;
        "module" = pink;

        "warning" = orange;
        "constant.character.escape" = subtext;

        "string" = green;

        "constant.numeric" = orange;

        "markup.heading" = maroon;
        "markup.list" = cyan;
        "markup.bold" = { modifiers = ["bold"]; };
        "markup.italic" = { modifiers = ["italic"]; };
        "markup.strikethrough" = { modifiers = ["crossed_out"]; };
        "markup.link.text" = blue;
        "markup.raw" = teal;

        "diagnostic.error" = { underline = { color = red; style = "curl"; }; };
        "diagnostic.warning" = { underline = { color = orange; style = "curl"; }; };
        "diagnostic.info" = { underline = { color = purple; style = "curl"; }; };
        "diagnostic.hint" = { underline = { color = pink; style = "curl"; }; };

        "diff.plus" = green;
        "diff.delta" = purple;
        "diff.minus" = red;
      };
    };
  };
}

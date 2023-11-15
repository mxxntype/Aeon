# INFO: `yazi`, terminal file manager in Rust
{
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit(config.theme) colors;
in {
  home.packages = with pkgs; [
    yazi
    ffmpegthumbnailer
    unar
  ]; 

  xdg.configFile."yazi/yazi.toml".text = inputs.nix-std.lib.serde.toTOML {
    "manager" = {
      "layout" = [
        2
        3
        3
      ];
      "show_hidden" = true;
      "show_symlink" = true;
      "sort_by" = "natural";
      "sort_dir_first" = true;
      "sort_reverse" = false;
      "sort_sensitive" = false;
    };
    "preview" = {
      "tab_size" = 4;
    };
  };

  xdg.configFile."yazi/theme.toml".text = ''
    [filetype]
    [[filetype.rules]]
    fg = "#${colors.mauve}"
    mime = "image/*"

    [[filetype.rules]]
    fg = "#${colors.pink}"
    mime = "video/*"

    [[filetype.rules]]
    fg = "#${colors.sky}"
    mime = "audio/*"

    [[filetype.rules]]
    fg = "#${colors.maroon}"
    mime = "application/zip"

    [[filetype.rules]]
    fg = "#${colors.maroon}"
    mime = "application/gzip"

    [[filetype.rules]]
    fg = "#${colors.maroon}"
    mime = "application/x-tar"

    [[filetype.rules]]
    fg = "#${colors.maroon}"
    mime = "application/x-bzip"

    [[filetype.rules]]
    fg = "#${colors.maroon}"
    mime = "application/x-bzip2"

    [[filetype.rules]]
    fg = "#${colors.maroon}"
    mime = "application/x-7z-compressed"

    [[filetype.rules]]
    fg = "#${colors.maroon}"
    mime = "application/x-rar"

    [[filetype.rules]]
    fg = "#${colors.maroon}"
    name = "*.iso"

    [[filetype.rules]]
    fg = "#${colors.pink}"
    name = "default.nix"

    [[filetype.rules]]
    fg = "#${colors.mauve}"
    name = "*.nix"

    [[filetype.rules]]
    fg = "#${colors.green}"
    name = "*.key"

    [[filetype.rules]]
    fg = "#${colors.green}"
    name = "*.gpg"

    [[filetype.rules]]
    fg = "#${colors.green}"
    name = "*.kdbx"

    [[filetype.rules]]
    fg = "#${colors.sky}"
    name = "*.doc?"

    [[filetype.rules]]
    fg = "#${colors.red}"
    name = "*.sh"

    [[filetype.rules]]
    fg = "#${colors.red}"
    name = "*.fish"

    [[filetype.rules]]
    fg = "#${colors.blue}"
    name = "*/"

    [[filetype.rules]]
    fg = "#${colors.text}"
    name = "*"

    [icons]
    "*.7z" = "󰀼"
    "*.asm" = ""
    "*.avi" = "󰈣"
    "*.avif" = "󰈣"
    "*.bmp" = "󰋩"
    "*.c" = ""
    "*.conf" = "󰒓"
    "*.cpp" = ""
    "*.css" = "󰌜"
    "*.fish" = "󱆃"
    "*.flac" = "󰈣"
    "*.gif" = "󰵸"
    "*.go" = "󰟓"
    "*.gz" = "󰀼"
    "*.h" = ""
    "*.hpp" = ""
    "*.html" = "󰌝"
    "*.ico" = "󰋩"
    "*.ini" = "󰒓"
    "*.java" = ""
    "*.jpeg" = "󰋩"
    "*.jpg" = "󰋩"
    "*.js" = "󰌞"
    "*.json" = "󰘦"
    "*.jsx" = "󰌞"
    "*.lua" = "󰢱"
    "*.md" = "󰍔"
    "*.mkv" = "󰈫"
    "*.mov" = "󰈫"
    "*.mp3" = "󰈣"
    "*.mp4" = "󰈫"
    "*.php" = "󰌟"
    "*.png" = "󰋩"
    "*.doc" = "󰂺"
    "*.docx" = "󰂺"
    "*.py" = "󰌠"
    "*.rb" = "󰴭"
    "*.rs" = "󱘗"
    "*.scss" = "󰌜"
    "*.sh" = "󱆃"
    "*.svg" = "󰜡"
    "*.swift" = "󰛥"
    "*.tar" = "󰀼"
    "*.toml" = "󰒓"
    "*.ts" = "󰛦"
    "*.tsx" = "󰛦"
    "*.txt" = "󰈙"
    "*.wav" = "󰈣"
    "*.webp" = "󰋩"
    "*.yaml" = "󰒓"
    "*.yml" = "󰒓"
    "*.nix" = "󱄅"
    "*.zip" = "󰀼"
    "*.iso" = "󰀥"
    "*.key" = "󰌆"
    "*.gpg" = "󰌆"
    "*.kdbx" = "󰌆"
    "*.sql" = "󰡦"
    "*.db" = "󰆼"
    ".DS_Store" = "󰀵"
    ".bashprofile" = "󰒓"
    ".bashrc" = "󰒓"
    ".config/" = "󱁿"
    ".git/" = "󰊢"
    ".gitattributes" = "󰊢"
    ".gitignore" = "󰊢"
    ".gitmodules" = "󰊢"
    ".zprofile" = "󰒓"
    ".zshenv" = "󰒓"
    ".zshrc" = "󰒓"
    "*_history" = "󰋚"
    "common/" = "󰾶"
    "global/" = ""
    "Camera/" = "󰉏"
    "Desktop/" = "󰇄"
    "Repos/" = "󱧼"
    "Projects/" = "󱧼"
    "Aeon/" = "󱃪"
    "Documents/" = "󰉐"
    "Downloads/" = "󰉍"
    "Library/" = "󰂺"
    "Movies/" = "󰕧"
    "Videos/" = "󰕧"
    "Music/" = "󱍙"
    "Files/" = "󱧶"
    ".shadow/" = "󰢬"
    "Images/" = "󰉏"
    "Public/" = "󱞊"
    "home/" = "󰉌"
    "*/" = "󰉋"
    "*" = "󰈔"

    [marker]
    [marker.selected]
    bg = "#${colors.surface0}"
    fg = "#${colors.mauve}"

    [marker.selecting]
    bg = "#${colors.surface0}"
    fg = "#${colors.blue}"

    [preview]
    syntect_theme = "~/.config/bat/themes/Catppuccin-mocha.tmTheme"

    [preview.hovered]
    underline = false
    bg = "#${colors.surface0}"
    fg = "#${colors.red}"

    [progress]
    [progress.gauge]
    bg = "#${colors.surface1}"
    fg = "#${colors.peach}"

    [progress.label]
    bold = true
    fg = "#${colors.text}"

    [selection]
    [selection.hovered]
    bg = "#${colors.surface0}"
    fg = "#${colors.red}"

    [status]
    [status.body]
    normal = "#${colors.surface1}"
    select = "#${colors.surface1}"
    unset = "#${colors.surface1}"

    [status.danger]
    normal = "#${colors.red}"
    select = "#${colors.red}"
    unset = "#${colors.red}"

    [status.emphasis]
    normal = "#${colors.peach}"
    select = "#${colors.peach}"
    unset = "#${colors.peach}"

    [status.info]
    normal = "#${colors.green}"
    select = "#${colors.green}"
    unset = "#${colors.green}"

    [status.primary]
    normal = "#${colors.mauve}"
    select = "#${colors.blue}"
    unset = "#${colors.teal}"

    [status.secondary]
    normal = "#${colors.base}"
    select = "#${colors.base}"
    unset = "#${colors.base}"

    [status.separator]
    closing = ""
    opening = ""

    [status.success]
    normal = "#${colors.green}"
    select = "#${colors.green}"
    unset = "#${colors.green}"

    [status.tertiary]
    normal = "#${colors.green}"
    select = "#${colors.green}"
    unset = "#${colors.green}"

    [status.warning]
    normal = "#${colors.maroon}"
    select = "#${colors.maroon}"
    unset = "#${colors.maroon}"

    [tab]
    max_width = 1

    [tab.active]
    bg = "#${colors.mauve}"
    fg = "#${colors.base}"

    [tab.inactive]
    bg = "#${colors.surface0}"
    fg = "#${colors.text}"
  '';
}
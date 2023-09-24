# INFO: `yazi`, terminal file manager in Rust
{
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit(config.colorscheme) colors;
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
    fg = "#${colors.base0E}"
    mime = "image/*"

    [[filetype.rules]]
    fg = "#${colors.base0F}"
    mime = "video/*"

    [[filetype.rules]]
    fg = "#${colors.base0C}"
    mime = "audio/*"

    [[filetype.rules]]
    fg = "#${colors.base07}"
    mime = "application/zip"

    [[filetype.rules]]
    fg = "#${colors.base07}"
    mime = "application/gzip"

    [[filetype.rules]]
    fg = "#${colors.base07}"
    mime = "application/x-tar"

    [[filetype.rules]]
    fg = "#${colors.base07}"
    mime = "application/x-bzip"

    [[filetype.rules]]
    fg = "#${colors.base07}"
    mime = "application/x-bzip2"

    [[filetype.rules]]
    fg = "#${colors.base07}"
    mime = "application/x-7z-compressed"

    [[filetype.rules]]
    fg = "#${colors.base07}"
    mime = "application/x-rar"

    [[filetype.rules]]
    fg = "#${colors.base07}"
    name = "*.iso"

    [[filetype.rules]]
    fg = "#${colors.base0F}"
    name = "default.nix"

    [[filetype.rules]]
    fg = "#${colors.base0E}"
    name = "*.nix"

    [[filetype.rules]]
    fg = "#${colors.base0A}"
    name = "*.key"

    [[filetype.rules]]
    fg = "#${colors.base0A}"
    name = "*.gpg"

    [[filetype.rules]]
    fg = "#${colors.base0A}"
    name = "*.kdbx"

    [[filetype.rules]]
    fg = "#${colors.base0C}"
    name = "*.doc?"

    [[filetype.rules]]
    fg = "#${colors.base06}"
    name = "*.sh"

    [[filetype.rules]]
    fg = "#${colors.base06}"
    name = "*.fish"

    [[filetype.rules]]
    fg = "#${colors.base0D}"
    name = "*/"

    [[filetype.rules]]
    fg = "#${colors.base05}"
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
    bg = "#${colors.base02}"
    fg = "#${colors.base0E}"

    [marker.selecting]
    bg = "#${colors.base02}"
    fg = "#${colors.base0D}"

    [preview]
    syntect_theme = "~/.config/bat/themes/Catppuccin-mocha.tmTheme"

    [preview.hovered]
    underline = false
    bg = "#${colors.base02}"
    fg = "#${colors.base06}"

    [progress]
    [progress.gauge]
    bg = "#${colors.base03}"
    fg = "#${colors.base08}"

    [progress.label]
    bold = true
    fg = "#${colors.base05}"

    [selection]
    [selection.hovered]
    bg = "#${colors.base02}"
    fg = "#${colors.base06}"

    [status]
    [status.body]
    normal = "#${colors.base03}"
    select = "#${colors.base03}"
    unset = "#${colors.base03}"

    [status.danger]
    normal = "#${colors.base06}"
    select = "#${colors.base06}"
    unset = "#${colors.base06}"

    [status.emphasis]
    normal = "#${colors.base08}"
    select = "#${colors.base08}"
    unset = "#${colors.base08}"

    [status.info]
    normal = "#${colors.base0A}"
    select = "#${colors.base0A}"
    unset = "#${colors.base0A}"

    [status.primary]
    normal = "#${colors.base0E}"
    select = "#${colors.base0D}"
    unset = "#${colors.base0B}"

    [status.secondary]
    normal = "#${colors.base00}"
    select = "#${colors.base00}"
    unset = "#${colors.base00}"

    [status.separator]
    closing = ""
    opening = ""

    [status.success]
    normal = "#${colors.base0A}"
    select = "#${colors.base0A}"
    unset = "#${colors.base0A}"

    [status.tertiary]
    normal = "#${colors.base0A}"
    select = "#${colors.base0A}"
    unset = "#${colors.base0A}"

    [status.warning]
    normal = "#${colors.base07}"
    select = "#${colors.base07}"
    unset = "#${colors.base07}"

    [tab]
    max_width = 1

    [tab.active]
    bg = "#${colors.base0E}"
    fg = "#${colors.base00}"

    [tab.inactive]
    bg = "#${colors.base02}"
    fg = "#${colors.base05}"
  '';
}
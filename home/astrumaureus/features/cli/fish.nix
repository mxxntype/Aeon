{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
  inherit (config.colorscheme) colors;
in {
  programs.fish = {
    enable = true; # ISSUE: users.users.*.shell complains for some reason
    
    interactiveShellInit = ''
      # Colorscheme
      # sh ${shellThemeFromScheme {scheme = config.colorscheme;}}

      set fish_color_autosuggestion 'brblack'
      set fish_color_cancel -r
      set fish_color_command green
      set fish_color_comment red
      set fish_color_cwd green
      set fish_color_cwd_root red
      set fish_color_end green
      set fish_color_error brred
      set fish_color_escape brcyan
      set fish_color_history_current --bold
      set fish_color_host normal
      set fish_color_host_remote yellow
      set fish_color_normal normal
      set fish_color_operator brcyan
      set fish_color_param blue
      set fish_color_quote yellow
      set fish_color_redirection 'cyan'  '--bold'
      set fish_color_search_match 'bryellow'  '--background=brblack'
      set fish_color_selection 'white'  '--bold'  '--background=brblack'
      set fish_color_status red
      set fish_color_user brgreen
      set fish_color_valid_path --underline
      set fish_pager_color_completion normal
      set fish_pager_color_description 'B3A06D'  'yellow'  '-i'
      set fish_pager_color_prefix 'normal'  '--bold'  '--underline'
      set fish_pager_color_progress 'brwhite'  '--background=cyan'
      set fish_pager_color_selected_background -r
      set PALETTE "${lib.concatStringsSep "," [
        "${colors.base00}"
        "${colors.base01}"
        "${colors.base02}"
        "${colors.base03}"
        "${colors.base04}"
        "${colors.base05}"
        "${colors.base06}"
        "${colors.base07}"
        "${colors.base08}"
        "${colors.base09}"
        "${colors.base0A}"
        "${colors.base0B}"
        "${colors.base0C}"
        "${colors.base0D}"
        "${colors.base0E}"
        "${colors.base0F}"
      ]}"

      # `anywhere` abbreviations
      abbr --add --position anywhere -- "rd" "rmdir"
      abbr --add --position anywhere -- "md" "mkdir -pv"
      abbr --add --position anywhere -- "cat" "bat"
      abbr --add --position anywhere -- "scl" "systemctl"
      abbr --add --position anywhere -- R "| rg"
      abbr --add --position anywhere L --set-cursor "% | less"

      function last_history_item
        echo $history[1]
      end
      abbr --add !! --position anywhere --function last_history_item
    '';

    shellAbbrs = {
      # Common commands & tools
      s = "sudo";
      free = "free -h --si";
      duf = "duf -theme ansi";
      sz = "du -sh";
      btm = "btm --battery";
      ps = "procs";
      nvt = "nvtop";

      # Power
      poweroff = "systemctl poweroff";
      shutdown = "systemctl poweroff";
      reboot = "systemctl reboot";

      # Exa
      l = "exa";
      ls = "exa -l";
      lsa = "exa -la";
      tree = "exa -l --tree";

      # Neovim
      nv = "nvim";
      vi = "nvim";
      vim = "nvim";

      # Git: Common
      g = "git";
      ga = "git add";
      gst = "git status";
      grs = "git restore";
      grst = "git restore --staged";
      gd = "git diff";
      gds = "git diff --staged";
      glg = "git log";
      # Git: Commits
      gc = "git commit --verbose --edit";
      gcmsg = "git commit --message";
      # Git: Remotes & stash
      gp = "git push";
      gl = "git pull";
      gsta = "git stash";
      gstaa = "git stash apply";
      gstac = "git stash clear";
      gstal = "git stash list";

      # Nix, NixOS & Home-manager
      n = "nix";
      ns = "nix shell";
      nr = "nix run";
      nf = "nix flake";
      nfu = "nix flake update";
      nfc = "nix flake check";
      nd = "nix develop";
      hm = "home-manager";

      # Rust & cargo
      c = "cargo";
      cn = "cargo new";
      ca = "cargo add";
      ci = "cargo install";
      cu = "cargo update";
      cc = "cargo check";
      ccl = "cargo clippy";
      cb = "cargo build";
      cbr = "cargo build --release";
      cr = "cargo run";
      crr = "cargo run --release";

      # C & C++
      cppcheck = "cppcheck --enable=all --suppress=missingIncludeSystem";
      "gcc" = "gcc -std=c11 -Wall -Werror -Wextra";
      "g++" = "g++ -std=c++17 -Wall -Werror -Wextra";

      # .NET & C#
      # d = "dotnet";
      # da = "dotnet add";
      # dn = "dotnet new";
      # db = "dotnet build";
      # dr = "dotnet run";

      # Packwiz
      pw = "packwiz";

      # Desktops
      Hyprland = "dbus-run-session Hyprland";
      hcl = "hyprctl";

      # CTL's
      bcl = "bluetoothctl";
    };

    # Aliases expand after abbreviations do, so they can be used to
    # silently enable stuff for certain commands, for example, exa:
    shellAliases = {
      exa = "exa --icons --sort=type";
    };

    functions = {
      # Silent startup (disable greeting)
      fish_greeting = "";
    };
  };
}

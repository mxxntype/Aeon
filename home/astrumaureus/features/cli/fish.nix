{
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
in {
  programs.fish = {
    enable = true; # ISSUE: users.users.*.shell complains for some reason
    
    interactiveShellInit = ''
      # Colorscheme
      # sh ${shellThemeFromScheme {scheme = config.colorscheme;}}

      # `anywhere` abbreviations
      abbr --add --position anywhere -- "rd" "rmdir"
      abbr --add --position anywhere -- "md" "mkdir -pv"
      abbr --add --position anywhere -- "cat" "bat"
      abbr --add --position anywhere -- "scl" "systemctl"
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

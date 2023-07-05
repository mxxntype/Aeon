{
  ...
}: {
  programs.fish = {
    enable = true; # ISSUE: users.users.*.shell complains for some reason
    
    interactiveShellInit = ''
      # --[[ Common ]]--
      abbr --add --position command -- "s" "sudo"
      abbr --add --position anywhere -- "rd" "rmdir"
      abbr --add --position anywhere -- "md" "mkdir -pv"
      abbr --add --position anywhere -- "cat" "bat"
      abbr --add --position anywhere -- "scl" "systemctl"

      # --[[ Desktops ]]--
      abbr --add --position command -- "Hyprland" "dbus-run-session Hyprland"

      # --[[ Tools ]]--
      abbr --add --position command -- "free" "free -h --si"
      abbr --add --position command -- "duf" "duf -theme ansi"
      abbr --add --position command -- "sz" "du -sh"
      abbr --add --position command -- "btm" "btm --battery"
      abbr --add --position command -- "ps" "procs"
      abbr --add --position command -- "nvt" "nvtop"

      # --[[ Power ]]--
      abbr --add --position command -- "poweroff" "systemctl poweroff"
      abbr --add --position command -- "shutdown" "systemctl poweroff"
      abbr --add --position command -- "reboot" "systemctl reboot"

      # --[[ Exa ]]--
      # abbr --add --position command -- "exa" "exa --icons --sort=type"
      abbr --add --position command -- "l" "exa"
      abbr --add --position command -- "ls" "exa -l"
      abbr --add --position command -- "lsa" "exa -la"
      abbr --add --position command -- "tree" "exa -l --tree"

      # --[[ Neovim ]]--
      abbr --add --position anywhere -- "nv" "nvim"
      abbr --add --position anywhere -- "vi" "nvim"
      abbr --add --position anywhere -- "vim" "nvim"

      # --[[ Git ]]--
      # Common
      abbr --add --position command -- "g" "git"
      abbr --add --position command -- "ga" "git add"
      abbr --add --position command -- "gst" "git status"
      abbr --add --position command -- "grs" "git restore"
      abbr --add --position command -- "grst" "git restore --staged"
      abbr --add --position command -- "gd" "git diff"
      abbr --add --position command -- "gds" "git diff --staged"
      abbr --add --position command -- "glg" "git log --show-signature"
      # Commits
      abbr --add --position command -- "gc" "git commit --verbose"
      abbr --add --position command -- "gce" "git commit --verbose --edit"
      abbr --add --position command -- "gcmsg" "git commit --message"
      # Remotes & stash
      abbr --add --position command -- "gp" "git push"
      abbr --add --position command -- "gpf" "git push --force"
      abbr --add --position command -- "gl" "git pull"
      abbr --add --position command -- "gsta" "git stash"
      abbr --add --position command -- "gstaa" "git stash apply"
      abbr --add --position command -- "gstac" "git stash clear"

      # --[[ Nix & NixOS | Home-manager ]]--
      abbr --add --position command -- "n" "nix"
      abbr --add --position command -- "ns" "nix shell"
      abbr --add --position command -- "nr" "nix run"
      abbr --add --position command -- "nf" "nix flake"
      abbr --add --position command -- "nfu" "nix flake update"
      abbr --add --position command -- "nfc" "nix flake check"
      abbr --add --position command -- "nd" "nix develop"
      abbr --add --position command -- "hm" "home-manager"

      # --[[ Rust | Cargo ]]--
      abbr --add --position command -- "c" "cargo"
      abbr --add --position command -- "cn" "cargo new"
      abbr --add --position command -- "ca" "cargo add"
      abbr --add --position command -- "ci" "cargo install"
      abbr --add --position command -- "cu" "cargo update"
      abbr --add --position command -- "cc" "cargo check"
      abbr --add --position command -- "ccl" "cargo clippy"
      abbr --add --position command -- "cb" "cargo build"
      abbr --add --position command -- "cbr" "cargo build --release"
      abbr --add --position command -- "cr" "cargo run"
      abbr --add --position command -- "crr" "cargo run --release"

      # --[[ C# | .NET ]]--
      abbr --add --position command -- "d" "dotnet"
      abbr --add --position command -- "da" "dotnet add"
      abbr --add --position command -- "dn" "dotnet new"
      abbr --add --position command -- "db" "dotnet build"
      abbr --add --position command -- "dr" "dotnet run"

      # --[[ Packwiz ]]--
      abbr --add --position command -- "pw" "packwiz"
    '';

    # Aliases expand after abbreviations do, so we can use them to
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

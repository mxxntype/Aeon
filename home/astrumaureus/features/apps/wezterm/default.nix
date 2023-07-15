# INFO: Wezterm (possible Rust replacement for kitty)

{
  ...
}: {
  imports = [
    ./config.nix
  ];

  programs.wezterm = {
    enable = true;
  };
}

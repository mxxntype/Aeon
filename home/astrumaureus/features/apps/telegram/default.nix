# INFO: Telegram clients

{
  pkgs,
  ...
}: {
  # Use kotatogram by default
  imports = [
    # ./kotatogram.nix
  ];

  home.packages = with pkgs; [
    telegram-desktop
  ];
}

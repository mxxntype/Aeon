# INFO: Kotatogram-desktop

{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    kotatogram-desktop
  ];

  # TODO: Declarative theme
}

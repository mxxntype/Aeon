{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps: with ps; [ numpy matplotlib ]))
    nodePackages.pyright
    # jupyter
  ];
}

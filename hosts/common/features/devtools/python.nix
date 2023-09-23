{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps: with ps; [
      # Default stuff
      numpy
      matplotlib
      scipy
      yfinance
      tkinter
    ]))
    nodePackages.pyright
    # jupyter
  ];
}

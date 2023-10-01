{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps: with ps; [
      # Default stuff
      numpy
      pandas
      matplotlib
      scipy
      yfinance
      tkinter
      python-lsp-server
    ]))
    # nodePackages.pyright
  ];
}

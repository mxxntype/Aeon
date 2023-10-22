{ pkgs, ... }: {
  home = {
    file.".fdignore".text = ''
      .git/
    '';
    packages = with pkgs; [
      fd
    ];
  };
}

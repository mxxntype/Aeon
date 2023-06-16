# INFO: Git & GitHub CLI

{
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "mxxntype";
    userEmail = "59417007+mxxntype@users.noreply.github.com";

    extraConfig = {
      init.defaultBranch = "main";

      # Commit & tag signing
      gpg.format = "ssh";
      commit.gpgSign = true;
      tag.gpgSign = true;
      user.signingKey = "~/.ssh/id_ed25519.pub";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };

    lfs.enable = true;
  };

  home.file.".ssh/allowed_signers".text = ''
    * ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvBw3klXzVq5oTXtS061cfcGEjHWflPZNRBRg48N3w/ astrumaureus@Nox
  '';

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
    extensions = with pkgs; [
      gh-markdown-preview
    ];
  };
}

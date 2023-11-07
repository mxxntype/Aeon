# INFO: OpenSSH & related settings
{ pkgs, ... }: {
  services.openssh = {
    enable = true;
    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      StreamLocalBindUnlink = "yes";  # Automatically remove stale sockets
    };

    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh.startAgent = true;
  security.pam.enableSSHAgentAuth = true; # Passwordless sudo when SSH'ing with keys
  environment.systemPackages = with pkgs; [ sshfs ];
}

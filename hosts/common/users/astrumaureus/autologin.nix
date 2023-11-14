# INFO: Auto-login as <user> (for use with full-disk encryption)

{ config, pkgs, ... }: {
  systemd.services.autologin = {
    enable = true;
    description = "Autologin on TTY1";
    after = [ "systemd-user-sessions.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.utillinux}/sbin/agetty --autologin ${config.users.users.astrumaureus.name} --noclear tty1 38400";
      Restart = "always";
      UtmpIdentifier = "tty1";
      TTYPath = "/dev/tty1";
      TTYReset = "yes";
      TTYVHangup = "yes";
      KillMode = "process";
      IgnoreSIGPIPE = "no";
      SendSIGHUP = "yes";
    };
  };

  # WARN: Can be used, but enables auto-login on all TTYs
  # services.getty.autologinUser = "astrumaureus";
}

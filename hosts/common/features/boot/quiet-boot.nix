# INFO: A nice & smooth graphical boot animation
_: {
  console = {
    useXkbConfig = true;
    earlySetup = false;
  };

  boot = {
    # WARN: Disables the grub menu and thus
    # the ability to boot a previous generation
    # loader.timeout = 0;

    # BUG: Plymouth does not `cover` the entire boot process, some messages still leak
    plymouth.enable = true;

    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
    ];

    consoleLogLevel = 0;

    initrd = {
      systemd.enable = true;
      verbose = false;
    };
  };
}

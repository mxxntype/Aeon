# INFO: PipeWire sound server

{
  pkgs,
  ...
}: {
  # HACK: https://nixos.wiki/wiki/PipeWire
  sound.enable = false;

  services.pipewire = {
    enable = true;

    # Maximize compatibility
    alsa = {
      enable = true;
      support32bit = true;
    };
    pulse.enable = true;
    jack.enable = true;

    # Explicitly enable Wireplumber (session manager)
    wireplumber.enable = true;
  };

  # Extra utilities like `alsamixer`
  # TODO: maybe add `pamixer` for easy volume control
  environment.systemPackages = [
    pkgs.alsaUtils
  ];
}

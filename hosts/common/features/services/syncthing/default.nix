# INFO: Syncthing, file synchronization service

{
  config,
  ...
}: {
  imports = [
    ./devices.nix
    ../../../users/astrumaureus # Needed to run as user
  ];

  services.syncthing = {
    enable = true;

    user = "astrumaureus";
    group = "wheel";
    dataDir = "${config.users.users.astrumaureus.home}";
    configDir = "${config.users.users.astrumaureus.home}/.config/syncthing";

    overrideDevices = true;
    overrideFolders = true;

    # TODO: Declare separately & define per-device
    settings.folders = {

      camera = {
        label = "Camera";
        path = "${config.users.users.astrumaureus.home}/Camera";
        devices = [
          "wisp"
          "wyrm"
          "luna"
          "nox"
        ];
        id = "fx4yt-picor";
      };

      music = {
        label = "Music";
        path = "${config.users.users.astrumaureus.home}/Music";
        devices = [
          "wisp"
          "wyrm"
          "luna"
          "nox"
        ];
        id = "fgjy6-qy5yl";
      };

      obsidian-vault = {
        label = "Obsidian Vault";
        path = "${config.users.users.astrumaureus.home}/Obsidian/Vault";
        devices = [
          "wisp"
          "wyrm"
          "luna"
          "nox"
        ];
        id = "3d84338a-7a26-4777-a446-67f7f8ba7faa";
      };

      shadow = {
        label = "Shadow";
        path = "${config.users.users.astrumaureus.home}/Files/.shadow";
        devices = [
          "wisp"
          "wyrm"
          "luna"
          "nox"
        ];
        id = "in9ln-y1wl5";
      };

    };

    settings = {
      gui.theme = "black";                    # Save your eyes
      options.globalAnnounceEnabled = false;  # Disable global discovery to protect IP address & save traffic
    };
  };
}

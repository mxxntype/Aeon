# INFO: Filesystems & Mountpoints, Swap & InitRD secrets

{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NOX_ROOT";
      fsType = "btrfs";
      options = [ "compress=zstd" "space_cache=v2" "subvol=@" ];
    };

    "/boot/efi" = {
      device = "/dev/disk/by-label/NOX_EFI";
      fsType = "vfat";
    };
  };

  swapDevices = [ 
    { device = "/dev/disk/by-label/NOX_SWAP"; }
  ];

  boot.initrd = {
    luks = {
      devices = {
        "root" = {
          device = "/dev/disk/by-uuid/80439606-a10d-4a03-9e57-a0e230ded885";
          preLVM = true;
          keyFile = "/keyfile_root.bin";
          allowDiscards = true;
        };
      };
    };

    # Include necessary keyfiles in the InitRD
    secrets = {
      "keyfile_root.bin" = "/etc/secrets/initrd/keyfile_root.bin"; # Root partition key
    };
  };
}

/* INFO: Wyrm: filesystems & mountpoints, swap & initRD secrets

TODO:
Current layout:
*/

{
  ...
}: {
  imports = [
    ../common/features/boot/fde.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/WYRM_ROOT";
      fsType = "btrfs";
      options = [ "ssd" "compress=zstd" "space_cache=v2" "subvol=@" ];
    };
    
    "/nix" = {
      device = "/dev/disk/by-label/WYRM_ROOT";
      fsType = "btrfs";
      options = [ "ssd" "compress=zstd" "space_cache=v2" "noatime" "subvol=@" ];
    };

    "/boot/efi" = {
      device = "/dev/disk/by-label/WYRM_EFI";
      fsType = "vfat";
    };
  };

  swapDevices = [ 
    { device = "/dev/disk/by-label/WYRM_SWAP"; }
  ];

  boot.initrd = {
    luks = {
      devices = {
        "root" = {
          device = "/dev/disk/by-uuid/bcd19d51-8559-48f3-95bc-46d204291c7e";
          preLVM = true;
          keyFile = "/keyfile_wyrm.bin";
          allowDiscards = true;
        };
      };
    };

    # Include necessary keyfiles in the InitRD
    secrets = {
      "keyfile_wyrm.bin" = "/etc/secrets/initrd/keyfile_wyrm.bin"; # Root partition key
    };
  };
}

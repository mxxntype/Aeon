/* INFO: Luna: filesystems & mountpoints, swap & initRD secrets
NAME             FSTYPE      FSVER            LABEL                      UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
nvme0n1                                                                                                                        
├─nvme0n1p1      vfat        FAT32            LUNA_EFI                   0AAA-8F72                                 511M     0% /mnt/boot
├─nvme0n1p2      crypto_LUKS 2                LUNA_ENC                   f3a18be6-ebf5-4a05-ab99-1b2e19e0f8d3                  
│ └─crypted-luna LVM2_member LVM2 001                                    JgUwvo-2yF2-p7bE-osbx-Ww1x-XDqO-GfGnuX                
│   └─luna-root  btrfs                        LUNA_ROOT                  c362417b-289c-438d-b532-307f75a4f193    823.3G     0% /mnt/home
│                                                                                                                              /mnt/nix
│                                                                                                                              /mnt
└─nvme0n1p3                                                                                                                    
*/

{
  lib,
  ...
}: {
  imports = [
    # ../common/features/boot/fde.nix
    ../common/features/boot/lanzaboote.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/LUNA_ROOT";
      fsType = "btrfs";
      options = [ "ssd" "compress=zstd" "space_cache=v2" "noatime" "subvol=@" ];
    };
    
    "/nix" = {
      device = "/dev/disk/by-label/LUNA_ROOT";
      fsType = "btrfs";
      options = [ "ssd" "compress=zstd" "space_cache=v2" "noatime" "subvol=@nix" ];
    };

    "/home" = {
      device = "/dev/disk/by-label/LUNA_ROOT";
      fsType = "btrfs";
      options = [ "ssd" "compress=zstd" "space_cache=v2" "subvol=@home" ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/LUNA_EFI";
      fsType = "vfat";
    };
  };

  boot.loader.efi.efiSysMountPoint = lib.mkForce "/boot";
  boot.initrd = {
    luks = {
      devices = {
        "root" = {
          device = "/dev/disk/by-label/LUNA_ENC";
          preLVM = true;
          # keyFile = "/keyfile-luna.bin";
          allowDiscards = true;
        };
      };
    };

    # Include necessary keyfiles in the InitRD
    # secrets = {
    #   "keyfile-wyrm.bin" = "/etc/secrets/initrd/keyfile-wyrm.bin"; # Root partition key
    # };
  };

  boot.supportedFilesystems = [ "ntfs" ];
}
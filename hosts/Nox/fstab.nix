/* INFO: Nox: filesystems & mountpoints, swap & initRD secrets

Current layout:
NAME             FSTYPE      FSVER    LABEL    UUID                                   MOUNTPOINTS
sda                                                                                   
├─sda1           vfat        FAT32    NOX_EFI  9826-C923                              /boot/efi
└─sda2           crypto_LUKS 1                 80439606-a10d-4a03-9e57-a0e230ded885   
  └─root         LVM2_member LVM2 001          n6bNKQ-uDm3-AUQj-Ofm1-UrOy-VIvO-3aaeia 
    ├─nixos-swap swap        1        NOX_SWAP 79b22e64-1c04-4bce-911c-7cb22445c43c   [SWAP]
    └─nixos-root btrfs                NOX_ROOT 934cdd09-eabd-402e-949f-d125a98b76fd   /nix/store
*/

_: {
    imports = [
        ../common/features/boot/fde.nix
    ];

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

/* INFO: Wyrm: filesystems & mountpoints, swap & initRD secrets

NAME                 FSTYPE      FSVER    LABEL        UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
sda                                                                                                          
├─sda1               vfat        FAT32    WYRM_EFI     8A9B-65E1                              1021.6M     0% /boot/efi
└─sda2               crypto_LUKS 1                     03beff81-a4b3-4f1f-8f13-2687f09cfbe7                  
  └─root             LVM2_member LVM2 001              neEcV0-Cnm8-3esJ-C9pb-jZm8-A8iZ-oeEdrO                
    ├─ssd--wyrm-swap swap        1        WYRM_SWAP    a68b17eb-6e8d-4859-9e0a-b5205efa996c                  [SWAP]
    └─ssd--wyrm-root btrfs                WYRM_ROOT    0be657d8-4a60-4d12-8b04-0fbc6309d606                  /nix/store
*/

{ config, ... }: {
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
            options = [ "ssd" "compress=zstd" "space_cache=v2" "noatime" "subvol=@nix" ];
        };
        "/boot/efi" = {
            device = "/dev/disk/by-label/WYRM_EFI";
            fsType = "vfat";
        };
        "/mnt/windows" = {
            device = "/dev/disk/by-uuid/E61AED861AED53D9";
            fsType = "ntfs";
            options = [ "rw" "uid=${builtins.toString config.users.users.astrumaureus.uid}" ];
        };
    };

    swapDevices = [ 
        { device = "/dev/disk/by-label/WYRM_SWAP"; }
    ];

    boot.initrd = {
        luks = {
            devices = {
                "root" = {
                    device = "/dev/disk/by-uuid/03beff81-a4b3-4f1f-8f13-2687f09cfbe7";
                    preLVM = true;
                    keyFile = "/keyfile-wyrm.bin";
                    allowDiscards = true;
                };
            };
        };

        # Include necessary keyfiles in the InitRD
        secrets = {
            "keyfile-wyrm.bin" = "/etc/secrets/initrd/keyfile-wyrm.bin"; # Root partition key
        };
    };

    boot.supportedFilesystems = [ "ntfs" ];
}

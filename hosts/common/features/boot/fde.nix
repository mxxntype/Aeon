/* INFO: Disk encryption

Example layout:
NAME             FSTYPE      FSVER    LABEL    MOUNTPOINTS
sda                                            
├─sdx1           vfat        FAT32    HST_EFI  /boot/efi
└─sdx2           crypto_LUKS 1                 
  └─root         LVM2_member LVM2 001          
    ├─hstnm-swap swap        1        HST_SWAP [SWAP]
    └─hstnm-root btrfs                HST_ROOT /nix/store

 TODO: Use LUKS2 & its labels instead of UUIDs
Change the label of the container:
$ sudo cryptsetup config /dev/sdb1 --label <label>

Convert a LUKS1 header into LUKS2:
$ sudo cryptsetup convert /dev/sdb1 --type luks2
*/

_: {
  boot = {
    loader = {
      # Make GRUB aware of LUKS
      grub = {
        device = "nodev";
        enableCryptodisk = true;
      };
    };
  };
}

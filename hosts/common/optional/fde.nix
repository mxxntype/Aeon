# INFO: Full disk encryption

# Encrypted filesystem layout looks something like this:
# NAME             FSTYPE      FSVER    LABEL    UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
# sda                                                                                                  
# ├─sdx1           vfat        FAT32    HST_EFI  XXXX-XXXX                                         10% /boot/efi
# └─sdx2           crypto_LUKS 1                 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                  
#   └─root         LVM2_member LVM2 001          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                
#     ├─hstnm-swap swap        1        HST_SWAP XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                  [SWAP]
#     └─hstnm-root btrfs                HST_ROOT XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                  /nix/store

# TODO: Use luks2 & its labels instead of UUIDs
# For a permanent solution to change the label of the container, use:

# $ sudo cryptsetup config /dev/sdb1 --label YOURLABEL

# Edit: Notice that labeling only works with Luks2 headers.
# In any case, it is possible to convert a Luks1 header into Luks2 with:

# $ sudo cryptsetup convert /dev/sdb1 --type luks2

# OBS: Please notice that Luks2 header occupy more space, which
# can reduce the total number of key slots. Converting Luks2 back
# to Luks1 is also possible, but there are reports of people who
# have had problems or difficulties in converting back.

{
  ...
}: {
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

# INFO: Bootloader settings
_: {
    boot = {
        loader = {
            # UEFI support
            efi = {
                canTouchEfiVariables = true; # No clue what this does...
                efiSysMountPoint = "/boot/efi";
            };

            # Use GRUB2 as the bootloader
            grub = {
                enable = true;
                efiSupport = true;    # Also UEFI support
            };
        };
    };
}

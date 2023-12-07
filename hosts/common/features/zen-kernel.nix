# INFO: The `zen` linux kernel
{ pkgs, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_zen;
}

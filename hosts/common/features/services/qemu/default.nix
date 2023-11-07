# INFO: KVM & Qemu virtualisation
{ pkgs, ... }: {
  virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [
    qemu
    virt-manager
  ];
}

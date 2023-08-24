# INFO:
# Bootloader & InitRD parameters & modules
# System architecture, microcode updates & etc.

{
  lib,
  pkgs,
  config,
  ...
}: {
  boot = {
    kernelModules = [ "kvm-intel" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "dm-snapshot" ];
    };
  };

  # Awesome brightness management tool
  hardware.brillo.enable = true;

  # lscpi
  # 00:02.0 VGA compatible controller: Intel Corporation HD Graphics 530 (rev 06)
  # 02:00.0 3D controller: NVIDIA Corporation GM107M [GeForce GTX 960M] (rev a2)

  # GPU: Nvidia GTX 960M
  services.xserver.videoDrivers = [ "intel" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  # hardware.nvidia = {
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  #   modesetting.enable = true;
  #   prime = {
  #     offload.enable = true;
  #     offload.enableOffloadCmd = true;
  #     intelBusId = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:2:0:0";
  #   };
  #   powerManagement.enable = true;
  #   enableSmartOffloadCmd = true;
  # };

  # The REAL hardware configuration
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "ondemand";
  };
}

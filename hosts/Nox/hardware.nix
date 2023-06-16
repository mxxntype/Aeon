# INFO:
# Bootloader & InitRD parameters & modules
# System architecture, microcode updates & etc.

{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

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
  services.xserver.videoDrivers = [ "nvidia" "intel" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    nvidiaPersistenced = true;
    modesetting.enable = true;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  # The REAL hardware configuration
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

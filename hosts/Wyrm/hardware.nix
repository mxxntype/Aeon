# INFO:
# Bootloader & InitRD parameters & modules
# System architecture, microcode updates & etc.

{ lib, pkgs, config, ... }: {
    boot = {
        kernelModules = [ "kvm-intel" ];
        kernelParams = [ "video=HDMI-A-2:1920x1080@74" ];

        initrd = {
            availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
            kernelModules = [ "dm-snapshot" ];
        };
    };

    # Awesome brightness management tool
    hardware.brillo.enable = true;

    # GPU: Nvidia GTX 1080
    services.xserver.videoDrivers = [ "intel" "nvidia" ];
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
    hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        prime = {
            offload.enable = true;
            offload.enableOffloadCmd = true;
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
        };
        powerManagement.enable = true;
        enableSmartOffloadCmd = true;
    };

    networking.interfaces = {
        enp0s31f6.wakeOnLan.enable = true;
    };

    # The REAL hardware configuration
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

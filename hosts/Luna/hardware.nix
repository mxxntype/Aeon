# INFO:
# Bootloader & InitRD parameters & modules
# System architecture, microcode updates & etc.

{ lib, pkgs, config, ... }: {
    boot = {
        kernelModules = [ "kvm-intel" ];
        initrd = {
            availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" ];
            kernelModules = [ "dm-snapshot" ];
        };
    };

    # Awesome brightness management tool
    hardware.brillo.enable = true;

    # IGPU: Intel Iris Xe
    system.nixos.label = "${config.networking.hostName}-iGPU";
    services.xserver.videoDrivers = [ "intel" ];
    hardware = {
        opengl = {
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
        nvidia.enableSmartOffloadCmd = true; # `smart-offload` stub
    };

    imports = [
        # Disable the dGPU with udev rules in the iGPU specialisation
        ./igpu-specialisation.nix
    ];

    # DGPU: Nvidia RTX 3050
    specialisation."dGPU" = {
        configuration = {
            system.nixos.label = lib.mkForce "${config.networking.hostName}-dGPU";
            services.xserver.videoDrivers = [ "intel" "nvidia" ];
            hardware.nvidia = {
                package = config.boot.kernelPackages.nvidiaPackages.stable;
                modesetting.enable = true;
                powerManagement.enable = true;
                prime = {
                    intelBusId = "PCI:0:2:0";
                    nvidiaBusId = "PCI:1:0:0";
                    offload = {
                        enable = true;
                        enableOffloadCmd = true;
                    };
                };
            };
        };
    };

    # The REAL hardware configuration
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

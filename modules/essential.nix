{ lib, ... }: {
  # Console on RPi UART
  boot.kernelParams = lib.mkOverride 50 [
    "console=ttyS1,115200n8"
    "console=tty0"
    "cma=128M"
  ];

  # Use the SD image's default root filesystem
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  # Enable redistributable firmware for BCM43430 wifi
  hardware.enableRedistributableFirmware = true;

  # DHCP on wlan0 for installer
  networking.interfaces.wlan0.useDHCP = true;

  # iwd-based wireless baseline (BCM43430 on RPi3B) for connectivity.
  # Keep as defaults so site-specific modules can override safely.
  networking.wireless.iwd.enable = lib.mkDefault true;
  networking.wireless.iwd.settings.General.EnableNetworkConfiguration = lib.mkDefault true;
  networking.wireless.iwd.settings.Network.EnableIPv6 = lib.mkDefault true;
  networking.wireless.iwd.settings.Rank.BandModifier5GHz = lib.mkDefault 1.5;
}

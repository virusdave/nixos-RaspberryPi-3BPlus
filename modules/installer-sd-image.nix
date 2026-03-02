{ lib, pkgs, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  # Use the SD image's default root filesystem with autoResize for fresh deployments
  fileSystems."/" = lib.mkDefault {
    autoResize = true;
  };

  # Minimal networking packages for installer debugging
  environment.systemPackages = with pkgs; [ iw ];
}

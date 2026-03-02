# NixOS System support for Raspberry Pi 3B+

Reusable Raspberry Pi board-support flake for NixOS.

## What It Exposes

- `nixosModules.default`: RPi board essentials (UART kernel params, redistributable firmware, SD rootfs defaults)
- `nixosModules.installerSdImage`: installer image support (`sd-image-aarch64`) and baseline iwd/wifi installer defaults
- `lib.withRpiEssentials`: combinator that appends board-essential module(s)
- `lib.withRpiInstallerEssentials`: combinator for board essentials + installer image module

## Example

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    rpi-3bplus.url = "github:virusdave/nixos-rpi-3bplus";
  };

  outputs = { nixpkgs, rpi-3bplus, ... }: {
    nixosConfigurations.rpi-installer = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = rpi-3bplus.lib.withRpiInstallerEssentials [
        ({ ... }: {
          networking.hostName = "rpi-installer";
          services.openssh.enable = true;
        })
      ];
    };
  };
}
```
